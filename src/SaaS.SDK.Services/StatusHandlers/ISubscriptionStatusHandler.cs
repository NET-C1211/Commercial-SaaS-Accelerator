namespace Microsoft.Marketplace.SaaS.SDK.Services.StatusHandlers
{
    using System;

    /// <summary>
    /// Contract for all Subscription Status Handlers.
    /// </summary>
    public interface ISubscriptionStatusHandler
    {
        /// <summary>
        /// Processes the specified subscription identifier.
        /// </summary>
        /// <param name="subscriptionID">The subscription identifier.</param>
        void Process(Guid subscriptionID);
    }
}
