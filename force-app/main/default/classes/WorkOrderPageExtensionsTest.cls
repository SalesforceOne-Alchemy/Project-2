/*
    Created and Tested by: Jancarlo Sevilla

    Testing Item: WorkOrderPageExtensions
    Project Name: Revature's Project 2 FBC
    Company Name: Revature 
    Use Case - Work Order Visual Force Page


*/
@isTest
private class WorkOrderPageExtensionsTest {
  @TestSetup
  static void makeData() {
    Account makeAccount = new Account(Name = 'Test Account');
    insert makeAccount;
    RecordType rt = new RecordType(Name='Service Tech');
    Id recordTypeIdTest = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Service Tech').getRecordTypeId();
    Contact makeContact = new Contact(FirstName = 'John', LastName = 'Testing', recordTypeId = recordTypeIdTest);
    insert makeContact;
    WorkOrder makeWorkOrder = new WorkOrder();
    makeWorkOrder.AccountId = makeAccount.Id;
    makeWorkOrder.ContactId = makeContact.Id;
    insert makeWorkOrder;
    WorkOrder secondWorkOrder = new WorkOrder();
    secondWorkOrder.AccountId = makeAccount.Id;
    secondWorkOrder.ContactId = makeContact.Id;
    insert secondWorkOrder;
  }

  @isTest
  private static void createRecordTest() {
    PageReference testPage = new PageReference('/apex/createworkorder');

    ApexPages.StandardSetController sc;
    WorkOrderPageExtensions workPage = new WorkOrderPageExtensions(sc);
    PageReference actualPage = workPage.createRecord();

    Assert.areEqual(testPage.getURL(), actualPage.getURL());
  }

  @isTest
  private static void cancelRecordTest() {
    Pagereference testPage = Page.WorkOrder;

    ApexPages.StandardSetController sc;
    WorkOrderPageExtensions workPage = new WorkOrderPageExtensions(sc);

    PageReference actualPage = workPage.cancelRecord();

    Assert.areEqual(testPage.getURL(), actualPage.getURL());
  }

  @isTest
  private static void deleteRecordTest() {
    WorkOrder testWorkOrder = [SELECT Id FROM WorkOrder LIMIT 1];
    PageReference pageTest = Page.WorkOrder;
    Test.setCurrentPage(pageTest);

    ApexPages.StandardSetController sc;
    WorkOrderPageExtensions workPage = new WorkOrderPageExtensions(sc);
    workPage.passingRecordId = testWorkOrder.id;
    PageReference actualPage = workPage.deleteWorkOrder();

    WorkOrder recycleWorkOrder = [
      SELECT Id, IsDeleted
      FROM WorkOrder
      WHERE Id = :testWorkOrder.Id
      ALL ROWS
    ];

    Assert.areEqual(recycleWorkOrder.IsDeleted, true);
    Assert.areEqual(pageTest.getURL(), actualPage.getURL());
  }

  @isTest
  private static void deleteRecordNegativeTest() {
    WorkOrder testWorkOrder = [SELECT Id FROM WorkOrder LIMIT 1];
    PageReference pageTest = Page.WorkOrder;
    Test.setCurrentPage(pageTest);

    ApexPages.StandardSetController sc;
    WorkOrderPageExtensions workPage = new WorkOrderPageExtensions(sc);

    workPage.passingRecordId = null;
    PageReference actualPageFalse = workPage.deleteWorkOrder();

    WorkOrder recycleWorkOrderFalse = [
      SELECT Id, IsDeleted
      FROM WorkOrder
      WHERE Id = :testWorkOrder.Id
      ALL ROWS
    ];

    Assert.areNotEqual(recycleWorkOrderFalse.IsDeleted, true);
    Assert.isNull(actualPageFalse);
  }

  @isTest
  private static void defaultPicklistTest() {
    WorkOrder testWorkPage = new WorkOrder();

    ApexPages.StandardSetController sc;
    WorkOrderPageExtensions workPage = new WorkOrderPageExtensions(sc);
    workPage.worko.Status = workPage.defaultPickList('');

    Assert.areEqual('--None--', workPage.worko.Status);
    Assert.areNotEqual(testWorkPage.Status, workPage.worko.Status);
  }

