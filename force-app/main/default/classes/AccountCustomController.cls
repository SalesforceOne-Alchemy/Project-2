public with sharing class AccountCustomController {
    public Account account{get; set;}
    public Id accountId{get;set;}
    public AccountCustomController() {
        try{

            if(ApexPages.currentPage().getParameters().get('id') != null){
                accountId = ApexPages.currentPage().getParameters().get('id');
                account = [SELECT Id, Name, Rating, Phone, ParentId FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            }
            else{
                account = new Account();
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
    }

    public PageReference cancel(){
        PageReference pr = Page.AccountViewPage;
        pr.setRedirect(true);
        return pr;
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