public with sharing class AccountCustomController {
    public Account acct{get; set;}
    public Id accountId{get;set;}
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