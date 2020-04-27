﻿using System;
using System.Collections.Generic;
using System.Text;

namespace Saas.SDK.WebJob.Models
{
    public class SubscriptionTemplateParametersModel
    {
        public int Id { get; set; }
        public string OfferName { get; set; }
        public Guid? OfferGuid { get; set; }
        public Guid? PlanGuid { get; set; }
        public string PlanId { get; set; }
        public Guid? ArmtemplateId { get; set; }
        public string Parameter { get; set; }
        public string ParameterDataType { get; set; }
        public string Value { get; set; }
        public string ParameterType { get; set; }
        public int? EventId { get; set; }
        public string EventsName { get; set; }
        public Guid? AmpsubscriptionId { get; set; }
        public string SubscriptionStatus { get; set; }
        public string SubscriptionName { get; set; }
        public DateTime? CreateDate { get; set; }
        public int? UserId { get; set; }
    }
}
