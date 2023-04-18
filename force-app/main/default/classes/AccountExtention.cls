public with sharing class AccountExtention {
    public Account acct {get; set;}
    public Id recordId {get; set;}
    public String accountName {get; set;}

    public AccountExtention(ApexPages.StandardSetController stdSetController) {
        if(recordId != null){
            this.acct = (Account) stdSetController.getRecord();
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