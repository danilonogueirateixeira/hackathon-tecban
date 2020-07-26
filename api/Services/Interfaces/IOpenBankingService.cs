using System.Transactions;
using tecban_api.Models.Result;
using tecban_api.Models.Tecban;

namespace tecban_api.Services.Interfaces
{
    public interface IOpenBankingService
    {
        AuthenticationData GetUrl(string bank);
        AuthenticationData SetConsent(AuthenticationData consent, string bank);
        Accounts GetAllAccountsData(string bank, string access_token);
        Account GetAccountData(string bank, string access_token, string accountId);
        Transactions GetAllTransactionsData(string bank, string access_token);
        Transactions GetAllTransactionsAccountData(string bank, string access_token, string accountId);
        ItemTransactionData GetLastTransaction(string bank, string access_token);
        
    }
}