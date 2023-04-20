public with sharing class AccountCustomController {
    private ApexPages.StandardController sc;
    private final Account acct;
    public AccountCustomController() {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            acct = [SELECT Id, Name, Rating, Phone, ParentId FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }
        else{
            acct = new Account();
        }
    }

    public Account getAccount(){
        return acct;
    }

    public PageReference save(){
        try{
            upsert acct;
            return Page.AccountViewPage;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
}