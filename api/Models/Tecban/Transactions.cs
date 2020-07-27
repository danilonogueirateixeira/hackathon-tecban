using System;
using System.Collections.Generic;

namespace tecban_api.Models.Tecban
{
    public class Transactions
    {
        public TransactionData Data { get; set; }
        public LinkData Links { get; set; }
        public MetaData Meta { get; set; }
    }

    public class TransactionData
    {
        public IEnumerable<ItemTransactionData> Transaction { get; set; }
    }

    public class ItemTransactionData
    {
        public string AccountId { get; set; }
        public DateTime? BookingDateTime { get; set; }
        public DateTime? ValueDateTime { get; set; }
        public string TransactionInformation { get; set; }
        public string TransactionId { get; set; }
        public string CreditDebitIndicator { get; set; }
        public string Status { get; set; }
        public string TransactionMutability { get; set; }
        public string TransactionReference { get; set; }
        public ItemAmount Amount { get; set; }
        public ItemBankTransaction BankTransactionCode { get; set; }
        public ItemBalance Balance { get; set; }
    }

    public class ItemAmount
    {
        public string Amount { get; set; }
        public string Currency { get; set; }
    }

    public class ItemMerchantDetails
    {

    }

    public class ItemBankTransaction
    {
        public string Code { get; set; }
        public string SubCode { get; set; }
    }

    public class ItemBalance
    {
        public ItemAmount Amount { get; set; }
        public string CreditDebitIndicator { get; set; }
        public string Type { get; set; }
    }
}