  @isTest
  private static void createSaveRecordTest() {
    //initialize testing items
    List<WorkOrder> workOrderTestList = new List<WorkOrder>();
    WorkOrder workOrderTest = new WorkOrder();
    WorkOrder passingWorkOrder = [SELECT Id, WorkOrderNumber, AccountId, ContactId FROM WorkOrder ORDER BY WorkOrderNumber LIMIT 1];
    workOrderTest.AccountId = passingWorkOrder.AccountId;
    WorkorderTest.ContactId = passingWorkOrder.ContactId;

    workOrderTestList.add(workOrderTest);
    PageReference pageTest = Page.WorkOrder;
    Test.setCurrentPage(pageTest);

    //passing testing items to component method.
    ApexPages.StandardSetController sc = new ApexPages.StandardSetController(workOrderTestList);
    WorkOrderPageExtensions workPage = new WorkOrderPageExtensions(sc);
    workPage.worko = workOrderTest;
    PageReference actualPage = workPage.createSaveRecord();

    //record inserted page testing.
    assert.areEqual(pageTest.getURL(), actualPage.getURL());
    //insert testing
    List<WorkOrder> testChange = [SELECT Id, WorkOrderNumber, Status FROM WorkOrder LIMIT 3];
    assert.areEqual(3, testChange.Size());

    //failed insert DML Exception
    List<WorkOrder> workOrderTestListFail = new List<WorkOrder>();
    WorkOrder workOrderTestFail = new WorkOrder();
    workOrderTestListFail.add(workOrderTestFail);
    PageReference pageTestFail = Page.WorkOrder;
    Test.setCurrentPage(pageTestFail);

    //passing testing items to component method.
    ApexPages.StandardSetController scFail = new ApexPages.StandardSetController(workOrderTestListFail);
    WorkOrderPageExtensions workPageFail = new WorkOrderPageExtensions(scFail);
    workPageFail.worko = workOrderTestFail;
    PageReference actualPageFail = workPageFail.createSaveRecord();

    Assert.isNull(actualPageFail);

  }

  @isTest
  private static void updateRecordTest() {
    //initialize items to be test
    List<WorkOrder> workOrderTestList = new List<WorkOrder>();
    WorkOrder firstWorkOrder = [SELECT Id, WorkOrderNumber, Status FROM WorkOrder ORDER BY WorkOrderNumber LIMIT 1];
    WorkOrder secondWorkOrder = [SELECT Id, WorkOrderNumber, Status FROM WorkOrder ORDER BY WorkOrderNumber DESC LIMIT 1];
    workOrderTestList.add(firstWorkOrder);
    workOrderTestList.add(secondWorkOrder);

    //setting up page to retrieve id of initialized items
    PageReference testPage = Page.CreateWorkOrder;
    Test.setCurrentPage(testPage);
    ApexPages.currentPage().getParameters().put('id', firstWorkOrder.Id);

    //Setting up controller
    ApexPages.StandardSetController sc = new ApexPages.StandardSetController(workOrderTestList);
    WorkOrderPageExtensions ac = new WorkOrderPageExtensions(sc);
    //testing page of first record Id.
    String pageId = ApexPages.currentPage().getParameters().get('id');

    Assert.areEqual(pageId, firstWorkOrder.id);

    //Testing the second record page by comparing it to the first record page and seeing if the two records are different pages.
    PageReference testDifferentPage = Page.CreateWorkOrder;
    Test.setCurrentPage(testDifferentPage);
    ApexPages.currentPage().getParameters().put('id', secondWorkOrder.Id);
    String secondPageId = ApexPages.currentPage().getParameters().get('id');

    Assert.areNotEqual(secondPageId, pageId);


    //update checking DML statement used within the createSaveRecord();
    firstWorkOrder.Status = 'On Hold';
    workOrderTestList.clear();
    workOrderTestList.add(firstWorkOrder);
    ApexPages.StandardSetController scUpdateStatus = new ApexPages.StandardSetController(workOrderTestList);
    WorkOrderPageExtensions acUpdateStatus = new WorkOrderPageExtensions(scUpdateStatus);
    acUpdateStatus.worko=firstWorkOrder;
    acUpdateStatus.createSaveRecord();

    WorkOrder testChange = [SELECT Id, WorkOrderNumber, Status FROM WorkOrder WHERE Status = 'On Hold' LIMIT 1];
    Assert.areEqual(testChange.Status, firstWorkOrder.Status);
  }
}