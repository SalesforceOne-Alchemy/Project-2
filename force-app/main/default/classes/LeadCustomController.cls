/*
 * LeadCustomController.cls
 * Author(s): Dorian Alexander Patterson
 */
public with sharing class LeadCustomController {
    public Lead lead{get;set;}
    public Id leadId {get; set;}
    public LeadCustomController() {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            leadId = ApexPages.currentPage().getParameters().get('id');
            lead = [SELECT Id, FirstName, LastName, Company, Status FROM Lead WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }
        else{
            lead = new Lead();
        }
    }

    public PageReference cancel(){
        PageReference pr = Page.LeadViewPage;
        pr.setRedirect(true);
        return pr;
    }

    public PageReference save(){
        try{
            upsert lead;
            return Page.LeadViewPage;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
}