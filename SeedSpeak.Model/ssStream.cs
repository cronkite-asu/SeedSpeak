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
    public partial class ssStream
    {
        #region Primitive Properties
    
        public virtual System.Guid id
        {
            get;
            set;
        }
    
        public virtual string title
        {
            get;
            set;
        }
    
        public virtual string description
        {
            get;
            set;
        }
    
        public virtual string criteria
        {
            get;
            set;
        }
    
        public virtual string streamType
        {
            get;
            set;
        }
    
        public virtual Nullable<System.Guid> ownerId
        {
            get { return _ownerId; }
            set
            {
                try
                {
                    _settingFK = true;
                    if (_ownerId != value)
                    {
                        if (Member != null && Member.id != value)
                        {
                            Member = null;
                        }
                        _ownerId = value;
                    }
                }
                finally
                {
                    _settingFK = false;
                }
            }
        }
        private Nullable<System.Guid> _ownerId;
    
        public virtual Nullable<System.Guid> locationId
        {
            get { return _locationId; }
            set
            {
                try
                {
                    _settingFK = true;
                    if (_locationId != value)
                    {
                        if (Location != null && Location.id != value)
                        {
                            Location = null;
                        }
                        _locationId = value;
                    }
                }
                finally
                {
                    _settingFK = false;
                }
            }
        }
        private Nullable<System.Guid> _locationId;
    
        public virtual Nullable<bool> isPublic
        {
            get;
            set;
        }
    
        public virtual Nullable<System.DateTime> createDate
        {
            get;
            set;
        }
    
        public virtual string status
        {
            get;
            set;
        }

        #endregion
        #region Navigation Properties
    
        public virtual Location Location
        {
            get { return _location; }
            set
            {
                if (!ReferenceEquals(_location, value))
                {
                    var previousValue = _location;
                    _location = value;
                    FixupLocation(previousValue);
                }
            }
        }
        private Location _location;
    
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
    
        public virtual ICollection<Seed> Seeds
        {
            get
            {
                if (_seeds == null)
                {
                    var newCollection = new FixupCollection<Seed>();
                    newCollection.CollectionChanged += FixupSeeds;
                    _seeds = newCollection;
                }
                return _seeds;
            }
            set
            {
                if (!ReferenceEquals(_seeds, value))
                {
                    var previousValue = _seeds as FixupCollection<Seed>;
                    if (previousValue != null)
                    {
                        previousValue.CollectionChanged -= FixupSeeds;
                    }
                    _seeds = value;
                    var newValue = value as FixupCollection<Seed>;
                    if (newValue != null)
                    {
                        newValue.CollectionChanged += FixupSeeds;
                    }
                }
            }
        }
        private ICollection<Seed> _seeds;
    
        public virtual ICollection<Category> Categories
        {
            get
            {
                if (_categories == null)
                {
                    var newCollection = new FixupCollection<Category>();
                    newCollection.CollectionChanged += FixupCategories;
                    _categories = newCollection;
                }
                return _categories;
            }
            set
            {
                if (!ReferenceEquals(_categories, value))
                {
                    var previousValue = _categories as FixupCollection<Category>;
                    if (previousValue != null)
                    {
                        previousValue.CollectionChanged -= FixupCategories;
                    }
                    _categories = value;
                    var newValue = value as FixupCollection<Category>;
                    if (newValue != null)
                    {
                        newValue.CollectionChanged += FixupCategories;
                    }
                }
            }
        }
        private ICollection<Category> _categories;

        #endregion
        #region Association Fixup
    
        private bool _settingFK = false;
    
        private void FixupLocation(Location previousValue)
        {
            if (previousValue != null && previousValue.ssStreams.Contains(this))
            {
                previousValue.ssStreams.Remove(this);
            }
    
            if (Location != null)
            {
                if (!Location.ssStreams.Contains(this))
                {
                    Location.ssStreams.Add(this);
                }
                if (locationId != Location.id)
                {
                    locationId = Location.id;
                }
            }
            else if (!_settingFK)
            {
                locationId = null;
            }
        }
    
        private void FixupMember(Member previousValue)
        {
            if (previousValue != null && previousValue.ssStreams.Contains(this))
            {
                previousValue.ssStreams.Remove(this);
            }
    
            if (Member != null)
            {
                if (!Member.ssStreams.Contains(this))
                {
                    Member.ssStreams.Add(this);
                }
                if (ownerId != Member.id)
                {
                    ownerId = Member.id;
                }
            }
            else if (!_settingFK)
            {
                ownerId = null;
            }
        }
    
        private void FixupSeeds(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (e.NewItems != null)
            {
                foreach (Seed item in e.NewItems)
                {
                    if (!item.ssStreams.Contains(this))
                    {
                        item.ssStreams.Add(this);
                    }
                }
            }
    
            if (e.OldItems != null)
            {
                foreach (Seed item in e.OldItems)
                {
                    if (item.ssStreams.Contains(this))
                    {
                        item.ssStreams.Remove(this);
                    }
                }
            }
        }
    
        private void FixupCategories(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (e.NewItems != null)
            {
                foreach (Category item in e.NewItems)
                {
                    if (!item.ssStreams.Contains(this))
                    {
                        item.ssStreams.Add(this);
                    }
                }
            }
    
            if (e.OldItems != null)
            {
                foreach (Category item in e.OldItems)
                {
                    if (item.ssStreams.Contains(this))
                    {
                        item.ssStreams.Remove(this);
                    }
                }
            }
        }

        #endregion
    }
}
