using System;

namespace tecban_api.Models.Tecban
{
    public class AccountAccessConsents
    {
        public Permission Data { get; set; }
        public Risk Risk { get; set; }
    }

    public class Permission
    {
        public string[] Permissions { get; set; }
        public string ConsentId { get; set; }
        public DateTime? CreationDateTime { get; set; }
        public string Status { get; set; }
        public DateTime? StatusUpdateDateTime { get; set; }
    }

    public class Risk
    {

    }
}