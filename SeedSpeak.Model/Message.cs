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
    public partial class Message
    {
        #region Primitive Properties
    
        public virtual System.Guid id
        {
            get;
            set;
        }
    
        public virtual string type
        {
            get;
            set;
        }
    
        public virtual string displayMessage
        {
            get;
            set;
        }
    
        public virtual Nullable<int> typeId
        {
            get;
            set;
        }

        #endregion
    }
}