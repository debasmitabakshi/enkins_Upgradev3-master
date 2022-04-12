public class AccountTriggerHelper {
    /*public static void validateAccountSite(List<Account> accNewList){
        for(Account accNewRec:accNewList){
            if(string.isBlank(accNewRec.site)){
                accNewRec.addError('Account site can not be blank');
            }
        }
    }
    /*public static void validatePostalCodeAndUpdate(List<Account> accNewList){
        /*for(Account accRec: accNewList){
            if(String.isNotBlank(accRec.BillingPostalCode)){
                List<Postal_info__c> postList =[SELECT Id, Name, City__c, State__c, Billing_country__c FROM Postal_info__c where Name =: accRec.BillingPostalCode];
                if(postList.isEmpty()){
                    accRec.addError('Invalid Postal code');
                    
                }
                
            }
        }*/
         //inbetween 1
        /*List<String> postalCodeList = new List<String>();
        for(Account accRec: accNewList){
            if(String.isNotBlank(accRec.BillingPostalCode)){
                postalCodeList.add(accRec.BillingPostalCode);
            }
            
        }
        List<Postal_info__c> postList =[SELECT Id, Name, Billing_country__c, State__c, City__c FROM Postal_info__c 
                                        Where Name IN :postalCodeList];
        Map<String,Postal_info__c> postalCodeMap = new Map<String,Postal_info__c>();
        for(Postal_info__c postalCodeRec: postList){
            postalCodeMap.put(postalCodeRec.Name,postalCodeRec);
        }
        for(Account accRec: accNewList){
            if(String.isNotBlank(accRec.BillingPostalCode) && !postalCodeMap.containsKey(accRec.BillingPostalCode)){
                accRec.addError('invalid code');
            }else{
                accRec.BillingCity = postalCodeMap.get(accRec.BillingPostalCode).City__c;
                accRec.BillingState = postalCodeMap.get(accRec.BillingPostalCode).State__c;
                accRec.BillingCountry = postalCodeMap.get(accRec.BillingPostalCode).Billing_country__c;
            }
                
        }
        
    }*/
    /*public static void validateAccountNumChange(List<Account> accNewList,Map<Id,Account> accNewMap,List<Account> accOldList,Map<Id,Account> accOldMap){
        //bad practice
        /*for(Account accNewRec : accNewList){
            for(Account accOldRec : accOldList){
                if(accNewRec.AccountNumber != accOldRec.AccountNumber){
                    accNewRec.addError('can\'t change account number');
                        
                }
            }
        }*/
        //2
        /*for(Account accNewRec : accNewList){
            if(accOldMap.containsKey(accNewRec.Id) && accOldMap.get(accNewRec.Id).AccountNumber != accNewRec.AccountNumber){
                accNewRec.addError('can\'t change account number');
            }
        }
        
    }*/
    /*public static void validateAccDel(List<Account> accOldList,Map<Id,Account> accOldMap){
       /* for(Account accOldRec : accOldMap.values()){
            List<Opportunity> oppList = [Select Id from Opportunity where AccountId =:accOldRec.Id];
            if(!oppList.isEmpty()){
                accOldRec.addError('you can not delete account');
            }
        }*/
        /*List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity where AccountId IN : accOldMap.Keyset()];
        Map<Id,List<Opportunity>> newOldMap = new  Map<Id,List<Opportunity>>();
        for(Opportunity oppRec : oppList){
            if(newOldMap.containsKey(oppRec.AccountId)){
                List<Opportunity> existingOppList = newOldMap.get(oppRec.AccountId);
                existingOppList.add(oppRec);
                newOldMap.put(oppRec.AccountId,existingOppList);
            }
            else {
                (newOldMap.put(oppRec.AccountId, new List<Opportunity> {oppRec}));
            }
        }
        for(Account accOldRec : accOldMap.values()){
            if(newOldMap.containsKey(accOldRec.Id) && !newOldMap.get(accOldRec.Id).isEmpty()){
                accOldRec.addError('you can not delete account');
            }
        }*/
        
        /*List<Account> accList = [Select Id,(select id,AccountId from opportunities)from Account where Id IN:accOldMap.Keyset() ];
        Map<Id,List<Opportunity>> newOldMap = new  Map<Id,List<Opportunity>>();
        for(Account accRec : accList){
            newOldMap.put(accRec.id, accRec.Opportunities);
        }
        for(Account accOldRec : accOldMap.values()){
            if(newOldMap.containsKey(accOldRec.Id) && !newOldMap.get(accOldRec.Id).isEmpty()){
                accOldRec.addError('you can not delete account');
            }
        }*/
        //3
        /*Map<Id,Account> accMap = new Map<Id,Account>([Select Id,(Select id,AccountId from Opportunities) from Account Where Id IN:accOldMap.Keyset()]);
        for(Account accOldRec : accOldMap.values()){
            if(accMap.containsKey(accOldRec.Id) && accMap.get(accOldRec.Id).Opportunities.size()>0){
                accOldRec.addError('you can not delete account');
                
            }
        }
    } */
    public static void updateContactMailingAddress(List<Account> accNewList, Map<Id,Account> accNewMap){
        List<Contact> ctList = [SELECT Id,Name,AccountId, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry FROM Contact where AccountId IN :accNewMap.Keyset()];
        //Map<AccountId, List of contacts
        Map<Id,List<Contact>> ctAccMap = new Map<Id,List<Contact>>();
        for(Contact ctRec : ctList){
            if(ctAccMap.containsKey(ctRec.AccountId)){
                List<Contact> existingContactList = ctAccMap.get(ctRec.AccountId);
                existingContactList.add(ctRec);
                ctAccMap.put(ctRec.AccountId,existingContactList);
            }
            else{
                (ctAccMap.put(ctRec.AccountId,new List<Contact> {ctRec}));
            }
        }
        List<Contact> updateContacList = new List<Contact>();
        for(Account accRec : accNewList){
            for(Contact contactRec : ctAccMap.get(accRec.Id)) {
                contactRec.MailingStreet = accRec.BillingStreet;
                contactRec.MailingCity = accRec.BillingCity;
                contactRec.MailingState = accRec.BillingState;
                contactRec.MailingCountry = accRec.BillingCountry;
                contactRec.MailingPostalCode = accRec.BillingPostalCode;
                updateContacList.add(contactRec);
               }
            }
        if(!updateContacList.isEmpty()){
            update updateContacList;
        }
        }
    /*public static void updateRelatedOpportunity(List<Account> accNewList, Map<Id,Account> accNewMap){
        list<Opportunity> allOpp = [Select Id,Name from Opportunity where AccountId != Null];
        List<Opportunity> updateOppList = new List<Opportunity>();
        for(Account accrec:accNewList){
            for(Opportunity oppRec :allOpp){
                if(oppRec.CreatedDate >System.today()+30 && oppRec.StageName != 'Closed Won'){
                    oppRec.StageName = 'Closed Lost';
                    updateOppList.add(oppRec);
                }
                if(!updateOppList.isEmpty()){
                update updateOppList;
            }
            }
        }
    }*/
    public static void updateRelatedContact(List<Account> accNewList, Map<Id,Account> accNewMap){
        
        // Collect all in the Set to avoid Duplicate 
        Set<Id> accIdSet = new Set<Id>();
        for(Account  eAcc:accNewList)
        {
            accIdSet.add(eAcc.Id); // Pushing all the Account Id to the Set 
        }
        
        if(accIdSet.size()>0)
        {
              // key : String , Value : list<Opportunity>
            Map<String,list<Opportunity>> checkOppStage = new  Map<String,list<Opportunity>>();
            for(Opportunity eOpp : [Select Id , AccountId , StageName From Opportunity Where AccountId IN : accIdSet ])
            {
                if(checkOppStage.containsKey(eOpp.AccountId))
                {
                    
                }
            }
        }
        
        
        
       
    }
    
}