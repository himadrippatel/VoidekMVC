using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
                      
    public interface IMenuDAL : IDALBase
    {
        int CreateMenu(Menu oMenu);
        int UpdateMenu(Menu oMenu);
    	int DeleteByModelMenu(Menu oMenu);
    	int DeleteMenu(int Id);
    	Menu GetMenuById(int Id);
        //IEnumerable<Menu> GetMenuBySearch(Search_MenuModel oSearch_MenuModel);  
    	IEnumerable<Menu> GetMenuBySearch(GridSearchModel oGridSearchModel);
        int UpdateSequance(Menu oMenu);
    }
}
