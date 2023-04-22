@isTest
public with sharing class AccountExtensionTest {
    @TestSetup
    static void makeData(){
        List<Account> accountList = new List<Account>();
        for(Integer i = 0; i < 150; i++){
            Account acc = new Account(
                Name = 'Account Name ' + i
            );
            accountList.add(acc);
        }
        insert accountList;
    }

    public static testMethod void testConstructorPositive(){
        PageReference pr = Page.AccountViewPage;
        Test.setCurrentPage(pr);
        List<Account> accountList = [SELECT Id, Name, Rating, Phone, ParentId FROM Account];
        AccountExtension extension = new AccountExtension(new ApexPages.StandardSetController(accountList));

        Assert.isNotNull(extension);
    }

    //TODO: negative constructor test
    //TODO: positive deleteAccount test
    public static testMethod void testDeleteAccountPositive(){
        PageReference pr = Page.AccountViewPage;
        Test.setCurrentPage(pr);
        List<Account> accountList = [SELECT Id, Name, Rating, Phone, ParentId FROM Account];
        AccountExtension extension = new AccountExtension(new ApexPages.StandardSetController(accountList));
        Account accountToDelete = [SELECT Name FROM Account WHERE Name = 'Account Name 1'];
        extension.recordId = accountToDelete.Id;
        PageReference nextPagePr = extension.deleteAccount();

        Assert.areEqual(0, [SELECT COUNT() FROM Account WHERE Id = :extension.recordId]);

    }
    //TODO: negative deleteAccount test
    public static testMethod void testDeleteAccountNegative(){
        PageReference pr = Page.AccountViewPage;
        Test.setCurrentPage(pr);
        List<Account> accountList = [SELECT Id, Name, Rating, Phone, ParentId FROM Account];
        AccountExtension extension = new AccountExtension(new ApexPages.StandardSetController(accountList));
        PageReference deletePageReference = extension.deleteAccount();

        Assert.isNull(deletePageReference);
        Assert.isTrue(ApexPages.getMessages().size() > 0);
    }

    //TODO: positive newAccount test
    public static testMethod void testNewAccountPositive(){
        PageReference pr = Page.AccountViewPage;
        Test.setCurrentPage(pr);
        List<Account> accountList = [SELECT Id, Name, Rating, Phone, ParentId FROM Account];
        AccountExtension extension = new AccountExtension(new ApexPages.StandardSetController(accountList));

        String nextPage = extension.newAccount().getUrl();

        Assert.areEqual('/apex/accountcreateeditpage', nextPage);
    }

    //TODO: Restricted user test
}