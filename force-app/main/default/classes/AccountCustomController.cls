public with sharing class AccountCustomController {
    private ApexPages.StandardController sc;
    private final Account account;
    public AccountCustomController() {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            account = [SELECT Id, Name, Rating, Phone, ParentId FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }
        else{
            account = new Account();
        }
    }

    public Account getAccount(){
        return account;
    }

    public PageReference save(){
        try{
            upsert account;
            return Page.AccountViewPage;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
}