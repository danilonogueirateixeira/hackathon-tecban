using tecban_api.Models.Result;

namespace tecban_api.Services.Interfaces
{
    public interface IOpenBankingService
    {
        AuthenticationDataResult GetUrl(string bank);
    }
}