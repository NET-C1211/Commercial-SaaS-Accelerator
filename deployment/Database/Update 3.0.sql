

CREATE TABLE WebJobSubscriptionStatus
(
 ID Int Identity(1,1) Primary Key
,SubscriptionId UniqueIdentifier
,ARMTemplateID UniqueIdentifier
,SubscriptionStatus Varchar(225)
,DeploymentStatus Varchar(225)
,Description Varchar(max)
,InsertDate DateTime
)




GO
CREATE TABLE [dbo].[SubscriptionTemplateParameters]
(
Id Int identity(1,1) Primary Key
,OfferName Varchar(225)
,OfferGUId UniqueIdentifier
,PlanGUID UniqueIdentifier
,PlanId   Varchar(225)
,ARMTemplateID UniqueIdentifier 
,Parameter Varchar(225)
,ParameterDataType Varchar(225)
,Value Varchar(225)
,ParameterType Varchar(225)
,EventId Int
,EventsName Varchar(225)
,AMPSubscriptionId UniqueIdentifier
,SubscriptionStatus Varchar(225)
,SubscriptionName Varchar(225)
,CreateDate Datetime
,UserId Int
)

GO



  
CREATE Procedure spGetSubscriptionTemplateParameters  
(    
@SubscriptionId Uniqueidentifier,    
@PlanId Uniqueidentifier    
)    
AS    
BEGIN    
     
Declare @OfferId Uniqueidentifier     
Set @OfferId=(Select OfferId from Plans where PlanGuId =@PlanId )  
If exists(select 1 from SubscriptionTemplateParameters where AMPSubscriptionId=@SubscriptionId)
BEGIN
Select 
Id
,OfferName
,OfferGUId
,PlanGUID
,PlanId
,ARMTemplateID
,Parameter
,ParameterDataType
,Value
,ParameterType
,EventId
,EventsName
,AMPSubscriptionId
,SubscriptionStatus
,SubscriptionName

 from SubscriptionTemplateParameters where AMPSubscriptionId=@SubscriptionId
 END
 ELSE
 BEGIN
SELECT      
Cast( ROW_NUMBER() OVER ( ORDER BY ART.ID) as Int)RowId    
,0 ID    
,ofr.OfferName  
,ofr.OfferGUId   
,pln.PlanGUID  
,pln.PlanId  
,art.ARMTemplateID  
,art.Parameter  
,art.ParameterDataType  
,art.Value  
,art.ParameterType  
,PE.EventId  
,EV.EventsName  
,Sub.AMPSubscriptionId  
,Sub.SubscriptionStatus  
,sub.Name AS SubscriptionName  
from   
Offers ofr  
inner join Plans pln on ofr.OfferGUId=pln.OfferID  
inner join PlanEventsMapping PE on pln.PlanGUID=pe.PlanId  
inner join ARMTemplateParameters ART on PE.ARMTemplateId=ART.ARMTemplateId   
inner Join Subscriptions Sub on pln.PlanId=Sub.AMPPlanId  
inner join [Events] Ev on EV.EventsId=PE.EventId  
 Where Sub.AMPSubscriptionId =@SubscriptionId  
 and EV.EventsName  ='Activate'
  END
   
  
END  
  
  


GO


CREATE TABLE [dbo].[SubscriptionTemplateParametersOutPut]
(
RowID int  NOT NULL
,Id Int 
,OfferName Varchar(225)
,OfferGUId UniqueIdentifier
,PlanGUID UniqueIdentifier
,PlanId   Varchar(225)
,ARMTemplateID UniqueIdentifier 
,Parameter Varchar(225)
,ParameterDataType Varchar(225)
,Value Varchar(225)
,ParameterType Varchar(225)
,EventId Int
,EventsName Varchar(225)
,AMPSubscriptionId UniqueIdentifier
,SubscriptionStatus Varchar(225)
,SubscriptionName Varchar(225)
)

