using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using tecban_api.Models.Result;
using tecban_api.Models.Tecban;
using tecban_api.Services.Interfaces;

namespace tecban_api.Services
{
    public class OpenBankingService : IOpenBankingService
    {
        private readonly IConfiguration configuration;
        private X509Certificate2 certificate;
        private AuthenticationHeaderValue basicAuthentication;

        public OpenBankingService(IConfiguration _configuration)
        {
            configuration = _configuration;
        }

        public AuthenticationDataResult GetUrl(string bank)
        {
            basicAuthentication = GetBasicAuthentication(bank);

            var content = new Dictionary<string, string>()
            {
                { "grant_type", "client_credentials" },
                { "scope", "accounts openid" }
            };

            var url = bank.Equals("bank1")
                ? configuration["tecban-bank1:token-endpoint"]
                : configuration["tecban-bank2:token-endpoint"];
            
            certificate = GetCertificate(bank);

            var token = PostCast<Token>(url, "token", string.Empty, content);

            var consents = SetConsents(bank, token.access_token);

            consents = GetConsentById(bank, consents.Data.ConsentId, token.access_token);

            var resultUrl = GetCodeUrl(bank, consents.Data.ConsentId, token.access_token);

            return new AuthenticationDataResult
            {
                UrlAuthentication = resultUrl,
                AccessToken = token.access_token,
                ConsentId = consents.Data.ConsentId,
                TransactionDate = DateTime.Now,
                ExpiresIn = token.expires_in
            };
        }

        public AccountAccessConsents SetConsents(string bank, string access_token)
        {
            var permission = new AccountAccessConsents
            {
                Data = new Permission
                {
                    Permissions = new string[]
                    {
                        "ReadAccountsBasic",
                        "ReadAccountsDetail",
                        "ReadBalances",
                        "ReadBeneficiariesBasic",
                        "ReadBeneficiariesDetail",
                        "ReadDirectDebits",
                        "ReadTransactionsBasic",
                        "ReadTransactionsCredits",
                        "ReadTransactionsDebits",
                        "ReadTransactionsDetail",
                        "ReadProducts",
                        "ReadStandingOrdersDetail",
                        "ReadProducts",
                        "ReadStandingOrdersDetail",
                        "ReadStatementsDetail",
                        "ReadParty",
                        "ReadOffers",
                        "ReadScheduledPaymentsBasic",
                        "ReadScheduledPaymentsDetail",
                        "ReadPartyPSU"
                    }
                },
                Risk = new Risk { }
            };

            var url = bank.Equals("bank1")
                ? configuration["tecban-bank1:bearer-endpoint"]
                : configuration["tecban-bank2:bearer-endpoint"];

            var consents = PostCast<AccountAccessConsents>(url, "open-banking/v3.1/aisp/account-access-consents",
                JsonConvert.SerializeObject(permission, new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                }), null, access_token);

            return consents;
        }

        public AccountAccessConsents GetConsentById(string bank, string consentId, string access_token)
        {
            var bearer = bank.Equals("bank1")
                ? configuration["tecban-bank1:bearer-endpoint"]
                : configuration["tecban-bank2:bearer-endpoint"];

            var consents = GetCast<AccountAccessConsents>(bearer, $"open-banking/v3.1/aisp/account-access-consents/{consentId}", access_token);

            return consents;
        }


        public string GetCodeUrl(string bank, string consentId, string access_token)
        {
            basicAuthentication = GetBasicAuthentication(bank);

            var urlBase = bank.Equals("bank1")
                ? configuration["tecban-bank1:bearer-endpoint"]
                : configuration["tecban-bank2:bearer-endpoint"];

            var urlResult = GetCast<string>(urlBase, $"ozone/v1.0/auth-code-url/{consentId}?scope=accounts&alg=none", null);

            return urlResult.ToString();
        }

        private T PostCast<T>(string url, string path, string json, Dictionary<string, string> data, string token = null)
        {
            var handler = new HttpClientHandler
            {
                ClientCertificateOptions = ClientCertificateOption.Manual,
                SslProtocols = SslProtocols.Tls12
            };

            handler.ClientCertificates.Add(certificate);
            handler.ServerCertificateCustomValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

            using (HttpClient httpClient = new HttpClient(handler))
            {
                httpClient.BaseAddress = new Uri(url);

                if (string.IsNullOrEmpty(token))
                {
                    httpClient.DefaultRequestHeaders.Authorization = basicAuthentication;
                }
                else
                {
                    httpClient.DefaultRequestHeaders.Authorization
                        = new AuthenticationHeaderValue("Bearer", token);
                    httpClient.DefaultRequestHeaders.Add("x-fapi-financial-id", configuration["x-fapi-financial-id"]);
                    httpClient.DefaultRequestHeaders.Add("x-fapi-interaction-id", configuration["x-fapi-interaction-id"]);
                    httpClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json"));
                }

                var response = string.IsNullOrEmpty(json)
                    ? httpClient.PostAsync($"{url}/{path}", new FormUrlEncodedContent(data)).Result
                    : httpClient.PostAsync($"{url}/{path}", new StringContent(json, Encoding.UTF8, "application/json")).Result;
                
                if (!response.StatusCode.Equals(HttpStatusCode.OK)
                    && !response.StatusCode.Equals(HttpStatusCode.Created))
                    throw new Exception(response.ReasonPhrase);

                return JsonConvert.DeserializeObject<T>(response.Content.ReadAsStringAsync().Result);
            }
        }

        private T GetCast<T>(string url, string path, string token = null)
        {
            var handler = new HttpClientHandler
            {
                ClientCertificateOptions = ClientCertificateOption.Manual,
                SslProtocols = SslProtocols.Tls12
            };

            handler.ClientCertificates.Add(certificate);
            handler.ServerCertificateCustomValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

            using (HttpClient httpClient = new HttpClient(handler))
            {
                httpClient.BaseAddress = new Uri(url);
                if (string.IsNullOrEmpty(token))
                {
                    httpClient.DefaultRequestHeaders.Authorization = basicAuthentication;
                }
                else
                {
                    httpClient.DefaultRequestHeaders.Authorization
                            = new AuthenticationHeaderValue("Bearer", token);
                        httpClient.DefaultRequestHeaders.Add("x-fapi-financial-id", configuration["x-fapi-financial-id"]);
                        httpClient.DefaultRequestHeaders.Add("x-fapi-interaction-id", configuration["x-fapi-interaction-id"]);
                        httpClient.DefaultRequestHeaders.Accept.Add(
                            new MediaTypeWithQualityHeaderValue("application/json"));
                }

                var response = httpClient.GetAsync($"{url}/{path}").Result;

                if (path.Contains(@"ozone/v1.0/auth-code-url"))
                    return (T)Convert.ChangeType(response.Content.ReadAsStringAsync().Result, typeof(T));

                return JsonConvert.DeserializeObject<T>(response.Content.ReadAsStringAsync().Result);
            }
        }

        private X509Certificate2 GetCertificate(string bank)
        {
            return new X509Certificate2(
                Path.Combine(Environment.CurrentDirectory, "certs", bank.Equals("bank1")
                    ? "client_certificate_s1.pfx"
                    : "client_certificate_s2.pfx"),
                configuration["self-certificate-password"]);
        }

        private AuthenticationHeaderValue GetBasicAuthentication(string bank)
        {
            return new AuthenticationHeaderValue("Basic", bank.Equals("bank1")
                    ? configuration["token-tecban-bank1"]
                    : configuration["token-tecban-bank2"]);
        }
    }
}