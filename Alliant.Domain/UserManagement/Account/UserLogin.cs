namespace Alliant.Domain
{

    public class UserLogin: RootEntity
    {
        public long UserLoginID { get; set; }

        public int UserID { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public bool IsRemeber { get; set; }
        public string Message { get; set; }
    }
}
