/*===========================================================================*/
/* Name: CHRISTOPHER BOAMAH MENSAH
         Revature LLC                                                        */

/* Purpose: This test class runs unit tests for ContactTrigger. 
            Single and bulk action tests are done. Also, positive and negative 
            tests are done.                                                  */
/* Methods: static void testContactEmailSame()
            --> This method runs a negative test to verify that the trigger
                does not fire when a user's email domain is the same as those
                from the other contacts related to a particular account.  
            static void testContactEmailNotSame()
            --> This method runs a positive test to verify that the trigger
                prevents a user from adding an email with a different email 
                domain to all other contacts related to a particular account.
            static void testContactBulkEmailNotSame()
            --> This method runs a bulk positive test to verify that the 
                trigger prevents a set of users from adding emails with 
                different email domains to all other contacts related to a 
                particular account.
            static void testContactWithAccountButNoEmail()
            --> This method runs a negative test to verify that the trigger
                does not fire when a user (who is related to an account) 
                does not enter an email.
            static void testContactWithNoAccountAndNoEmail()
            --> This method runs a negative test to verify that the trigger
                does not fire when a user (who is not related to an account) 
                does not enter an email.
            static void testContactWithEmailButNoAccount()
            --> This method runs a negative test to verify that the trigger
                does not fire when a user (who is not related to an account) 
                enters an email.                                             */            
/*===========================================================================*/
@isTest
private class ContactTriggerTest {
  @isTest static void testContactEmailSame() {
    // test data setup
    Contact[] conts = ContactDataFactory.createContactsSingleTest();

    // perform test
    Test.startTest();
    Database.SaveResult dsr = Database.insert(conts[0], false);
    Test.stopTest();

    // verify that insertion was a success
    System.assert(dsr.isSuccess());  
  }

  @isTest static void testContactEmailNotSame() {
    // test data setup
    Contact[] conts = ContactDataFactory.createContactsSingleTest();
    
    // perform test
    Test.startTest();
    Database.SaveResult dsr = Database.insert(conts[1], false);
    Test.stopTest();

    // verify that when the contact gets inserted with a different email domain to all the other contacts related to a
    // particular account, an error is thrown
    System.assert(!dsr.isSuccess());
    System.assert(dsr.getErrors().size() > 0);
    System.assertEquals('Email has to have the same domain as all other emails associated with this Account', 
                        dsr.getErrors()[0].getMessage());
  }

  @isTest static void testContactBulkEmailNotSame() {
    // test data setup
    Contact[] conts = ContactDataFactory.createContactsBulkTest(5);

    // perform test
    Test.startTest();
    Database.SaveResult[] dsrs = Database.insert(conts, false);
    Test.stopTest();

    // verify that when each contact gets inserted with a different email domain to all the other contacts related to a
    // particular account, an error is thrown
    for (Database.SaveResult dsr : dsrs) {
      System.assert(!dsr.isSuccess());
      System.assert(dsr.getErrors().size() > 0);
      System.assertEquals('Email has to have the same domain as all other emails associated with this Account', 
                          dsr.getErrors()[0].getMessage());
    }
  }

  @isTest static void testContactWithAccountButNoEmail() {
    // test data setup
    Contact[] conts = ContactDataFactory.createContactsSingleTest();

    // perform test
    Test.startTest();
    Database.SaveResult dsr = Database.insert(conts[2], false);
    Test.stopTest();

    // verify that insertion was a success
    System.assert(dsr.isSuccess());    
  }

  @isTest static void testContactWithNoAccountAndNoEmail() {
    // test data setup
    Contact[] conts = ContactDataFactory.createContactsSingleTest();

    // perform test
    Test.startTest();
    Database.SaveResult dsr = Database.insert(conts[3], false);
    Test.stopTest();

    // verify that insertion was a success
    System.assert(dsr.isSuccess());
  }

  @isTest static void testContactWithEmailButNoAccount() {
    // test data setup
    Contact[] conts = ContactDataFactory.createContactsSingleTest();

    // perform test
    Test.startTest();
    Database.SaveResult dsr = Database.insert(conts[4], false);
    Test.stopTest();

    // verify that insertion was a success
    System.assert(dsr.isSuccess());
  }

  @isTest static void testUpdateContactEmailNotSame() {
    // test data setup
    Contact[] conts = ContactDataFactory.createContactsForUpdateSingleTest();
    
    conts[5].Email = 'User.S1@notest1.com';

    // perform test
    Test.startTest();
    Database.SaveResult dsr = Database.update(conts[5], false);
    Test.stopTest();

    // verify that when the contact gets updated with a different email domain to all the other contacts related to a
    // particular account, an error is thrown
    System.assert(!dsr.isSuccess());
    System.assert(dsr.getErrors().size() > 0);
    System.assertEquals('Email has to have the same domain as all other emails associated with this Account', 
                        dsr.getErrors()[0].getMessage());
  }
}
