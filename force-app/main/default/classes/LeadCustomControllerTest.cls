/*
 * LeadCustomControllerTest.cls
 * Author(s): Dorian Alexander Patterson
 */
@isTest
public with sharing class LeadCustomControllerTest {
    @TestSetup
    static void makeData(){
        Lead lead = new Lead(
            FirstName = 'Dorian',
            LastName = 'Patterson',
            Company = 'Revature',
            Status = 'Open - Not Contacted'
        );
        insert lead;
    }

    public static testMethod void testConstructorPositive(){
        PageReference pr = Page.LeadCreateEditPage;
        Test.setCurrentPage(pr);
        LeadCustomController controller = new LeadCustomController();

        // No Lead ID passed, therefore the Lead object should be empty

        Assert.isNotNull(controller.lead);
        Assert.isNull(controller.lead.FirstName);
        Assert.isNull(controller.lead.LastName);
        Assert.isNull(controller.lead.Company);
        Assert.isNull(controller.lead.Status);

        // Record Id passed
        String leadId = (String) [SELECT Id FROM Lead WHERE FirstName = 'Dorian' LIMIT 1].Id;

        ApexPages.currentPage().getParameters().put('id', leadId);

        controller = new LeadCustomController();

        Assert.isNotNull(controller.lead);
        Assert.areEqual('Dorian', controller.lead.FirstName);
        Assert.areEqual('Patterson', controller.lead.LastName);
        Assert.areEqual('Revature', controller.lead.Company);
        Assert.areEqual('Open - Not Contacted', controller.lead.Status);
    }

    public static testMethod void testCancelPositive(){
       PageReference pr = Page.LeadCreateEditPage;
       Test.setCurrentpage(pr);
       LeadCustomController controller = new LeadCustomController();
       String nextPage = controller.cancel().getUrl();

       Assert.areEqual('/apex/leadviewpage', nextPage);
    }
    // TODO: Write negative cancel test

    // Postive test for upserting leads.
    public static testMethod void testSavePositive(){
        Lead testLead = [ SELECT Id, FirstName, LastName, Company, Status
                                FROM Lead
                                WHERE FirstName = 'Dorian'];
        String insertLeadFirstName = 'Alex';
        PageReference pr = Page.LeadCreateEditPage;
        Test.setCurrentPage(pr);
        LeadCustomController controller = new LeadCustomController();
        controller.lead.FirstName = insertLeadFirstName;
        controller.save();

        Lead insertedLead = [SELECT FirstName FROM Lead WHERE FirstName = :insertLeadFirstName];
        Assert.isNotNull(insertedLead);
        Assert.areNotEqual(testLead.Id, insertedLead.Id);

        // Test Update
        String updateLeadFirstName = 'Alice';
        ApexPages.currentPage().getParameters().put('id', testLead.Id);
        controller = new LeadCustomController();
        controller.lead.FirstName = updateLeadFirstName()

    }

    // TODO: negative save test
    public static testMethod void testSaveNegative(){
        PageReference pr = Page.LeadCreateEditPage;
        Test.setCurrentPage(pr);
        LeadCustomController controller = new LeadCustomController();
        controller.lead = null;

        PageReference negativePr = controller.save();

        Assert.isNull(negativePr);
    }

    // TODO: Restricted user test
    public static testMethod void testRestrictedUser(){

    }
}