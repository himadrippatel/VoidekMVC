using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IIconDAL : IDALBase
    {
        int CreateIcon(Icon oIcon);
        int UpdateIcon(Icon oIcon);
    	int DeleteByModelIcon(Icon oIcon);
    	int DeleteIcon(int Id);
    	Icon GetIconById(int Id);
        //IEnumerable<Icon> GetIconBySearch(Search_IconModel oSearch_IconModel);  
    	IEnumerable<Icon> GetIconBySearch(GridSearchModel oGridSearchModel);
    }
}
