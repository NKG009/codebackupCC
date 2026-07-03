public without sharing class ContractService {
    private static final Set<String> specials = new Set<String>{ ApexConstants.QUOTE_LINE_ITEM_ACTION_EXISTING, ApexConstants.QUOTE_LINE_ITEM_ACTION_DISCONNECT };
    
    public static String process(Id quoteId) {
        try {
            String result = generateJsonForDocument(quoteId);
            return result;
        } catch (Exception e) {
            icServiceErrorHandler.LogError('ContractService', 'process', e.getStackTraceString(), e.getMessage(), null);
        }
        
        return null;
    }
    
    private static String generateJsonForDocument(Id quoteId) {
        if (quoteId == null) {
            return null;
        }
        
        Quote quoteRecord = QuoteSelector.getQuoteForDocumentGeneration(quoteId);

        //line items + families
        Map<String, ContractDto.QuoteLineItem> quoteMemberToQuoteLineItemMap = new Map<String, ContractDto.QuoteLineItem>();
        Map<String, ContractDto.QuoteMember> quoteMemberMap = new Map<String, ContractDto.QuoteMember>();
        Map<String, ContractDto.ProductFamily> familyDtoMap = new Map<String, ContractDto.ProductFamily>();
        Map<String, QuoteLineItem> quoteLineItemidToRecord = new Map<String, QuoteLineItem>();
        Map<String, List<ContractDto.QuoteLineItem>> quoteLineItemToPromotion = new Map<String, List<ContractDto.QuoteLineItem>>();
        Map<String,List<String>> registerAssignmentOfFamilytoMember = new Map<String,List<String>>();
        // new maps
        Map<Id, List<vlocity_cmt__QuotePricingAdjustment__c>> appliedAdjustments = new Map<Id, List<vlocity_cmt__QuotePricingAdjustment__c>>();
        Map<Id,Boolean> quoteLineOverridingCheck = new Map<Id,Boolean>();

        for (QuoteLineItem quoteLineItemRecord : QuoteLineItemSelector.getQuoteLineItemsForContractGeneration(quoteRecord.Id)) {
            //skip lines if we don't want to show them on the contract
            if (String.isBlank(quoteRecord.Control_Document_Lines__c) && (quoteLineItemRecord.vlocity_cmt__Action__c == ApexConstants.QUOTE_LINE_ITEM_ACTION_DISCONNECT || quoteLineItemRecord.vlocity_cmt__Action__c == ApexConstants.QUOTE_LINE_ITEM_ACTION_EXISTING)) {
                continue;
            }
            
            if (String.isNotBlank(quoteRecord.Control_Document_Lines__c) && (quoteLineItemRecord.vlocity_cmt__Action__c == ApexConstants.QUOTE_LINE_ITEM_ACTION_DISCONNECT || quoteLineItemRecord.vlocity_cmt__Action__c == ApexConstants.QUOTE_LINE_ITEM_ACTION_EXISTING) && 
               !quoteRecord.Control_Document_Lines__c.contains(quoteLineItemRecord.vlocity_cmt__Action__c))
            {
                continue;
            }
            
            quoteLineItemidToRecord.put(quoteLineItemRecord.Id, quoteLineItemRecord);
        }
        
        quoteLineItemidToRecord.remove(null);
        
        if (quoteLineItemidToRecord.isEmpty()) {
            return null;
        }
        
        for (vlocity_cmt__QuotePricingAdjustment__c quotePricingAdjustmentRecord : QuotePricingAdjustmentSelector.getQuotePricingAdjustmentsFromQuoteLineItems(quoteLineItemidToRecord.keyset())) {                                                                      
            if (!quoteLineItemToPromotion.containsKey(quotePricingAdjustmentRecord.vlocity_cmt__QuoteItemId__c)) {
                quoteLineItemToPromotion.put(quotePricingAdjustmentRecord.vlocity_cmt__QuoteItemId__c, new List<ContractDto.QuoteLineItem>());
            }
            
            if (!appliedAdjustments.containsKey(quotePricingAdjustmentRecord.vlocity_cmt__QuoteItemId__c)) {
                appliedAdjustments.put(quotePricingAdjustmentRecord.vlocity_cmt__QuoteItemId__c, new List<vlocity_cmt__QuotePricingAdjustment__c>());
            }
            
            if (quotePricingAdjustmentRecord.vlocity_cmt__Source__c==ApexConstants.VLOCITY_QUOTE_PRICING_ADJUSTMENT_SOURCE_AGENT){
                quoteLineOverridingCheck.put(quotePricingAdjustmentRecord.vlocity_cmt__QuoteItemId__c,true);
            }
            appliedAdjustments.get(quotePricingAdjustmentRecord.vlocity_cmt__QuoteItemId__c).add(quotePricingAdjustmentRecord);
        }
        
        appliedAdjustments.remove(null);
        
        for (String quoteLineItemId : quoteLineItemidToRecord.keyset()) {
            QuoteLineItem quoteLineItemRecord = quoteLineItemidToRecord.get(quoteLineItemId);
            
            String memberKey = 'No Member';
            
            ContractDto.QuoteMember quoteMemberDto = new ContractDto.QuoteMember();
            quoteMemberDto.RCTotalQM = 0;
            quoteMemberDto.OTTotalQM = 0;
            quoteMemberDto.chargeTotal = 0;
            quoteMemberDto.totalRecurringChargeWithQuantity = 0;
            
            if (String.isNotBlank(quoteLineItemRecord.vlocity_cmt__QuoteMemberId__c)) {
                memberKey = quoteLineItemRecord.vlocity_cmt__QuoteMemberId__c;
                quoteMemberDto.quoteMemberId = quoteLineItemRecord.vlocity_cmt__QuoteMemberId__c;
                quoteMemberDto.locationCity = quoteLineItemRecord.vlocity_cmt__QuoteMemberId__r.vlocity_cmt__City__c;
                quoteMemberDto.locationCountry = quoteLineItemRecord.vlocity_cmt__QuoteMemberId__r.vlocity_cmt__Country__c;
                quoteMemberDto.locationStreet = quoteLineItemRecord.vlocity_cmt__QuoteMemberId__r.vlocity_cmt__StreetAddress__c;
                quoteMemberDto.locationState = quoteLineItemRecord.vlocity_cmt__QuoteMemberId__r.vlocity_cmt__State__c;
                quoteMemberDto.locationPostalCode = quoteLineItemRecord.vlocity_cmt__QuoteMemberId__r.vlocity_cmt__PostalCode__c;
            } else if (String.isNotBlank(quoteLineItemRecord.vlocity_cmt__ServiceAccountId__c)) {
                memberKey = quoteLineItemRecord.vlocity_cmt__ServiceAccountId__c;
                quoteMemberDto.quoteMemberId = quoteLineItemRecord.vlocity_cmt__ServiceAccountId__c;
                quoteMemberDto.locationCity = quoteLineItemRecord.vlocity_cmt__ServiceAccountId__r.ShippingCity;
                quoteMemberDto.locationCountry = quoteLineItemRecord.vlocity_cmt__ServiceAccountId__r.ShippingCountry;
                quoteMemberDto.locationStreet = quoteLineItemRecord.vlocity_cmt__ServiceAccountId__r.ShippingStreet;
                quoteMemberDto.locationState = quoteLineItemRecord.vlocity_cmt__ServiceAccountId__r.ShippingState;
                quoteMemberDto.locationPostalCode = quoteLineItemRecord.vlocity_cmt__ServiceAccountId__r.ShippingPostalCode;
            }
            
            //do we have the quote member? 
            if (quoteMemberMap.get(memberKey) == null) {
                quoteMemberMap.put(memberKey, quoteMemberDto);
            }
            
            String familyKey = quoteLineItemRecord.Product2.Family;
            String fullLineItemKey = quoteLineItemRecord.Id + ApexConstants.PIPE + memberKey;
            String memberToFamilyKey = familyKey + ApexConstants.PIPE + memberKey;
            
            //do we have the quote family? build it if not
            ContractDto.ProductFamily productFamilyDto = familyDtoMap.get(memberToFamilyKey);
            
            if (productFamilyDto == null) {
                productFamilyDto = new ContractDto.ProductFamily();
                
                productFamilyDto.familyName = quoteRecord.Communication_Language__c == ApexConstants.ENGLISH
                    ? quoteLineItemRecord.Product2.Family
                    : ApexConstants.productFamilyTranslations.get(quoteLineItemRecord.Product2.Family);
                productFamilyDto.subtotalRC = quoteLineItemRecord.Initial_Subtotal__c;
            }
            
            //build the quote line item
            ContractDto.QuoteLineItem quoteLineItemDto = new ContractDto.QuoteLineItem(
                quoteLineItemRecord.vlocity_cmt__OneTimeCharge__c,
                quoteLineItemRecord.Quantity == null ? 0 : Integer.valueOf(quoteLineItemRecord.Quantity),
                quoteLineItemRecord.Customer_Facing_Comments__c,
                getProduct2Name(quoteRecord, quoteLineItemRecord),
                quoteLineItemRecord.Product2.Family,
                quoteLineItemRecord.vlocity_cmt__RecurringCharge__c,
                quoteLineItemRecord.vlocity_cmt__QuoteMemberId__c == null ? quoteLineItemRecord.vlocity_cmt__ServiceAccountId__c : quoteLineItemRecord.vlocity_cmt__QuoteMemberId__c,
                false,
                Integer.valueOf(quoteLineItemRecord.Term__c),
                quoteLineItemRecord.Download_Speed__c,
                (quoteLineItemRecord.vlocity_cmt__RecurringCharge__c * quoteLineItemRecord.Quantity) + (quoteLineItemRecord.vlocity_cmt__OneTimeCharge__c * quoteLineItemRecord.Quantity),
                quoteRecord.Communication_Language__c == ApexConstants.ENGLISH ? ApexConstants.ENGLISH_LOCALE : ApexConstants.FRENCH_LOCALE
            );
            
            //Add discounts if available
            List<ContractDto.QuoteLineItem> relatedPromotions = new List<ContractDto.QuoteLineItem>();

            quoteMemberToQuoteLineItemMap.put(fullLineItemKey, quoteLineItemDto);
            familyDtoMap.put(memberToFamilyKey, productFamilyDto);
        }
        
        quoteMemberToQuoteLineItemMap.remove(null);
        quoteMemberMap.remove(null);
        familyDtoMap.remove(null);
        
        for (String quoteLineItemKey : quoteMemberToQuoteLineItemMap.keyset()) {  
            ContractDto.QuoteLineItem quoteLineItemDto = quoteMemberToQuoteLineItemMap.get(quoteLineItemKey);
            ContractDto.QuoteMember quoteMemberDto = quoteMemberMap.get(quoteLineItemDto.quoteMemberId);
            ContractDto.ProductFamily productFamilyDto = familyDtoMap.get(quoteLineItemDto.productFamily + ApexConstants.PIPE + quoteLineItemDto.quoteMemberId);           
            
            if (quoteLineItemDto.isPromotion) {
                quoteLineItemDto.oneTimeCharge = quoteLineItemDto.oneTimeCharge * -1;
                quoteLineItemDto.oneTimeChargeFormatted = DateAndTime.getFormattedCurrency(quoteLineItemDto.oneTimeCharge,quoteRecord.Communication_Language__c);
                quoteLineItemDto.recurringCharge = quoteLineItemDto.recurringCharge * -1;
                quoteLineItemDto.recurringChargeFormatted = DateAndTime.getFormattedCurrency(quoteLineItemDto.recurringCharge,quoteRecord.Communication_Language__c);
                quoteLineItemDto.charge = quoteLineItemDto.recurringCharge * quoteLineItemDto.quantity;
                quoteLineItemDto.chargeFormatted = DateAndTime.getFormattedCurrency(quoteLineItemDto.charge,quoteRecord.Communication_Language__c);
            }
            
            if (!registerAssignmentOfFamilytoMember.containsKey(quoteLineItemDto.quoteMemberId)) {
                productFamilyDto.subtotalRC = (quoteLineItemDto.recurringCharge == null ? 0 : quoteLineItemDto.recurringCharge);
                productFamilyDto.subtotalRCFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.subtotalRC,quoteRecord.Communication_Language__c);
                productFamilyDto.subtotalOT = (quoteLineItemDto.oneTimeCharge == null ? 0 : quoteLineItemDto.oneTimeCharge);
                productFamilyDto.subtotalOTFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.subtotalOT,quoteRecord.Communication_Language__c);
                productFamilyDto.chargeSubTotal = (quoteLineItemDto.charge == null ? 0 : quoteLineItemDto.charge);
                productFamilyDto.chargeSubTotalFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.chargeSubTotal,quoteRecord.Communication_Language__c);
                productFamilyDto.quoteLineItems.add(quoteLineItemDto);
                
                quoteMemberDto.productFamilies.add(productFamilyDto);
                quoteMemberDto.RCTotalQM = (quoteLineItemDto.recurringCharge == null ? 0 : quoteLineItemDto.recurringCharge);
                quoteMemberDto.RCTotalQMFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.RCTotalQM,quoteRecord.Communication_Language__c);
                quoteMemberDto.OTTotalQM = (quoteLineItemDto.oneTimeCharge == null ? 0 : quoteLineItemDto.oneTimeCharge);
                quoteMemberDto.OTTotalQMFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.OTTotalQM,quoteRecord.Communication_Language__c);
                quoteMemberDto.chargeTotal = (quoteLineItemDto.charge == null ? 0 : quoteLineItemDto.charge);
                quoteMemberDto.chargeTotalFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.chargeTotal,quoteRecord.Communication_Language__c);
                quoteMemberDto.totalRecurringChargeWithQuantity = (quoteLineItemDto.recurringCharge == null ? 0 : quoteLineItemDto.recurringCharge) * (quoteLineItemDto.quantity == null ? 0 : quoteLineItemDto.quantity);
                quoteMemberDto.totalRecurringChargeWithQuantityFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.totalRecurringChargeWithQuantity,quoteRecord.Communication_Language__c);
                List<String> initialAssignmentToProdFamily = new List<String>();
                initialAssignmentToProdFamily.add(quoteLineItemDto.productFamily);
                registerAssignmentOfFamilytoMember.put(quoteLineItemDto.quoteMemberId, initialAssignmentToProdFamily);
            } else {
                if (registerAssignmentOfFamilytoMember.get(quoteLineItemDto.quoteMemberId).contains(quoteLineItemDto.productFamily)) {
                    
                    for (ContractDto.ProductFamily memberFamily : quoteMemberDto.productFamilies) {
                        if (memberFamily.familyName == productFamilyDto.familyName) {
                            memberFamily.subtotalRC += (quoteLineItemDto.recurringCharge == null ? 0 : quoteLineItemDto.recurringCharge);
                            memberFamily.subtotalRCFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.subtotalRC,quoteRecord.Communication_Language__c);
                            memberFamily.subtotalOT += (quoteLineItemDto.oneTimeCharge == null ? 0 : quoteLineItemDto.oneTimeCharge);
                            memberFamily.subtotalOTFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.subtotalOT,quoteRecord.Communication_Language__c);
                            memberFamily.chargeSubTotal += (quoteLineItemDto.charge == null ? 0 : quoteLineItemDto.charge);
                            memberFamily.chargeSubTotalFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.chargeSubTotal,quoteRecord.Communication_Language__c);
                            
                            if (memberFamily.quoteLineItems == null) {
                                memberFamily.quoteLineItems = new List<ContractDto.QuoteLineItem>();
                            }
                            memberFamily.quoteLineItems.add(quoteLineItemDto);
                        }
                    }
                } else {
                    productFamilyDto.subtotalRC = (quoteLineItemDto.recurringCharge == null ? 0 : quoteLineItemDto.recurringCharge);
                    productFamilyDto.subtotalRCFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.subtotalRC,quoteRecord.Communication_Language__c);
                    productFamilyDto.subtotalOT = (quoteLineItemDto.oneTimeCharge == null ? 0 : quoteLineItemDto.oneTimeCharge);
                    productFamilyDto.subtotalOTFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.subtotalOT,quoteRecord.Communication_Language__c);
                    productFamilyDto.chargeSubTotal = (quoteLineItemDto.charge == null ? 0 : quoteLineItemDto.charge);
                    productFamilyDto.chargeSubTotalFormatted = DateAndTime.getFormattedCurrency(productFamilyDto.chargeSubTotal,quoteRecord.Communication_Language__c);
                    productFamilyDto.quoteLineItems.add(quoteLineItemDto);
                    quoteMemberDto.productFamilies.add(productFamilyDto);
                    registerAssignmentOfFamilytoMember.get(quoteLineItemDto.quoteMemberId).add(quoteLineItemDto.productFamily);
                }
                
                quoteMemberDto.RCTotalQM += (quoteLineItemDto.recurringCharge == null ? 0 : quoteLineItemDto.recurringCharge);
                quoteMemberDto.RCTotalQMFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.RCTotalQM,quoteRecord.Communication_Language__c);
                quoteMemberDto.OTTotalQM += (quoteLineItemDto.oneTimeCharge == null ? 0 : quoteLineItemDto.oneTimeCharge);
                quoteMemberDto.OTTotalQMFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.OTTotalQM,quoteRecord.Communication_Language__c);
                quoteMemberDto.chargeTotal += (quoteLineItemDto.charge == null ? 0 : quoteLineItemDto.charge);
                quoteMemberDto.chargeTotalFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.chargeTotal,quoteRecord.Communication_Language__c);
                quoteMemberDto.totalRecurringChargeWithQuantity += (quoteLineItemDto.recurringCharge == null ? 0 : quoteLineItemDto.recurringCharge) * (quoteLineItemDto.quantity == null ? 0 : quoteLineItemDto.quantity);
                quoteMemberDto.totalRecurringChargeWithQuantityFormatted = DateAndTime.getFormattedCurrency(quoteMemberDto.totalRecurringChargeWithQuantity,quoteRecord.Communication_Language__c);
            }
        }
        
        ContractDto contractDto = new ContractDto(
            String.valueOf(Date.today()),
            quoteRecord.Account.Name,
            quoteRecord.Account.ShippingStreet,
            quoteRecord.Account.ShippingCity,
            quoteRecord.Account.ShippingCountry,
            quoteRecord.Account.ShippingState,
            quoteRecord.Account.ShippingPostalCode,
            quoteRecord.Recurring_Total__c,
            quoteRecord.vlocity_cmt__OneTimeTotal__c,
            quoteMemberMap.values(),
            quoteRecord.Communication_Language__c,
            quoteRecord.Terms_Conditions__c
        );
        
        contractDto.companyAddress = getCompanyAddress(quoteRecord.Account.Territory__r.Province__c);
        contractDto.numberOfMembers = quoteMemberMap.keyset().size();
        
        if (contractDto.numberOfMembers != null && contractDto.numberOfMembers > 1) {
            if (quoteRecord.Communication_Language__c == ApexConstants.ENGLISH) {
                contractDto.summaryString = ApexConstants.NEW_LINE + 'Your monthly charges will be: ' + contractDto.recurringTotal;
            } else if(quoteRecord.Communication_Language__c == ApexConstants.FRENCH) {
                contractDto.summaryString = ApexConstants.NEW_LINE + 'Votre tarif mensuel dans les mois: ' + contractDto.recurringTotal;
            }
        }
        
        return JSON.serialize(contractDto);
    }

    private static String getCompanyAddress(String province) {
        if (province == ApexConstants.PROVINCE_QC) {
            return '1, Place Ville-Marie, bureau 3301, Montréal (Québec), ' + ApexConstants.NEW_LINE + 'H3B 3N2, Canada,' + ApexConstants.NEW_LINE + '("Cogeco") ';
        } 
        return '950 Syscon Road, Burlington, ' + ApexConstants.NEW_LINE + 'L7L 5J7, Canada,' + ApexConstants.NEW_LINE + '(the “COGECO”)';
    }    

    private static String getProduct2Name(Quote quoteRecord, QuoteLineItem lineItem) {
        if (quoteRecord.Communication_Language__c == ApexConstants.ENGLISH) {
            return lineItem.Product2.Product_Name_C__c;
        } else if(quoteRecord.Communication_Language__c == ApexConstants.FRENCH) {
            return lineItem.Product2.Product_Name_FR_C__c;
        }
        //return english by default
        return lineItem.Product2.Name;
    }
}