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

    public AccountExtension(ApexPages.StandardController stdController){
        if(recordId != null){
            this.acct = (Account) stdController.getRecord();
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

    // Return the current page of total for paginated lists
    public Integer getPageNumber(){
        return stdSetController.getPageNumber();
    }

    // Return the total number of pages based on the number of records selected to be displayed.
    public Integer getTotalPages(){
        Decimal totalRecords = stdSetController.getResultSize();
        return (Integer) Math.ceil(totalRecords / stdSetController.getPageSize());
    }

    // Action to take when the New button is clicked
    public PageReference newAccount(){
        try{
           PageReference pr = Page.AccountCreateEditPage;
           pr.setRedirect(true);
           return pr;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
}