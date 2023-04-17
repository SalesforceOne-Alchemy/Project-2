/*===========================================================================*/
/* Name: CHRISTOPHER BOAMAH MENSAH
         Revature LLC                                                        */

/* Purpose: This controller provides added functionality to ContactList and
            ContactPage visualforce pages. The added functionality comes in
            the form of a page redirection after an update/insert action.    */
/*===========================================================================*/
public class ContactControllerExt {
  public Contact cont {get; set;}

  public ContactControllerExt(ApexPages.StandardController stdController) {
    String recordId = ApexPages.currentPage().getParameters().get('id');

    if (recordId == null) {
      this.cont = new Contact();
    } else {
      this.cont = [
        SELECT FirstName, LastName, Title 
        FROM Contact 
        WHERE id = :recordId
      ];
    }
  }

  public ContactControllerExt(ApexPages.StandardSetController stdSetController) {}

  public Pagereference saveOrEditRecord() {
    try {
      upsert cont;

      Pagereference contactListPage = new Pagereference('/apex/ContactListPage');
      contactListPage.setRedirect(true);

      return contactListPage;
    } catch (DmlException de) {
      Apexpages.addMessages(de);
      return null;
    }
  }
}
