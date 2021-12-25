using Alliant.Domain;
using System.Collections.Generic;
using Alliant.DalLayer;
using System;
using System.Transactions;

namespace Alliant.Manager
{

    public class MenuManager : DALProvider, IMenuManager
    {
        IMenuDAL oMenuDal = null;
        AlliantTransaction alliantTransaction = new AlliantTransaction();

        public MenuManager()
        {
            oMenuDal = DALUserManagement.MenuDAL;
        }
        
        public virtual Menu Create()
        {
            return new Menu();
        }

        public virtual Menu CreatePost(Menu oMenu)
        {
            oMenu.CreatedOn = DateTime.Now;
            oMenu.UpdatedOn = DateTime.Now;

            oMenuDal.CreateMenu(oMenu);
            return oMenu;
        }

        public virtual Menu Edit(int Id)
        {
            return oMenuDal.GetMenuById(Id);
        }

        public virtual Menu EditPost(Menu oMenu)
        {
            oMenu.UpdatedOn = DateTime.Now;
            oMenuDal.UpdateMenu(oMenu);
            return oMenu;
        }

        public virtual Menu Delete(int Id)
        {
            return oMenuDal.GetMenuById(Id);
        }

        public virtual int DeletePost(int Id)
        {
            return oMenuDal.DeleteMenu(Id);
        }

        public virtual Menu GetMenuById(int Id)
        {
            return oMenuDal.GetMenuById(Id);
        }

        /*public virtual IEnumerable<Menu> GetAllMenu(Search_MenuModel oMenu)
    	{
    		return oMenuDal.GetMenuBySearch(oMenu);
    	}*/

        public virtual IEnumerable<Menu> GetAllMenu(GridSearchModel oGridSearchModel)
        {
            return oMenuDal.GetMenuBySearch(oGridSearchModel);
        }

        public int UpdateSequance(List<Menu> menus)
        {
            int result = 0;          

            using (TransactionScope transaction = new TransactionScope())
            {
                try
                {
                    foreach (var menu in menus)
                    {
                        result += oMenuDal.UpdateSequance(menu);
                    }
                    transaction.Complete();                   
                }
                catch (Exception ex)
                {
                    transaction.Dispose();
                    throw ex;
                }
            }

            return result;
        }
    }
}
