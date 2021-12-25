using Alliant.DalLayer;
using Alliant.Domain;
using Alliant.ViewModel;
using System;
using System.Collections.Generic;
using System.Transactions;

namespace Alliant.Manager
{

    public class RoleVsUserManager : DALProvider, IRoleVsUserManager
    {
        IRoleVsUserDAL oRoleVsUserDal = null;

        public RoleVsUserManager()
        {
            oRoleVsUserDal = DALUserManagement.RoleVsUserDAL;
        }

        public virtual RoleVsUser Create()
        {
            return new RoleVsUser();
        }

        public virtual bool CreatePost(RoleVsUserViewModel roleVsUserViewModel)
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                try
                {
                    if (roleVsUserViewModel.UserIDs != null && roleVsUserViewModel.UserIDs.Length > 0)
                    {
                        string[] roleIDs = roleVsUserViewModel.RoleIDs.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        if (roleIDs != null && roleIDs.Length > 0)
                        {
                            foreach (int userid in roleVsUserViewModel.UserIDs)
                            {
                                foreach (string roleID in roleIDs)
                                {
                                    oRoleVsUserDal.CreateRoleVsUser(new RoleVsUser()
                                    {
                                        CreatedOn = DateTime.Now,
                                        UpdatedOn = DateTime.Now,
                                        UserID = userid,
                                        RoleID = Convert.ToInt32(roleID)
                                    });
                                }
                            }
                        }                        
                    }
                    transaction.Complete();
                    return true;
                }
                catch (Exception ex)
                {
                    transaction.Dispose();
                    throw ex;
                }
            }
        }

        public virtual RoleVsUser Edit(int Id)
        {
            return oRoleVsUserDal.GetRoleVsUserById(Id);
        }

        public virtual RoleVsUser EditPost(RoleVsUser oRoleVsUser)
        {
            oRoleVsUserDal.UpdateRoleVsUser(oRoleVsUser);
            return oRoleVsUser;
        }

        public virtual RoleVsUser Delete(int Id)
        {
            return oRoleVsUserDal.GetRoleVsUserById(Id);
        }

        public virtual int DeletePost(int Id)
        {
            return oRoleVsUserDal.DeleteRoleVsUser(Id);
        }

        public virtual RoleVsUser GetRoleVsUserById(int Id)
        {
            return oRoleVsUserDal.GetRoleVsUserById(Id);
        }

        /*public virtual IEnumerable<RoleVsUser> GetAllRoleVsUser(Search_RoleVsUserModel oRoleVsUser)
    	{
    		return oRoleVsUserDal.GetRoleVsUserBySearch(oRoleVsUser);
    	}*/

        public virtual IEnumerable<RoleVsUser> GetAllRoleVsUser(GridSearchModel oGridSearchModel)
        {
            return oRoleVsUserDal.GetRoleVsUserBySearch(oGridSearchModel);
        }

        public virtual IEnumerable<AutoCompleteViewModel> GetCustomerAutoCompleteViewModels(string search, string notIn)
        {
            return oRoleVsUserDal.GetCustomerAutoCompleteViewModels(search, notIn);
        }

        public virtual SelectViewModel GetCustomerSelectViewModels(SearchRequest searchRequest)
        {
            return oRoleVsUserDal.GetCustomerSelectViewModels(searchRequest);
        }
    }
}
