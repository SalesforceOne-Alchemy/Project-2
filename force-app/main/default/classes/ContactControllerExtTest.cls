/*===========================================================================*/
/* Name: CHRISTOPHER BOAMAH MENSAH
         Revature LLC                                                        */

/* Purpose: This test class provides positive, negative, and restrictive user
            tests.                                                           */
/* Methods: static void testDataEntry()
            --> This method runs a positive test to verify that data gets
                successfully saved.                                          */
/*===========================================================================*/
@isTest
private class ContactControllerExtTest {
  static testMethod void testDataEntry() {
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

    // verify that the ContactListPage page displays
    System.assertEquals('/apex/ContactListPage', nextPage);
  }
}
