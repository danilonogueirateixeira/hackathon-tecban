using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
    }
}