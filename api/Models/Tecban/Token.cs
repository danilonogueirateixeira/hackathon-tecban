namespace tecban_api.Models.Tecban
{
    public class Token
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
        public int? expires_in { get; set; }
    }
}