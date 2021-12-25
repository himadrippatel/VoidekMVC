using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IIconManager : IRootManager
    {
        Icon Create();
        Icon CreatePost(Icon oIcon);
    	Icon Edit(int Id);
    	Icon EditPost(Icon oIcon);
    	Icon Delete(int Id);
    	int DeletePost(int Id);
    	Icon GetIconById(int Id);
    	//IEnumerable<Icon> GetAllIcon(Search_IconModel oIcon);   
    	IEnumerable<Icon> GetAllIcon(GridSearchModel oGridSearchModel);   
    }
}
