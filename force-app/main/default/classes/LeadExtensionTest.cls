@isTest
public with sharing class LeadExtensionTest {
    @TestSetup
    static void makeData(){
        List<Lead> leadList = new List<Lead>();
        for(Integer i = 0; i < 150; i++){
            Lead acc = new Lead(
                LastName = 'Lead Name ' + i,
                Company = 'Company ' + i
            );
            leadList.add(acc);
        }
        insert leadList;
    }

    public static testMethod void testConstructorPositive(){
        PageReference pr = Page.LeadViewPage;
        Test.setCurrentPage(pr);
        List<Lead> leadList = [SELECT FirstName, LastName, Company, Status FROM Lead];
        LeadExtension extension = new LeadExtension(new ApexPages.StandardSetController(leadList));

        Assert.isNotNull(extension);
    }

    //TODO: negative constructor test
    //TODO: positive deleteLead test
    public static testMethod void testDeleteLeadPositive(){
        PageReference pr = Page.LeadViewPage;
        Test.setCurrentPage(pr);
        List<Lead> leadList = [SELECT FirstName, LastName, Company, Status FROM Lead];
        LeadExtension extension = new LeadExtension(new ApexPages.StandardSetController(leadList));
        Lead leadToDelete = [SELECT LastName FROM Lead WHERE LastName = 'Lead Name 1'];
        extension.recordId = leadToDelete.Id;
        PageReference nextPagePr = extension.deleteLead();

        Assert.areEqual(0, [SELECT COUNT() FROM Account WHERE Id = :extension.recordId]);

    }
    //TODO: negative deleteLead test
    public static testMethod void testDeleteLeadNegative(){
        PageReference pr = Page.LeadViewPage;
        Test.setCurrentPage(pr);
        List<Lead> leadList = [SELECT FirstName, LastName, Company, Status FROM Lead];
        LeadExtension extension = new LeadExtension(new ApexPages.StandardSetController(leadList));
        PageReference deletePageReference = extension.deleteLead();

        Assert.isNull(deletePageReference);
        Assert.isTrue(ApexPages.getMessages().size() > 0);
    }

    //TODO: positive newLead test
    public static testMethod void testNewLeadPositive(){
        PageReference pr = Page.LeadViewPage;
        Test.setCurrentPage(pr);
        List<Lead> leadList = [SELECT FirstName, LastName, Company, Status FROM Lead];
        LeadExtension extension = new LeadExtension(new ApexPages.StandardSetController(leadList));

        String nextPage = extension.newLead().getUrl();

        Assert.areEqual('/apex/leadcreateeditpage', nextPage);
    }

    //TODO: Restricted user test
}