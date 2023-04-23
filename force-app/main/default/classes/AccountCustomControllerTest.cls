/*
 * AccountCustomControllerTest.cls
 * Author(s): Dorian Alexander Patterson
 */
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

        Assert.isNotNull(controller.account);
        Assert.areEqual(null, controller.account.Name);
        Assert.areEqual(null, controller.account.Rating);
        Assert.areEqual(null, controller.account.Phone);
        Assert.areEqual(null, controller.account.ParentId);

        // Record Id passed
        String accountId = (String) [SELECT Id FROM Account WHERE Name = 'Account Name' LIMIT 1].Id;

        ApexPages.currentPage().getParameters().put('id', accountId);

        controller = new AccountCustomController();

        Assert.isNotNull(controller.account);
        Assert.areEqual('Account Name', controller.account.Name);
        Assert.areEqual('Hot', controller.account.Rating);
        Assert.areEqual('7061234567', controller.account.Phone);
        Assert.areEqual(null, controller.account.ParentId);
    }

    public static testMethod void testCancelPositive(){
       PageReference pr = Page.AccountCreateEditPage;
       Test.setCurrentpage(pr);
       AccountCustomController controller = new AccountCustomController();
       String nextPage = controller.cancel().getUrl();

       Assert.areEqual('/apex/accountviewpage', nextPage);
    }
    // TODO: Write negative cancel test

    // Postive test for upserting accounts.
    public static testMethod void testSavePositive(){
        // Test insert
        // Required: Name
        Account testAccount = [ SELECT Id, Name
                                FROM Account
                                WHERE Name = 'Account Name'];
        String insertAccountName = 'Account Name for Inserted Account';
        PageReference pr = Page.AccountCreateEditPage;
        Test.setCurrentPage(pr);
        AccountCustomController controller = new AccountCustomController();
        controller.account.Name = insertAccountName;
        controller.save();

        Account insertedAccount = [ SELECT Id, Name
                                    FROM Account
                                    WHERE Name = :insertAccountName LIMIT 1];
        Assert.isNotNull(insertedAccount);
        Assert.areNotEqual(testAccount.Id, insertedAccount.Id);

        // Test update
        String updateAccountName = 'Pokemon Company';
        pr = Page.AccountCreateEditPage;
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('id', testAccount.Id);
        controller = new AccountCustomController();
        controller.account.Name = updateAccountName;
        controller.save();

        Account updatedAccount = [SELECT Id FROM Account WHERE Name = :updateAccountName LIMIT 1];

        Assert.isNotNull(insertedAccount);
        Assert.areEqual(testAccount.Id, updatedAccount.Id);

    }

    // TODO: negative save test
    public static testMethod void testSaveNegative(){
        PageReference pr = Page.AccountCreateEditPage;
        Test.setCurrentPage(pr);
        AccountCustomController controller = new AccountCustomController();
        controller.account = null;

        PageReference negativePr = controller.save();

        Assert.isNull(negativePr);
    }

    // TODO: Restricted user test
    public static testMethod void testRestrictedUser(){

    }
}