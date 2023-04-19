/*===========================================================================*/
/* Name: CHRISTOPHER BOAMAH MENSAH
         Revature LLC                                                        */

/* Purpose: This class provides contact data to the ContactTriggerTest class.*/
/* Methods: public static List<Contact> createContactsSingleTest() 
            --> This method creates records for positive and negative single
                action insert tests.   
            public static List<Contact> createContactsBulkTest(Integer N)    
            --> This method creates records for a bulk action insert test.   
            public static List<Contact> createContactsForUpdateSingleTest()
            --> This method creates records for positive single action update 
                test.                                                        */
/*===========================================================================*/
@isTest
public class ContactDataFactory {
  public static List<Contact> createContactsSingleTest() {
    List<Contact> contList = new List<Contact>();
    List<Contact> contTList = new List<Contact>();
    List<Account> acctList = new List<Account>();

    acctList.add(new Account(Name='Account Test 1'));
    acctList.add(new Account(Name='Account Test 2'));
    acctList.add(new Account(Name='Account Test 3'));
    insert acctList;

    contTList.add(new Contact(LastName='S1', Email='User.S1@test1.com', AccountId=acctList[0].Id));
    contTList.add(new Contact(LastName='S2', Email='User.S1@test2.com', AccountId=acctList[1].Id));
    contTList.add(new Contact(LastName='S3', Email='User.S1@test3.com', AccountId=acctList[2].Id));
    contTList.add(new Contact(LastName='S4', AccountId=acctList[0].Id));
    contTList.add(new Contact(LastName='S5'));
    insert contTList;

    contList.add(new Contact(LastName='T1', Email='User.T1@test3.com', AccountId=acctList[2].Id));
    contList.add(new Contact(LastName='T2', Email='User.T2@notest2.com', AccountId=acctList[1].Id));
    contList.add(new Contact(LastName='T3', AccountId=acctList[0].Id));
    contList.add(new Contact(LastName='T4'));
    contList.add(new Contact(LastName='T5', Email='User.T5@test.com'));

    return contList;
  }

  public static List<Contact> createContactsBulkTest(Integer N) {
    List<Contact> contList = new List<Contact>();
    List<Contact> contTList = new List<Contact>();
    List<Account> acctList = new List<Account>();

    acctList.add(new Account(Name='Account Test 1'));
    acctList.add(new Account(Name='Account Test 2'));
    acctList.add(new Account(Name='Account Test 3'));
    insert acctList;

    contTList.add(new Contact(LastName='S1', Email='User.S1@test1.com', AccountId=acctList[0].Id));
    contTList.add(new Contact(LastName='S2', Email='User.S2@test2.com', AccountId=acctList[1].Id));
    contTList.add(new Contact(LastName='S3', Email='User.S2@test3.com', AccountId=acctList[2].Id));
    contTList.add(new Contact(LastName='S4', AccountId=acctList[0].Id));
    contTList.add(new Contact(LastName='S5'));
    insert contTList;

    for (Integer i = 0; i < N; i++) {
      contList.add(new Contact(LastName='Ta'+i, Email='User.Ta'+i+'@notest3.com', AccountId=acctList[2].Id));
    }
    return contList;
  }

  public static List<Contact> createContactsForUpdateSingleTest() {
    List<Contact> contTList = new List<Contact>();
    List<Account> acctList = new List<Account>();

    acctList.add(new Account(Name='Account Test 1'));
    acctList.add(new Account(Name='Account Test 2'));
    acctList.add(new Account(Name='Account Test 3'));
    insert acctList;

    contTList.add(new Contact(LastName='S1', Email='User.S1@test1.com', AccountId=acctList[0].Id));
    contTList.add(new Contact(LastName='S2', Email='User.S1@test2.com', AccountId=acctList[1].Id));
    contTList.add(new Contact(LastName='S3', Email='User.S1@test3.com', AccountId=acctList[2].Id));
    contTList.add(new Contact(LastName='S4', AccountId=acctList[0].Id));
    contTList.add(new Contact(LastName='S5'));
    contTList.add(new Contact(LastName='S6', Email='User.S1@test1.com', AccountId=acctList[0].Id));
    insert contTList;

    return contTList;
  }
}
