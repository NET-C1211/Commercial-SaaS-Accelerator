﻿using Microsoft.Azure.Management.ResourceManager.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Marketplace.SaasKit.Client.DataAccess.Context;
using Microsoft.Marketplace.SaasKit.Client.DataAccess.Contracts;
using Microsoft.Marketplace.SaasKit.Client.DataAccess.Entities;
using Microsoft.Marketplace.SaasKit.Contracts;
using Microsoft.Marketplace.SaasKit.Provisioning.Webjob;
using Microsoft.Marketplace.SaasKit.Provisioning.Webjob.Helpers;
using Microsoft.Marketplace.SaasKit.Provisioning.Webjob.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SaaS.SDK.Provisioning.Webjob.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Microsoft.Marketplace.SaasKit.Provisioning.Webjob.StatusHandlers
{

    public class ResourceDeploymentStatusHandler : AbstractSubscriptionStatusHandler
    {

        protected readonly IFulfillmentApiClient fulfillApiclient;
        protected readonly ISubscriptionsRepository subscriptionsRepository;
        protected readonly IApplicationConfigRepository applicationConfigRepository;
        protected readonly ISubscriptionLogRepository subscriptionLogRepository;
        protected readonly IAzureKeyVaultClient azureKeyVaultClient;

        public ResourceDeploymentStatusHandler(IFulfillmentApiClient fulfillApiClient,
                                                IApplicationConfigRepository applicationConfigRepository,
                                                ISubscriptionLogRepository subscriptionLogRepository,
                                                ISubscriptionsRepository subscriptionsRepository,
                                                IAzureKeyVaultClient azureKeyVaultClient) : base(new SaasKitContext())
        {
            this.fulfillApiclient = fulfillApiClient;
            this.applicationConfigRepository = applicationConfigRepository;
            this.subscriptionLogRepository = subscriptionLogRepository;
            this.subscriptionsRepository = subscriptionsRepository;
            this.azureKeyVaultClient = azureKeyVaultClient;

        }
        public override void Process(Guid subscriptionID)
        {
            Console.WriteLine("ResourceDeploymentStatusHandler Process...");
            Console.WriteLine("Get SubscriptionById");
            var subscription = this.GetSubscriptionById(subscriptionID);
            Console.WriteLine("Get PlanById");
            var planDetails = this.GetPlanById(subscription.AmpplanId);
            Console.WriteLine("Get Offers");
            //KB: Remove Context and have repository
            var offer = Context.Offers.Where(s => s.OfferGuid == planDetails.OfferId).FirstOrDefault();
            Console.WriteLine("Get Events");
            //KB: Remove Context and have repository
            var events = Context.Events.Where(s => s.EventsName == "Activate").FirstOrDefault();

            Console.WriteLine("subscription.SubscriptionStatus: SubscriptionStatus: {0}", subscription.SubscriptionStatus);

            if (SubscriptionWebJobStatusEnum.PendingActivation.ToString().Equals(subscription?.SubscriptionStatus, StringComparison.InvariantCultureIgnoreCase))
            {

                // Check if arm template is available for the plan in Plan Event Mapping table with isactive=1
                Console.WriteLine("Get PlanEventsMapping");
                var planEvent = Context.PlanEventsMapping.Where(s => s.PlanId == planDetails.PlanGuid && s.EventId == events.EventsId && s.Isactive == true).FirstOrDefault();
                Console.WriteLine("Get Armtemplates");
                var armTemplate = Context.Armtemplates.Where(s => s.ArmtempalteId == planEvent.ArmtemplateId).FirstOrDefault();
                Console.WriteLine("Get GetTemplateParameters");
                var attributelsit = GetTemplateParameters(subscriptionID, planDetails.PlanGuid, Context);


                try
                {
                    if (armTemplate != null)
                    {
                        if (attributelsit != null)
                        {
                            Console.WriteLine("Get attributelsit");
                            var parametersList = attributelsit.Where(s => s.ParameterType.ToLower() == "input" && s.EventsName == "Activate").ToList();

                            Console.WriteLine("Attributelsit : {0}", JsonConvert.SerializeObject(parametersList));
                            if (parametersList.Count() > 0)
                            {

                                Console.WriteLine("UpdateWebJobSubscriptionStatus");

                                StatusUpadeHelpers.UpdateWebJobSubscriptionStatus(subscriptionID, armTemplate.ArmtempalteId, DeploymentStatusEnum.ARMTemplateDeploymentPending.ToString(), "Start Deployment", Context, subscription.SubscriptionStatus);

                                this.subscriptionsRepository.UpdateStatusForSubscription(subscriptionID, SubscriptionWebJobStatusEnum.DeploymentPending.ToString(), true);

                                Console.WriteLine("Get SubscriptionKeyValut");
                                string secretKey = "";
                                if (planDetails.DeployToCustomerSubscription != null && planDetails.DeployToCustomerSubscription == true)
                                {
                                    var keyvault = Context.SubscriptionKeyValut.Where(s => s.SubscriptionId == subscriptionID).FirstOrDefault();
                                    secretKey = keyvault.SecuteId; //KB: Typo
                                }
                                else
                                {
                                    secretKey = applicationConfigRepository.GetValuefromApplicationConfig("LocalkeyvaultUrl");
                                }


                                Console.WriteLine("Get DoVault");
                                string secretValue = azureKeyVaultClient.GetKeyAsync(secretKey).ConfigureAwait(false).GetAwaiter().GetResult();

                                var credenitals = JsonConvert.DeserializeObject<CredentialsModel>(secretValue);
                                Console.WriteLine("SecretValue : {0}", secretValue);

                                ARMTemplateDeploymentManager deploy = new ARMTemplateDeploymentManager();
                                Console.WriteLine("Start Deployment: DeployARMTemplate");
                                var output = deploy.DeployARMTemplate(armTemplate, parametersList, credenitals).ConfigureAwait(false).GetAwaiter().GetResult();

                                string outputstring = JsonConvert.SerializeObject(output.Properties.Outputs);
                                var outPutList = GenerateParmlist(output);
                                if (outPutList != null)
                                {

                                    UpdateSubscriptionTemplateParameters(outPutList.ToList(), subscriptionID, Context);

                                }

                                Console.WriteLine(outputstring);


                                this.subscriptionsRepository.UpdateStatusForSubscription(subscriptionID, SubscriptionWebJobStatusEnum.DeploymentSuccessful.ToString(), true);

                                SubscriptionAuditLogs auditLog = new SubscriptionAuditLogs()
                                {
                                    Attribute = SubscriptionLogAttributes.Deployment.ToString(),
                                    SubscriptionId = subscription.Id,
                                    NewValue = SubscriptionWebJobStatusEnum.DeploymentSuccessful.ToString(),
                                    OldValue = SubscriptionWebJobStatusEnum.DeploymentPending.ToString(),
                                    CreateBy = 0, // KB: Put some name here. It can be backgroundjob or the user that triggered the job.
                                    CreateDate = DateTime.Now
                                };
                                this.subscriptionLogRepository.Add(auditLog);

                                StatusUpadeHelpers.UpdateWebJobSubscriptionStatus(subscriptionID, armTemplate.ArmtempalteId, DeploymentStatusEnum.ARMTemplateDeploymentSuccess.ToString(), "Deployment Successful", Context, SubscriptionWebJobStatusEnum.DeploymentSuccessful.ToString());
                            }
                        }
                    }

                }
                //KB: Remove empty lines
                catch (Exception ex)
                {
                    //Change status to  ARMTemplateDeploymentFailure
                    string errorDescriptin = string.Format("Exception: {0} :: Innser Exception:{1}", ex.Message, ex.InnerException);
                    StatusUpadeHelpers.UpdateWebJobSubscriptionStatus(subscriptionID, armTemplate.ArmtempalteId, DeploymentStatusEnum.ARMTemplateDeploymentFailure.ToString(), errorDescriptin, Context, subscription.SubscriptionStatus.ToString());
                    Console.WriteLine(errorDescriptin);

                    this.subscriptionsRepository.UpdateStatusForSubscription(subscriptionID, SubscriptionWebJobStatusEnum.DeploymentFailed.ToString(), true);

                    SubscriptionAuditLogs auditLog = new SubscriptionAuditLogs()
                    {
                        Attribute = SubscriptionLogAttributes.Deployment.ToString(),
                        SubscriptionId = subscription.Id,
                        NewValue = SubscriptionWebJobStatusEnum.DeploymentFailed.ToString(),
                        OldValue = SubscriptionWebJobStatusEnum.PendingActivation.ToString(),
                        CreateBy = 0,
                        CreateDate = DateTime.Now
                    };
                    this.subscriptionLogRepository.Add(auditLog);
                }

            }
        }

        public static List<SubscriptionTemplateParameters> GetTemplateParameters(Guid subscriptionID, Guid PlanGuid, SaasKitContext Context)
        {
            List<SubscriptionTemplateParameters> _list = new List<SubscriptionTemplateParameters>();
            var subscriptionAttributes = Context.SubscriptionTemplateParametersOutPut.FromSqlRaw("dbo.spGetSubscriptionTemplateParameters {0},{1}", subscriptionID, PlanGuid);

            var existingdata = Context.SubscriptionTemplateParameters.Where(s => s.AmpsubscriptionId == subscriptionID);
            if (existingdata != null)
            {
                var existingdatalist = existingdata.ToList();
                if (existingdatalist.Count() > 0)
                {
                    return existingdatalist;

                }

                else
                {
                    if (subscriptionAttributes != null)
                    {
                        var beforeReplaceList = subscriptionAttributes.ToList();

                        var subscriptionAttributesList = ReplaceDeploymentparms(beforeReplaceList);

                        if (subscriptionAttributesList.Count() > 0)
                        {
                            foreach (var attr in subscriptionAttributesList)
                            {
                                SubscriptionTemplateParameters parm = new SubscriptionTemplateParameters()
                                {
                                    OfferName = attr.OfferName,
                                    OfferGuid = attr.OfferGuid,
                                    PlanGuid = attr.PlanGuid,
                                    PlanId = attr.PlanId,
                                    ArmtemplateId = attr.ArmtemplateId,
                                    Parameter = attr.Parameter,
                                    ParameterDataType = attr.ParameterDataType,
                                    Value = attr.Value,
                                    ParameterType = attr.ParameterType,
                                    EventId = attr.EventId,
                                    EventsName = attr.EventsName,
                                    AmpsubscriptionId = attr.AmpsubscriptionId,
                                    SubscriptionStatus = attr.SubscriptionStatus,
                                    SubscriptionName = attr.SubscriptionName,
                                    CreateDate = DateTime.Now
                                };
                                Context.SubscriptionTemplateParameters.Add(parm);
                                Context.SaveChanges();
                                _list.Add(parm);
                            }

                        }


                    }

                }


            }
            return _list;
        }


        public static List<ChildParameterViewModel> GenerateParmlist(DeploymentExtended outputstring)
        {
            List<ChildParameterViewModel> childlist = new List<ChildParameterViewModel>();

            JObject templateOutputs = (JObject)outputstring.Properties.Outputs;


            foreach (JToken child in templateOutputs.Children())
            {
                ChildParameterViewModel childparms = new ChildParameterViewModel();
                childparms = new ChildParameterViewModel();
                childparms.ParameterType = "output";
                var paramName = (child as JProperty).Name;
                childparms.ParameterName = paramName;
                object paramValue = string.Empty;

                foreach (JToken grandChild in child)
                {
                    foreach (JToken grandGrandChild in grandChild)
                    {
                        var property = grandGrandChild as JProperty;

                        if (property != null && property.Name == "value")
                        {
                            var type = property.Value.GetType();

                            if (type == typeof(JValue) || type == typeof(JArray) ||
                            property.Value.Type == JTokenType.Object ||
                            property.Value.Type == JTokenType.Date)
                            {
                                paramValue = property.Value;
                                if (paramValue != null)
                                {
                                    childparms.ParameterValue = paramValue.ToString();
                                }
                            }

                        }
                    }
                }
                childlist.Add(childparms);
            }
            return childlist;
        }

        public static void UpdateSubscriptionTemplateParameters(List<ChildParameterViewModel> parms, Guid subscriptionID, SaasKitContext Context)
        {
            foreach (var parm in parms)
            {
                var outputparm = Context.SubscriptionTemplateParameters.Where(s => s.AmpsubscriptionId == subscriptionID && s.Parameter == parm.ParameterName && s.ParameterType.ToLower() == "output").FirstOrDefault();

                if (outputparm != null)
                {
                    outputparm.Value = parm.ParameterValue;
                    Context.SubscriptionTemplateParameters.Update(outputparm);
                    Context.SaveChanges();
                }
            }
        }


        public static List<SubscriptionTemplateParametersOutPut> ReplaceDeploymentparms(List<SubscriptionTemplateParametersOutPut> parmList)
        {
            //KB: Expect subscriptionID to this method
            // Call a stored procedure to return the default set of values as key value pairs
            /* foreach param
             *  Apply nvelocity and take the processed value.
             */
            // Use Nvelocity to do the substitution
            

            foreach (var parm in parmList)
            {
                parm.Value = parm.Value.Replace("${Subscription}", parm.SubscriptionName.Replace(" ", "-"));
                parm.Value = parm.Value.Replace("${Offer}", parm.OfferName.Replace(" ", "-"));
                parm.Value = parm.Value.Replace("${Plan}", parm.PlanId.Replace(" ", "-"));
            }

            return parmList;
        }
    }
}

