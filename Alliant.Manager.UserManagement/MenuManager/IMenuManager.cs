using System;
using System.Linq;
using System.Collections;
using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IMenuManager : IRootManager
    {
        Menu Create();
        Menu CreatePost(Menu oMenu);
    	Menu Edit(int Id);
    	Menu EditPost(Menu oMenu);
    	Menu Delete(int Id);
    	int DeletePost(int Id);
    	Menu GetMenuById(int Id);
    	//IEnumerable<Menu> GetAllMenu(Search_MenuModel oMenu);   
    	IEnumerable<Menu> GetAllMenu(GridSearchModel oGridSearchModel);
        int UpdateSequance(List<Menu> menus);
    }
}
