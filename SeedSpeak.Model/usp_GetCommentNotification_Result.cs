//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;

namespace SeedSpeak.Model
{
    public partial class usp_GetCommentNotification_Result
    {
        #region Primitive Properties
    
        public string Notify
        {
            get;
            set;
        }
    
        public Nullable<System.DateTime> commentDate
        {
            get;
            set;
        }
    
        public Nullable<int> TotalCount
        {
            get;
            set;
        }
    
        public System.Guid id
        {
            get;
            set;
        }
    
        public Nullable<System.Guid> MemberID
        {
            get;
            set;
        }
    
        public Nullable<System.Guid> SeedID
        {
            get;
            set;
        }
    
        public string MemberName
        {
            get;
            set;
        }

        #endregion
    }
}