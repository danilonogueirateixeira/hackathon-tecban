using System;

namespace tecban_api.Models.Result
{
    public class AuthenticationData
    {
        public string AccessToken { get; set; }
        public string ConsentId { get; set; }
        public string UrlAuthentication { get; set; }
        public DateTime? TransactionDate { get; set; }
        public int? ExpiresIn { get; set; }
    }
}