public with sharing class AccountCustomController {
    private ApexPages.StandardController sc;
    private final Account acct;
    private Id accountId;
    public AccountCustomController() {
        try{

            if(ApexPages.currentPage().getParameters().get('id') != null){
                accountId = ApexPages.currentPage().getParameters().get('id');
                acct = [SELECT Id, Name, Rating, Phone, ParentId FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            }
            else{
                acct = new Account();
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
    }

    public Account getAccount(){
        return acct;
    }

    public Id getAccountId(){
        return accountId;
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