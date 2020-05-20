﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE file in the project root for license information.
namespace Microsoft.Marketplace.SaasKit.Models
{
    using Microsoft.Marketplace.SaasKit.Attributes;

    /// <summary>
    /// Get Fulfillment Result.
    /// </summary>
    public class SaaSApiResult
    {
        /// <summary>
        /// Gets or sets the request identifier.
        /// </summary>
        /// <value>
        /// The request identifier.
        /// </value>
        [FromRequestHeader("x-ms-requestid")]
        public string RequestID { get; set; }
    }
}