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
    public partial class MemberReplySeed
    {
        #region Primitive Properties
    
        public virtual System.Guid id
        {
            get;
            set;
        }
    
        public virtual Nullable<System.Guid> memberID
        {
            get { return _memberID; }
            set
            {
                try
                {
                    _settingFK = true;
                    if (_memberID != value)
                    {
                        if (Member != null && Member.id != value)
                        {
                            Member = null;
                        }
                        _memberID = value;
                    }
                }
                finally
                {
                    _settingFK = false;
                }
            }
        }
        private Nullable<System.Guid> _memberID;
    
        public virtual Nullable<System.Guid> seedID
        {
            get { return _seedID; }
            set
            {
                try
                {
                    _settingFK = true;
                    if (_seedID != value)
                    {
                        if (Seed != null && Seed.id != value)
                        {
                            Seed = null;
                        }
                        _seedID = value;
                    }
                }
                finally
                {
                    _settingFK = false;
                }
            }
        }
        private Nullable<System.Guid> _seedID;

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
            if (previousValue != null && previousValue.MemberReplySeeds.Contains(this))
            {
                previousValue.MemberReplySeeds.Remove(this);
            }
    
            if (Member != null)
            {
                if (!Member.MemberReplySeeds.Contains(this))
                {
                    Member.MemberReplySeeds.Add(this);
                }
                if (memberID != Member.id)
                {
                    memberID = Member.id;
                }
            }
            else if (!_settingFK)
            {
                memberID = null;
            }
        }
    
        private void FixupSeed(Seed previousValue)
        {
            if (previousValue != null && previousValue.MemberReplySeeds.Contains(this))
            {
                previousValue.MemberReplySeeds.Remove(this);
            }
    
            if (Seed != null)
            {
                if (!Seed.MemberReplySeeds.Contains(this))
                {
                    Seed.MemberReplySeeds.Add(this);
                }
                if (seedID != Seed.id)
                {
                    seedID = Seed.id;
                }
            }
            else if (!_settingFK)
            {
                seedID = null;
            }
        }

        #endregion
    }
}