GO

CREATE TABLE SubscriptionKeyValut
(
Id Int Identity(1,1) Primary Key,
SubscriptionId UniqueIdentifier,
SecuteId Varchar(max),
CreateDate DateTime,
UserId Int
)


Go

Insert into EmailTemplate (Status,Description,InsertDate,TemplateBody,Subject,ToRecipients,CC,BCC,IsActive)
SELECT 'Template','Template',GETDATE(),'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">             
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <!--<note>Use this Template for Pending Activation email </note>-->                                            
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <!--<title>Cloud Market Place - Your registration is successful</title>-->                                              
      <style type="text/css">          /* /\/\/\/\/\/\/\/\/ CLIENT-SPECIFIC STYLES /\/\/\/\/\/\/\/\/ */ #outlook a {              padding: 0;          }          /* Force Outlook to provide a view in browser message */            .ReadMsgBody {              width: 100%;          }            .ExternalClass {              width: 100%;          }              /* Force Hotmail to display emails at full width */                .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {                  line-height: 100%;              }          /* Force Hotmail to display normal line spacing */            body, table, td, p, a, li, blockquote {              -webkit-text-size-adjust: 100%;              -ms-text-size-adjust: 100%;          }          /* Prevent WebKit and Windows mobile changing default text sizes */            table, td {              mso-table-lspace: 0pt;              mso-table-rspace: 0pt;          }          /* Remove spacing between tables in Outlook 2007 and up */            img {              -ms-interpolation-mode: bicubic;          }          /* Allow smoother rendering of resized image in Internet Explorer */ /* /\/\/\/\/\/\/\/\/ RESET STYLES /\/\/\/\/\/\/\/\/ */            body {              margin: 0;              padding: 0;          }            img {              border: 0;              height: auto;              line-height: 100%;              outline: none;              text-decoration: none;          }            table {              border-collapse: collapse !important;          }            body, #bodyTable, #bodyCell {              height: 100% !important;              margin: 0;              padding: 0;              width: 100% !important;          }          /* /\/\/\/\/\/\/\/\/ TEMPLATE STYLES /\/\/\/\/\/\/\/\/ */ /* ========== Page Styles ========== */            #bodyCell {              padding: 20px;          }            #templateContainer {              width: 600px;          }          /*** @tab Page* @section background style* @tip Set the background color and top border for your email. You may want to choose colors that match your companys branding.* @theme page*/            body, #bodyTable { /*@editable*/              background-color: #FFFFFF;          }          /*** @tab Page* @section background style* @tip Set the background color and top border for your email. You may want to choose colors that match your companys branding.* @theme page*/            #bodyCell { /*@editable*/              border-top: 4px solid #FFFFFF;          }          /*** @tab Page* @section email border* @tip Set the border for your email.*/            #templateContainer { /*@editable*/              border: 1px solid #BBBBBB;          }          /*** @tab Page* @section heading 1* @tip Set the styling for all first-level headings in your emails. These should be the largest of your headings.* @style heading 1*/            h1 { /*@editable*/              color: #202020 !important;              display: block; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 26px; /*@editable*/              font-style: normal; /*@editable*/              font-weight: bold; /*@editable*/              line-height: 100%; /*@editable*/              letter-spacing: normal;              margin-top: 0;              margin-right: 0;              margin-bottom: 10px;              margin-left: 0; /*@editable*/              text-align: left;          }          /*** @tab Page* @section heading 2* @tip Set the styling for all second-level headings in your emails.* @style heading 2*/            h2 { /*@editable*/              color: #404040 !important;              display: block; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 20px; /*@editable*/              font-style: normal; /*@editable*/              font-weight: bold; /*@editable*/              line-height: 100%; /*@editable*/              letter-spacing: normal;              margin-top: 0;              margin-right: 0;              margin-bottom: 10px;              margin-left: 0; /*@editable*/              text-align: left;          }          /*** @tab Page* @section heading 3* @tip Set the styling for all third-level headings in your emails.* @style heading 3*/            h3 { /*@editable*/              color: #606060 !important;              display: block; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 16px; /*@editable*/              font-style: italic; /*@editable*/              font-weight: normal; /*@editable*/              line-height: 100%; /*@editable*/              letter-spacing: normal;              margin-top: 0;              margin-right: 0;              margin-bottom: 10px;              margin-left: 0; /*@editable*/              text-align: left;          }          /*** @tab Page* @section heading 4* @tip Set the styling for all fourth-level headings in your emails. These should be the smallest of your headings.* @style heading 4*/            h4 { /*@editable*/              color: #000000 !important;              display: block; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 14px; /*@editable*/              font-style: italic; /*@editable*/              font-weight: normal; /*@editable*/              line-height: 100%; /*@editable*/              letter-spacing: normal;              margin-top: 0;              margin-right: 0;              margin-bottom: 10px;              margin-left: 0; /*@editable*/              text-align: left;          }          /* ========== Header Styles ========== */ /*** @tab Header* @section preheader style* @tip Set the background color and bottom border for your emails preheader area.* @theme header*/            #templatePreheader { /*@editable*/              background-color: #FFFFFF; /*@editable*/              border-bottom: 1px solid #CCCCCC;          }          /*** @tab Header* @section preheader text* @tip Set the styling for your emails preheader text. Choose a size and color that is easy to read.*/            .preheaderContent { /*@editable*/              color: #000000; /*@editable*/              font-family: wf_segoe-ui_normal, "Segoe UI", "Segoe WP", Tahoma, Arial, sans-serif; /*@editable*/              font-size: 10px; /*@editable*/              line-height: 125%; /*@editable*/              text-align: left;          }              /*** @tab Header* @section preheader link* @tip Set the styling for your emails preheader links. Choose a color that helps them stand out from your text.*/                .preheaderContent a:link, .preheaderContent a:visited, /* Yahoo! Mail Override */ .preheaderContent a .yshortcuts /* Yahoo! Mail Override */ { /*@editable*/                  color: #606060; /*@editable*/                  font-weight: normal; /*@editable*/                  text-decoration: underline;              }          /*** @tab Header* @section header style* @tip Set the background color and borders for your emails header area.* @theme header*/            #templateHeader { /*@editable*/              background-color: #FFFFFF; /*@editable*/              border-top: 1px solid #FFFFFF; /*@editable*/              border-bottom: 1px solid #CCCCCC;          }          /*** @tab Header* @section header text* @tip Set the styling for your emails header text. Choose a size and color that is easy to read.*/            .headerContent { /*@editable*/              color: #505050; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 20px; /*@editable*/              font-weight: bold; /*@editable*/              line-height: 100%; /*@editable*/              padding-top: 0; /*@editable*/              padding-right: 0; /*@editable*/              padding-bottom: 0; /*@editable*/              padding-left: 0; /*@editable*/              text-align: left; /*@editable*/              vertical-align: middle;          }              /*** @tab Header* @section header link* @tip Set the styling for your emails header links. Choose a color that helps them stand out from your text.*/                .headerContent a:link, .headerContent a:visited, /* Yahoo! Mail Override */ .headerContent a .yshortcuts /* Yahoo! Mail Override */ { /*@editable*/                  color: #EB4102; /*@editable*/                  font-weight: normal; /*@editable*/                  text-decoration: underline;              }            #headerImage {              height: auto;              max-width: 600px;          }          /* ========== Body Styles ========== */ /*** @tab Body* @section body style* @tip Set the background color and borders for your emails body area.*/            #templateBody { /*@editable*/              background-color: #FFFFFF; /*@editable*/              border-top: 1px solid #FFFFFF; /*@editable*/              border-bottom: 1px solid #CCCCCC;          }          /*** @tab Body* @section body text* @tip Set the styling for your emails main content text. Choose a size and color that is easy to read.* @theme main*/            .bodyContent { /*@editable*/              color: #505050; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 16px; /*@editable*/              line-height: 150%;              padding-top: 20px;              padding-right: 20px;              padding-bottom: 20px;              padding-left: 20px; /*@editable*/              text-align: left;          }              /*** @tab Body* @section body link* @tip Set the styling for your emails main content links. Choose a color that helps them stand out from your text.*/                .bodyContent a:link, .bodyContent a:visited, /* Yahoo! Mail Override */ .bodyContent a .yshortcuts /* Yahoo! Mail Override */ { /*@editable*/                  color: #EB4102; /*@editable*/                  font-weight: normal; /*@editable*/                  text-decoration: underline;              }                .bodyContent img {                  display: inline;                  height: auto;                  max-width: 560px;              }          /* ========== Column Styles ========== */            .templateColumnContainer {              display: inline;              width: 260px;          }          /*** @tab Columns* @section column style* @tip Set the background color and borders for your emails column area.*/            #templateColumns { /*@editable*/              background-color: #FFFFFF; /*@editable*/              border-top: 1px solid #FFFFFF; /*@editable*/              border-bottom: 1px solid #CCCCCC;          }          /*** @tab Columns* @section left column text* @tip Set the styling for your emails left column content text. Choose a size and color that is easy to read.*/            .leftColumnContent { /*@editable*/              color: #505050; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 14px; /*@editable*/              line-height: 150%;              padding-top: 0;              padding-right: 0;              padding-bottom: 20px;              padding-left: 0; /*@editable*/              text-align: left;          }              /*** @tab Columns* @section left column link* @tip Set the styling for your emails left column content links. Choose a color that helps them stand out from your text.*/                .leftColumnContent a:link, .leftColumnContent a:visited, /* Yahoo! Mail Override */ .leftColumnContent a .yshortcuts /* Yahoo! Mail Override */ { /*@editable*/                  color: #EB4102; /*@editable*/                  font-weight: normal; /*@editable*/                  text-decoration: underline;              }          /*** @tab Columns* @section right column text* @tip Set the styling for your emails right column content text. Choose a size and color that is easy to read.*/            .rightColumnContent { /*@editable*/              color: #505050; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 14px; /*@editable*/              line-height: 150%;              padding-top: 0;              padding-right: 0;              padding-bottom: 20px;              padding-left: 0; /*@editable*/              text-align: left;          }              /*** @tab Columns* @section right column link* @tip Set the styling for your emails right column content links. Choose a color that helps them stand out from your text.*/                .rightColumnContent a:link, .rightColumnContent a:visited, /* Yahoo! Mail Override */ .rightColumnContent a .yshortcuts /* Yahoo! Mail Override */ { /*@editable*/                  color: #EB4102; /*@editable*/                  font-weight: normal; /*@editable*/                  text-decoration: underline;              }                .leftColumnContent img, .rightColumnContent img {                  display: inline;                  height: auto;                  max-width: 260px;              }          /* ========== Footer Styles ========== */ /*** @tab Footer* @section footer style* @tip Set the background color and borders for your emails footer area.* @theme footer*/            #templateFooter { /*@editable*/              background-color: #FFFFFF; /*@editable*/              border-top: 1px solid #FFFFFF;          }          /*** @tab Footer* @section footer text* @tip Set the styling for your emails footer text. Choose a size and color that is easy to read.* @theme footer*/            .footerContent { /*@editable*/              color: #808080; /*@editable*/              font-family: "Segoe UI", Tahoma,Sans-serif; /*@editable*/              font-size: 10px; /*@editable*/              line-height: 150%;              padding-top: 20px;              padding-right: 20px;              padding-bottom: 20px;              padding-left: 20px; /*@editable*/              text-align: left;          }              /*** @tab Footer* @section footer link* @tip Set the styling for your emails footer links. Choose a color that helps them stand out from your text.*/                .footerContent a:link, .footerContent a:visited, /* Yahoo! Mail Override */ .footerContent a .yshortcuts, .footerContent a span /* Yahoo! Mail Override */ { /*@editable*/                  color: #606060; /*@editable*/                  font-weight: normal; /*@editable*/                  text-decoration: underline;              }          /* /\/\/\/\/\/\/\/\/ MOBILE STYLES /\/\/\/\/\/\/\/\/ */            @media only screen and (max-width: 480px) { /* /\/\/\/\/\/\/ CLIENT-SPECIFIC MOBILE STYLES /\/\/\/\/\/\/ */                body, table, td, p, a, li, blockquote {                  -webkit-text-size-adjust: none !important;              }              /* Prevent Webkit platforms from changing default text sizes */                body {                  width: 100% !important;                  min-width: 100% !important;              }              /* Prevent iOS Mail from adding padding to the body */ /* /\/\/\/\/\/\/ MOBILE RESET STYLES /\/\/\/\/\/\/ */                #bodyCell {                  padding: 10px !important;              }              /* /\/\/\/\/\/\/ MOBILE TEMPLATE STYLES /\/\/\/\/\/\/ */ /* ======== Page Styles ======== */ /*** @tab Mobile Styles* @section template width* @tip Make the template fluid for portrait or landscape view adaptability. If a fluid layout doesnt work for you, set the width to 300px instead.*/                #templateContainer {                  max-width: 600px !important; /*@editable*/                  width: 100% !important;              }              /*** @tab Mobile Styles* @section heading 1* @tip Make the first-level headings larger in size for better readability on small screens.*/                h1 { /*@editable*/                  font-size: 24px !important; /*@editable*/                  line-height: 100% !important;              }              /*** @tab Mobile Styles* @section heading 2* @tip Make the second-level headings larger in size for better readability on small screens.*/                h2 { /*@editable*/                  font-size: 20px !important; /*@editable*/                  line-height: 100% !important;              }              /*** @tab Mobile Styles* @section heading 3* @tip Make the third-level headings larger in size for better readability on small screens.*/                h3 { /*@editable*/                  font-size: 18px !important; /*@editable*/                  line-height: 100% !important;              }              /*** @tab Mobile Styles* @section heading 4* @tip Make the fourth-level headings larger in size for better readability on small screens.*/                h4 { /*@editable*/                  font-size: 16px !important; /*@editable*/                  line-height: 100% !important;              }              /* ======== Header Styles ======== */                #templatePreheader {                  display: none !important;              }              /* Hide the template preheader to save space */ /*** @tab Mobile Styles* @section header image* @tip Make the main header image fluid for portrait or landscape view adaptability, and set the images original width as the max-width. If a fluid setting doesnt work, set the image width to half its original size instead.*/                #headerImage {                  height: auto !important; /*@editable*/                  max-width: 600px !important; /*@editable*/                  width: 100% !important;              }              /*** @tab Mobile Styles* @section header text* @tip Make the header content text larger in size for better readability on small screens. We recommend a font size of at least 16px.*/                .headerContent { /*@editable*/                  font-size: 20px !important; /*@editable*/                  line-height: 125% !important;              }              /* ======== Body Styles ======== */ /*** @tab Mobile Styles* @section body image* @tip Make the main body image fluid for portrait or landscape view adaptability, and set the images original width as the max-width. If a fluid setting doesnt work, set the image width to half its original size instead.*/                #bodyImage {                  height: auto !important; /*@editable*/                  max-width: 560px !important; /*@editable*/                  width: 100% !important;              }              /*** @tab Mobile Styles* @section body text* @tip Make the body content text larger in size for better readability on small screens. We recommend a font size of at least 16px.*/                .bodyContent { /*@editable*/                  font-size: 18px !important; /*@editable*/                  line-height: 125% !important;              }              /* ======== Column Styles ======== */                .templateColumnContainer {                  display: block !important;                  width: 100% !important;              }              /*** @tab Mobile Styles* @section column image* @tip Make the column image fluid for portrait or landscape view adaptability, and set the images original width as the max-width. If a fluid setting doesnt work, set the image width to half its original size instead.*/                .columnImage {                  height: auto !important; /*@editable*/                  max-width: 260px !important; /*@editable*/                  width: 100% !important;              }              /*** @tab Mobile Styles* @section left column text* @tip Make the left column content text larger in size for better readability on small screens. We recommend a font size of at least 16px.*/                .leftColumnContent { /*@editable*/                  font-size: 16px !important; /*@editable*/                  line-height: 125% !important;              }              /*** @tab Mobile Styles* @section right column text* @tip Make the right column content text larger in size for better readability on small screens. We recommend a font size of at least 16px.*/                .rightColumnContent { /*@editable*/                  font-size: 16px !important; /*@editable*/                  line-height: 125% !important;              }              /* ======== Footer Styles ======== */ /*** @tab Mobile Styles* @section footer text* @tip Make the body content text larger in size for better readability on small screens.*/                .footerContent { /*@editable*/                  font-size: 14px !important; /*@editable*/                  line-height: 115% !important;              }                    .footerContent a {                      display: block !important;                  }              /* Place footer social and utility links on their own lines, for easier access */          }      </style>
   </head>
   <body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0">
      <center>
         <table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable">
            <tr>
               <td align="center" valign="top" id="bodyCell">
                  <!-- BEGIN TEMPLATE // -->                                                                                                               
                  <table border="0" cellpadding="0" cellspacing="0" id="templateContainer">
                     <tr>
                        <td align="center" valign="top">
                           <!-- BEGIN HEADER // -->                                                                                                                                                                  
                           <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateHeader">
                              <tr>
                                 <td valign="top"  class="headerContent">                                              <img src="https://media-exp1.licdn.com/dms/image/C510BAQHaTIBZfLFCGg/company-logo_200_200/0?e=1592438400&v=beta&t=AHOqaRJR_Thf72VDOKQId2QKdwepIp-sIiSIDtALzhQ" style="max-width: 300px; display: block; margin-left: auto; margin-right: auto; padding-top:10px;padding-bottom:10px;" id="headerImage" />                                          </td>
                              </tr>
                           </table>
                           <!-- // END HEADER -->                                                                                                                                               
                        </td>
                     </tr>
                     <tr>
                        <td align="center" valign="top">
                           <!-- BEGIN BODY // -->                                                                                                                                                                  
                           <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateBody">
                              <tr>
                                 <td valign="top" class="bodyContent">
                                    <h1 style="display: block;  margin-left: auto;  margin-right: auto;  width: 75%;">Welcome to ${ApplicationName}!</h1>                         #if(${planevent} == "failure")
                                     <p>Your request for the subscription has been failed.</p>    
                    #elseif(${SaasSubscriptionStatus} == "PendingActivation")
                                    <p>A request for purchase with the following details is awaiting your action for activation.                                       </p>
                    
                     #elseif(${SaasSubscriptionStatus} == "Subscribed")
                                    <p>Your request for the purchase has been approved.                                       </p>  
                    
                     #elseif(${SaasSubscriptionStatus} == "Unsubscribed")
                                     <p>A subscription with the following details was deleted from Azure.</p>    
                    #end
                    
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateBody">
                                       <tr>
                                          <td><b>Customer Email Address</b></td>
                                          <td>${CustomerEmailAddress}</td>
                                       </tr>
                                       <tr>
                                          <td><b>Customer Name</b></td>
                                          <td>${CustomerName}</td>
                                       </tr>
                                       <tr>
                                          <td><b>ID</b></td>
                                          <td>${Id}</td>
                                       </tr>
                                       <tr>
                                          <td><b>Subscription Name</b></td>
                                          <td>${SubscriptionName}</td>
                                       </tr>
                                       <tr>
                                          <td><b>Status</b></td>
                                          <td>${SaasSubscriptionStatus}</td>
                                       </tr>
                                       #foreach( $prod in $parms )                                                     
                                       <tr>
                                          <td><b>$prod.DisplayName</b></td>
                                          <td>$prod.Value</td>
                                       </tr>
                                       #end                                                                                      
                                    </table>
                                                                                                                                                                                                                                        #if($arminputparms.Count > 0)
                                    <b>Input Parameters</b></br>                                        
                                    <table border="1" cellpadding="0" cellspacing="0" width="50%">
                                       #foreach( $prod in $arminputparms )                                                     
                                       <tr>
                                          <td><b>$prod.DisplayName</b></td>
                                          <td>$prod.Value</td>
                                       </tr>
                                       #end                                                                                      
                                    </table>
                                     #end
                                    #if($armoutputparms.Count > 0)
                                    <b>Output Parameters</b></br>
                                    
                                    <table border="1" cellpadding="0" cellspacing="0" width="50%" >
                                       #foreach( $prod in $armoutputparms )                                                     
                                       <tr>
                                          <td><b>$prod.DisplayName</b></td>
                                          <td>$prod.Value</td>
                                       </tr>
                                       #end                                                                                      
                                    </table>
                                    #end
                                    <p style=" margin-left: auto; margin-right: auto; text-align:right;">                                                  <a href="https://saaskitdemoapp.azurewebsites.net/"><button style="background-color:#2168A6;line-height:30px;color:white"><b>View Details</b></button></a>                                              </p>
                                    <!--     CTA button -->                                              <!--<table style="background: #0078D7;" cellspacing="0" cellpadding="0" align="left">                                                  <tbody>                                                      <tr>                                                          <td style="padding-left: 15px; font-size: 18px; line-height: 20px; font-family:"Segoe UI Light"; color: #ffffff;">                                                              <a style="text-decoration: none; font-size: 18px; line-height: 20px; font-family:"Segoe UI Light"; color: #ffffff;" href="${LinkToPortal}/#/login">${LoginButtonTextInEmail}</a>                                                          </td>                                                          <td style="line-height: 1px; font-size: 1px; padding: 10px;">                                                              <a>                                                                  <img src="https://info.microsoft.com/rs/157-GQE-382/images/Program-CTAButton-whiteltr.png" border="0" alt="" height="20" />                                                              </a>                                                          </td>                                                      </tr>                                                  </tbody>                                              </table>-->                                              <!--     end CTA button -->                                                                                                                                                                                                  
                                 </td>
                              </tr>
                              <tr>
                                 <td align="center" valign="top">
                                    <!-- BEGIN PREHEADER // -->                                                                                                                                                                                                                  
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templatePreheader">
                                       <tr>
                                          <td valign="top" class="preheaderContent" style="padding-top: 10px; padding-right: 20px; padding-bottom: 10px; padding-left: 20px;">                                                          You are receiving this message because of an interaction with                                                          <a href="https://saaskitdemoapp.azurewebsites.net/">Contoso</a>.                                                          Please contact us at <a href="https://saaskitdemoapp.azurewebsites.net/">Contoso</a>                                                          in case you think you have received this message in error or need help.                                                      </td>
                                          <!-- *|IFNOT:ARCHIVE_PAGE|* -->                                                      <!-- *|END:IF|* -->                                                                                                                                                                                                                                     
                                       </tr>
                                    </table>
                                    <!-- // END PREHEADER -->                                                                                                                                                                                                  
                                 </td>
                              </tr>
                           </table>
                        </td>
                     </tr>
                  </table>
                  <!-- // END BODY -->                                                                                               
               </td>
            </tr>
         </table>
         <!-- // END TEMPLATE -->                                              
      </center>
   </body>
</html>','','','','',1
