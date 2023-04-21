/*===========================================================================*/
/* Name: CHRISTOPHER BOAMAH MENSAH
         Revature LLC                                                        */

/* Purpose: This test class provides positive, negative, and restrictive user
            tests.                                                           */
/* Methods: static void testDataEntry()
            --> This method runs a positive test to verify that data gets
                successfully saved.  
            static void testNoDataEntry()
            --> This method runs a negative test to verify that an error is 
                raised with no data is entered.                              
            static void testDeleteData()
            --> This method runs a positive test to verify that deletion of 
                was successful.
            static void testNoDeleteData()
            --> This method runs a negative test to verify that the deletion
                of non-existant data raises an error.                        
            static void testEditData()
            --> This method runs a positive test to verify that data was 
                edited successfully.
            static void testToContactPage()
            --> This method runs a positive test to verify successful 
                redirection to ContactPage.
            static void testToContactListPage()
            --> This method runs a positive test to verify successful
                redirection to ContactListPage.                              */
/*===========================================================================*/
@isTest
private class ContactControllerExtTest {
  @isTest static void testDataEntry() {
    // set test page
    Pagereference pageRef = Page.ContactPage;
    Test.setCurrentPage(pageRef);

    // test data
    Contact cont = new Contact(LastName='Test1');

    // instantiate controller
    ApexPages.StandardController stdController;
    ContactControllerExt controller = new ContactControllerExt(stdController);
    controller.cont = cont;
    String nextPage = controller.saveOrEditRecord().getUrl(); 

    // verify that the ContactList page displays
    System.assertEquals('/apex/contactlistpage', nextPage);
  }

  @isTest static void testNoDataEntry() {
    // set test page
    Pagereference pageRef = Page.ContactPage;
    Test.setCurrentPage(pageRef);

    // test data
    Contact cont = new Contact();

    // instantiate controller
    ApexPages.StandardController stdController;
    ContactControllerExt controller = new ContactControllerExt(stdController);
    controller.cont = cont;
    Pagereference nextPage = controller.saveOrEditRecord(); 

    // verify that an expection is raised when an empty record is tried to save
    System.assertEquals(null, nextPage);
    System.assert(ApexPages.getMessages().size() > 0);
  }

  @isTest static void testDeleteData() {
    // set test page
    Pagereference pageRef = Page.ContactListPage;
    Test.setCurrentPage(pageRef);

    // test data
    Contact cont = new Contact(LastName='Test1');

    insert cont;

    // instantiate constructor
    ApexPages.StandardSetController stdSetController;
    ContactControllerExt controller = new ContactControllerExt(stdSetController);
    controller.delRecordId = cont.Id;

    // verify that the ContactListPage page displays
    String nextPage = controller.deleteRecord().getUrl();
    Contact deletedContact = [SELECT Id, IsDeleted FROM Contact WHERE Id = :cont.Id ALL ROWS];
    System.assertEquals(true, deletedContact.IsDeleted);
    System.assertEquals('/apex/contactlistpage', nextPage);
  }

  @isTest static void testNoDeleteData() {
    // set test page
    Pagereference pageRef = Page.ContactListPage;
    Test.setCurrentPage(pageRef);

    // test data
    Contact cont = new Contact(LastName='Test1');

    insert cont;

    // instantiate controller
    ApexPages.StandardSetController stdSetController;
    ContactControllerExt controller = new ContactControllerExt(stdSetController);
    controller.delRecordId = cont.Id;
    
    delete cont; // delete record before the delete method in controller
    Pagereference nextPage = controller.deleteRecord(); 

    // verify that an expection is raised when an empty record is tried to be deleted
    System.assertEquals(null, nextPage);
    System.assert(ApexPages.getMessages().size() > 0);
  }

  @isTest static void testEditData() {
    // set test page
    Pagereference pageRef = Page.ContactPage;
    Test.setCurrentPage(pageRef);

    // test data
    Account acct = new Account(Name='Account Test1');
    Contact cont = new Contact(LastName='Test1');

    insert acct;
    insert cont;

    cont.FirstName = 'User';
    cont.AccountId = acct.Id;
    cont.Phone = '(603) 532-2988';
    cont.Email = 'User.Test1@test.com';

    // instantiate controller
    ApexPages.StandardController stdController;
    ContactControllerExt controller = new ContactControllerExt(stdController);
    controller.cont = cont;
    String nextPage = controller.saveOrEditRecord().getUrl();

    // verify that the ContactListPage page displays
    System.assertEquals('/apex/contactlistpage', nextPage);
  }

  @isTest static void testToContactPage() {
    // set test page
    Pagereference pageRef = Page.ContactListPage;
    Test.setCurrentPage(pageRef);

    // instantiate controller
    ApexPages.StandardController stdController;
    ContactControllerExt controller = new ContactControllerExt(stdController);
    
    Pagereference nextPage = controller.toContactPage();

    // verify that page is redirected to ContactPage
    System.assertEquals('/apex/contactpage', nextPage.getUrl());
  }

  @isTest static void testToContactListPage() {
    // set test page
    Pagereference pageRef = Page.ContactPage;
    Test.setCurrentPage(pageRef);

    // instantiate controller
    ApexPages.StandardSetController stdSetController;
    ContactControllerExt controller = new ContactControllerExt(stdSetController);
    
    Pagereference nextPage = controller.toContactListPage();

    // verify that page is redirected to ContactListPage
    System.assertEquals('/apex/contactlistpage', nextPage.getUrl());
  }
}
