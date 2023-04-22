/*
* AccountExtension.cls
* Author(s): Dorian Alexander Patterson
*/
public with sharing class AccountExtension {
    public Account acct {get; set;}
    public Id recordId {get; set;}
    public ApexPages.StandardSetController stdSetController;

    public AccountExtension(ApexPages.StandardSetController stdSetController) {
        this.stdSetController = stdSetController;
        if(recordId != null){
            this.acct = (Account) stdSetController.getRecord();
        }
    }

    // Deletes one account record. Used on list views.
    public PageReference deleteAccount(){
        try{
            Account accountToDelete = [SELECT Id FROM Account WHERE Id = :recordId];
            delete accountToDelete;
            PageReference pr = Page.AccountViewPage;
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }

    // Action to take when the New button is clicked
    public PageReference newAccount(){
        PageReference pr = Page.AccountCreateEditPage;
        pr.setRedirect(true);
        return pr;
    }
}