﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Marketplace.SaaS.SDK.Services.Models
{
    public class OffersModel
    {
        public int Id { get; set; }
        public string offerID { get; set; }

        public string offerName { get; set; }

        public DateTime? CreateDate { get; set; }

        public int? UserID { get; set; }

        public Guid? offerGuId { get; set; }
    }
}
