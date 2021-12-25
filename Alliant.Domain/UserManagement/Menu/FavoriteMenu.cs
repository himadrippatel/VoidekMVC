using System;

namespace Alliant.Domain
{
    public class FavoriteMenu
    {
        public int FavoriteMenuID { get; set; }

        public int UserID { get; set; }

        public string LinkText { get; set; }

        public string LinkHref { get; set; }

        public int? MenuID { get; set; }

        public int? SubMenuID { get; set; }

        public bool IsFavorite { get; set; }

        public DateTime? CreatedOn { get; set; }

        public string CreatedBy { get; set; }
    }
}
