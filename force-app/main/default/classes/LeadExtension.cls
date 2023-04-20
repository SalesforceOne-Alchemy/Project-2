public with sharing class LeadExtension {
    public Lead ld {get; set;}
    public Id recordId {get; set;}
    public ApexPages.StandardSetController stdSetController;

    public LeadExtension(ApexPages.StandardSetController stdSetController) {
        this.stdSetController = stdSetController;
        if(recordId != null){
            this.ld = (Lead) stdSetController.getRecord();
        }
    }

    public LeadExtension(ApexPages.StandardController stdController){
        if(recordId != null){
            this.ld = (Lead) stdController.getRecord();
        }
    }

    // Deletes one account record. Used on list views.
    public PageReference deleteLead(){
        try{
            Lead leadToDelete = [SELECT Id FROM Lead WHERE Id = :recordId];
            delete leadToDelete;
            PageReference pr = Page.LeadViewPage;
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }

    public Integer getPageNubmer(){
        return stdSetController.getPageNumber();
    }

    public Integer getTotalPages(){
        Decimal totalRecords = stdSetController.getResultSize();
        return (Integer) Math.ceil (totalRecords / stdSetController.getPageSize());
    }

    public PageReference newLead(){
        try{
            PageReference pr = Page.LeadCreateEditPage;
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
}