@isTest
public with sharing class AccountCustomControllerTest {
    @TestSetup
    static void makeData(){
        Account account = new Account(
            Name = 'Account Name',
            Rating = 'Hot',
            Phone = '7061234567'
        );
        insert account;
    }

    public static testMethod void testConstructorPositive(){
        PageReference pr = Page.AccountCreateEditPage;
        Test.setCurrentPage(pr);
        AccountCustomController controller = new AccountCustomController();

        // No Account ID passed, therefore the Account object should be empty (no Name, no Rating, No Phone, No ParentId);

        Assert.isNotNull(controller.getAccount());
        Assert.areEqual(null, controller.getAccount().Name);
        Assert.areEqual(null, controller.getAccount().Rating);
        Assert.areEqual(null, controller.getAccount().Phone);
        Assert.areEqual(null, controller.getAccount().ParentId);

        // Record Id passed
        String recordId = (String) [SELECT Id FROM Account WHERE Name = 'Account Name' LIMIT 1].Id;

        ApexPages.currentPage().getParameters().put('id', recordId);

        controller = new AccountCustomController();

        Assert.isNotNull(controller.getAccount());
        Assert.areEqual('Account Name', controller.getAccount().Name);
        Assert.areEqual('Hot', controller.getAccount().Rating);
        Assert.areEqual('7061234567', controller.getAccount().Phone);
        Assert.areEqual(null, controller.getAccount().ParentId);
    }

    // Id passed is invalid
    public static testMethod void testConstructorNegative(){
        PageReferene pr = Page.AccountCreateEditPage;
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('id', 'invalidid');
        AccountCustomController controller = new AccountCustomController();
    }

    public static testMethod void testGetAccountPositive(){

    }

    public static testMethod void testGetAccountNegative(){

    }

    public static testMethod void testGetAccountIdPositive(){

    }

    public static testMethod void testGetAccountIdNegative(){

    }

    public static testMethod void testSavePositive(){

    }

    public static testMethod void testSaveNegative(){

    }

    public static testMethod void testRestrictedUser(){

    }
}