/*===========================================================================*/
/* Name: CHRISTOPHER BOAMAH MENSAH
         Revature LLC                                                        */

/* Purpose: This trigger checks that the email field is similar to that of all 
            other Contacts related to the same Account. If there is no 
            similarity, the record is stopped from being saved. This trigger 
            runs before a record gets inserted or updated.                    */
/*===========================================================================*/
trigger ContactTrigger on Contact (before insert, before update) {
  if ((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) {
    ContactTriggerHelper.contactTriggerLogic(Trigger.new);
  }
}
