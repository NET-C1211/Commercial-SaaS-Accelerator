﻿namespace Microsoft.Marketplace.SaasKit.Client.DataAccess.Services
{
    using Microsoft.Marketplace.SaasKit.Client.DataAccess.Context;
    using Microsoft.Marketplace.SaasKit.Client.DataAccess.Contracts;
    using Microsoft.Marketplace.SaasKit.Client.DataAccess.Entities;
    using System.Linq;

    /// <summary>
    /// Repository to access Email Templates
    /// </summary>
    /// <seealso cref="Microsoft.Marketplace.SaasKit.Client.DataAccess.Contracts.IEmailTemplateRepository" />
    public class EmailTemplateRepository : IEmailTemplateRepository
    {
        /// <summary>
        /// The context
        /// </summary>
        private readonly SaasKitContext context;

        public EmailTemplateRepository(SaasKitContext context)
        {
            this.context = context;
        }

        /// <summary>
        /// Gets the email template for subscription status.
        /// </summary>
        /// <param name="status">The subscription status.</param>
        /// <returns>
        /// Email template relevant to the status of the subscription
        /// </returns>
        public EmailTemplate GetTemplateForStatus(string status)
        {
            var template = context.EmailTemplate.Where(s => s.Status == status).FirstOrDefault();
            if (template != null)
            {
                return template;
            }
            return null;
        }
    }
}
