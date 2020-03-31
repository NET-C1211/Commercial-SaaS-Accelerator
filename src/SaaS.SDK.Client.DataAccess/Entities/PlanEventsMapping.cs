﻿using System;
using System.Collections.Generic;

namespace Microsoft.Marketplace.SaasKit.Client.DataAccess.Entities
{
    public partial class PlanEventsMapping
    {
        public int Id { get; set; }
        public int? PlanId { get; set; }
        public int? ArmtemplateId { get; set; }
        public int? EventId { get; set; }
        public bool? Isactive { get; set; }
        public string SuccessStateEmails { get; set; }
        public string FailureStateEmails { get; set; }
        public DateTime? CreateDate { get; set; }
        public int? UserId { get; set; }
    }
}
