/*===========================================================================*/
/* Name: CHRISTOPHER BOAMAH MENSAH
         Revature LLC                                                        */

/* Purpose: This is a helper class that provides logic for ContactTrigger.   */
/*===========================================================================*/
public class ContactTriggerHelper {
  public static void contactTriggerLogic(List<Contact> triggConts) {
    String s1 = null; // this will hold the email from triggering record
    String s2 = null; // this will hold the email from a list of contacts associated with accounts
    List<String> l1 = new List<String>(); // this will hold a list of boths parts of s1 (before and after @)
    List<String> l2 = new List<String>(); // this will hold a list of boths parts of s2 (before and after @)
    List<Contact> contWithAccList = [SELECT AccountId, Email
                                     FROM Contact
                                     WHERE AccountId != null];

    for (Contact c : triggConts) {
      for (Contact ca : contWithAccList) {
        if ((c.AccountId == ca.AccountId) && (String.isNotEmpty(c.Email) && String.isNotEmpty(ca.Email))) {
          s1 = c.Email; s2 = ca.Email;
          l1 = s1.split('@');
          l2 = s2.split('@');
            
          if (l1[1] != l2[1]) {
            c.addError('Email has to have the same domain as all other emails associated with this Account');
          }

          if (l1[1] == l2[1]) {
            break;
          }
        }
      }
    }
  }
}
