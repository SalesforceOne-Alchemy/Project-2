public with sharing class AccountCustomController {
    private ApexPages.StandardController sc;
    private final Account account;
    public AccountCustomController() {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            account = [SELECT Id, Name FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }
        else{
            account = new Account();
        }
    }

    public Account getAccount(){
        return account;
    }

    public PageReference save(){
        upsert account;
        return Page.AccountViewPage;
    }
}