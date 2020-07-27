using System.Collections.Generic;

namespace tecban_api.Models.Tecban
{
    public class Accounts
    {
        public AccountData Data { get; set; }
        public LinkData Links { get; set; }
        public MetaData Meta { get; set; }
    }

    public class AccountData
    {
        public IEnumerable<ItemData> Account { get; set; }
    }

    public class ItemData
    {
        public string AccountId { get; set; }
        public string Currency { get; set; }
        public string Nickname { get; set; }
        public string AccountType { get; set; }
        public IEnumerable<Account> Account { get; set; }
    }

    public class Account
    {
        public string SchemeName { get; set; }
        public string Name { get; set; }
        public string Identification { get; set; }
    }

    public class MetaData
    {
        public int? TotalPages { get; set; }
    }

    public class LinkData
    {
        public string Self { get; set; }
    }
}