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
    public partial class HideUnhide
    {
        #region Primitive Properties
    
        public virtual System.Guid id
        {
            get;
            set;
        }
    
        public virtual Nullable<System.Guid> memId
        {
            get { return _memId; }
            set
            {
                try
                {
                    _settingFK = true;
                    if (_memId != value)
                    {
                        if (Member != null && Member.id != value)
                        {
                            Member = null;
                        }
                        _memId = value;
                    }
                }
                finally
                {
                    _settingFK = false;
                }
            }
        }
        private Nullable<System.Guid> _memId;
    
        public virtual Nullable<System.Guid> seedId
        {
            get { return _seedId; }
            set
            {
                try
                {
                    _settingFK = true;
                    if (_seedId != value)
                    {
                        if (Seed != null && Seed.id != value)
                        {
                            Seed = null;
                        }
                        _seedId = value;
                    }
                }
                finally
                {
                    _settingFK = false;
                }
            }
        }
        private Nullable<System.Guid> _seedId;

        #endregion
        #region Navigation Properties
    
        public virtual Member Member
        {
            get { return _member; }
            set
            {
                if (!ReferenceEquals(_member, value))
                {
                    var previousValue = _member;
                    _member = value;
                    FixupMember(previousValue);
                }
            }
        }
        private Member _member;
    
        public virtual Seed Seed
        {
            get { return _seed; }
            set
            {
                if (!ReferenceEquals(_seed, value))
                {
                    var previousValue = _seed;
                    _seed = value;
                    FixupSeed(previousValue);
                }
            }
        }
        private Seed _seed;

        #endregion
        #region Association Fixup
    
        private bool _settingFK = false;
    
        private void FixupMember(Member previousValue)
        {
            if (previousValue != null && previousValue.HideUnhides.Contains(this))
            {
                previousValue.HideUnhides.Remove(this);
            }
    
            if (Member != null)
            {
                if (!Member.HideUnhides.Contains(this))
                {
                    Member.HideUnhides.Add(this);
                }
                if (memId != Member.id)
                {
                    memId = Member.id;
                }
            }
            else if (!_settingFK)
            {
                memId = null;
            }
        }
    
        private void FixupSeed(Seed previousValue)
        {
            if (previousValue != null && previousValue.HideUnhides.Contains(this))
            {
                previousValue.HideUnhides.Remove(this);
            }
    
            if (Seed != null)
            {
                if (!Seed.HideUnhides.Contains(this))
                {
                    Seed.HideUnhides.Add(this);
                }
                if (seedId != Seed.id)
                {
                    seedId = Seed.id;
                }
            }
            else if (!_settingFK)
            {
                seedId = null;
            }
        }

        #endregion
    }
}