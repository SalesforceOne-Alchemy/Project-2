public with sharing class LeadCustomController {
    private ApexPages.StandardController sc;
    private final Lead ld;
    public LeadCustomController() {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            ld = [SELECT Id, FirstName, LastName, Company, Status, CurrencyIsoCode FROM Lead WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }
        else{
            ld = new Lead();
        }
    }

    public Lead getLead(){
        return ld;
    }

    public PageReference save(){
        try{
            upsert ld;
            return Page.LeadViewPage;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
}