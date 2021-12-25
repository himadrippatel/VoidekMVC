using Alliant.DalLayer;
using Alliant.Domain;
using System;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public class IconManager : DALProvider,IIconManager
    {
    	IIconDAL oIconDal =  null;  
    
    	public IconManager()
    	{
    		oIconDal = DALAdministrator.IconDAL;
    	}
    
    	public virtual Icon Create()
    	{
    		return new Icon();
    	}
    
        public virtual Icon CreatePost(Icon oIcon)
    	{
            oIcon.CreatedOn = DateTime.Now;
            oIconDal.CreateIcon(oIcon);
    		return oIcon;
    	}
    
    	public virtual Icon Edit(int Id)
    	{
    		return oIconDal.GetIconById(Id);
    	}
    
    	public virtual Icon EditPost(Icon oIcon)
    	{   
    		oIconDal.UpdateIcon(oIcon);
    		return oIcon;
    	}
    
    	public virtual Icon Delete(int Id)
    	{
    		return oIconDal.GetIconById(Id);
    	}
    
    	public virtual int DeletePost(int Id)
    	{
    		return oIconDal.DeleteIcon(Id);
    	}
    
    	public virtual Icon GetIconById(int Id)
    	{
    		return oIconDal.GetIconById(Id);
    	}
    
    	/*public virtual IEnumerable<Icon> GetAllIcon(Search_IconModel oIcon)
    	{
    		return oIconDal.GetIconBySearch(oIcon);
    	}*/  
    	
    	public virtual IEnumerable<Icon> GetAllIcon(GridSearchModel oGridSearchModel)
    	{
    		return oIconDal.GetIconBySearch(oGridSearchModel);
    	}
    }
}
