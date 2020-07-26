using System;
using Microsoft.AspNetCore.Mvc;
using tecban_api.Models.Result;
using tecban_api.Services.Interfaces;

namespace tecban_api.Controllers
{

    [ApiController]
    public class OpenBankingController : ControllerBase
    {
        private readonly IOpenBankingService service;

        public OpenBankingController(IOpenBankingService _service)
        {
            service = _service;
        }

        [HttpGet]
        [Route("[controller]/get-url/{bank}")]
        [Produces("application/json")]
        public IActionResult GetUrl(string bank)
        {
            try
            {
                if (string.IsNullOrEmpty(bank))
                    bank = "bank1";

                var result = service.GetUrl(bank.ToLower());

                if (result == null)
                {
                    throw new Exception("Ocorreu um erro ao gerar a url");
                }

                return Ok(new { success = true, result });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        [Route("[controller]/set-consent/{bank}")]
        [Produces("application/json")]
        public IActionResult SetConsent([FromBody] AuthenticationData consent, string bank)
        {
            try
            {
                if (string.IsNullOrEmpty(bank))
                    bank = "bank1";

                var result = service.SetConsent(consent, bank.ToLower());

                if (result == null)
                {
                    throw new Exception("Ocorreu um erro ao gravar o consentimento");
                }

                return Ok(new { success = true, result });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("[controller]/get-accounts/{bank}/{token}")]
        [Produces("application/json")]
        public IActionResult GetAccounts(string bank, string token)
        {
            try
            {
                if (string.IsNullOrEmpty(bank))
                    bank = "bank1";

                var result = service.GetAllAccountsData(bank.ToLower(), token);

                if (result == null)
                {
                    throw new Exception("Ocorreu um erro ao consultar as contas");
                }

                return Ok(new { success = true, result });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("[controller]/get-account/{bank}/{token}/{accountId}")]
        [Produces("application/json")]
        public IActionResult GetAccouns(string bank, string token, string accountId)
        {
            try
            {
                if (string.IsNullOrEmpty(bank))
                    bank = "bank1";

                var result = service.GetAccountData(bank.ToLower(), accountId, token);

                if (result == null)
                {
                    throw new Exception("Ocorreu um erro ao consultar a conta");
                }

                return Ok(new { success = true, result });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("[controller]/get-transactions/{bank}/{token}")]
        [Produces("application/json")]
        public IActionResult GetTransactions(string bank, string token)
        {
            try
            {
                if (string.IsNullOrEmpty(bank))
                    bank = "bank1";

                var result = service.GetAllTransactionsData(bank.ToLower(), token);

                if (result == null)
                {
                    throw new Exception("Ocorreu um erro ao consultar as transações");
                }

                return Ok(new { success = true, result });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("[controller]/get-transactions-account/{bank}/{token}/{accountId}")]
        [Produces("application/json")]
        public IActionResult GetTransactionsAccount(string bank, string token, string accountId)
        {
            try
            {
                if (string.IsNullOrEmpty(bank))
                    bank = "bank1";

                var result = service.GetAllTransactionsAccountData(bank.ToLower(), accountId, token);

                if (result == null)
                {
                    throw new Exception("Ocorreu um erro ao consultar a transação");
                }

                return Ok(new { success = true, result });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("[controller]/get-last-transaction/{bank}/{token}")]
        [Produces("application/json")]
        public IActionResult GetLastTransaction(string bank, string token)
        {
            try
            {
                if (string.IsNullOrEmpty(bank))
                    bank = "bank1";

                var result = service.GetLastTransaction(bank.ToLower(), token);

                if (result == null)
                {
                    throw new Exception("Ocorreu um erro ao consultar a transação");
                }

                return Ok(new { success = true, result });
            }
            catch (Exception ex)
            {
                return BadRequest(new { success = false, message = ex.Message });
            }
        }
    }
}