public with sharing class AccountExtension {
    public Account acct {get; set;}
    public Id recordId {get; set;}
    public String accountName {get; set;}

    public AccountExtension(ApexPages.StandardSetController stdSetController) {
        if(recordId != null){
            this.acct = (Account) stdSetController.getRecord();
        }
    }

    public AccountExtension(ApexPages.StandardController stdController){
        if(recordId != null){
            this.acct = (Account) stdController.getRecord();
        }
    }

    // Deletes one account record. Used on list views.
    public Pagereference upsertAccount(){
        Account accountToUpsert;
        try{
            // Insert
            if(recordId == null){
                accountToUpsert = new Account();
            }
            // Update
            else{
                accountToUpsert = acct;
            }
            accountToUpsert.Name = accountName;
            // Call upsert
            upsert accountToUpsert;

            // Handle redirect
            PageReference pr = new PageReference('/apex/AccountViewPage');
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
    public PageReference deleteAccount(){
        try{
            Account accountToDelete = [SELECT Id FROM Account WHERE Id = :recordId];
            delete accountToDelete;
            PageReference pr = new PageReference('/apex/AccountViewPage');
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }

}