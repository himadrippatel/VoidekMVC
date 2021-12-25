using System;
using System.Collections.Generic;

namespace Alliant.ViewModel
{
    public class TreeViewRoleViewModel
    {
        public virtual int RoleID { get; set; }

        public virtual string Name { get; set; }

        public virtual Nullable<int> ParentID { get; set; }

        public virtual bool IsActive { get; set; }

        public virtual int Level { get; set; }

        public virtual string Path { get; set; }

        public virtual string ParentName { get; set; }

        public List<TreeViewRoleViewModel> Children { get; set; }
    }
}
