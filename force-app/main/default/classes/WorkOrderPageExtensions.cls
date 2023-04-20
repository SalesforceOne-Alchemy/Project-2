public with sharing class WorkOrderPageExtensions {
  public WorkOrder worko { get; set; }
  public String passingRecordId { get; set; }

  //Construtor
  public WorkOrderPageExtensions(ApexPages.StandardSetController sc) {
    String recordId = ApexPages.currentPage().getParameters().get('id');
    if (recordId != null) {
      this.worko = [
        SELECT
          Id,
          WorkOrderNumber,
          Status,
          Priority,
          AccountId,
          ContactId,
          AssetId,
          CaseId,
          EntitlementId,
          Subject,
          Description
        FROM WorkOrder
        WHERE Id = :recordId
      ];
    } else {
      this.worko = new WorkOrder();
      this.worko.Status = defaultPickList('Status');
      this.worko.Priority = defaultPickList('Priority');
    }
  }

  //Default fields for picklist
  public String defaultPickList(String picklistName) {
    List<String> pickListValuesList = new List<String>();
    switch on picklistName {
      when 'Status' {
        Schema.DescribeFieldResult fieldResult = WorkOrder.Status.getDescribe();
        List<Schema.PicklistEntry> picklist = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : picklist) {
          pickListValuesList.add(pickListVal.getLabel());
        }
        String returnVar = pickListValuesList[0];
        return returnVar;
      }
      when 'Priority' {
        Schema.DescribeFieldResult fieldResult = WorkOrder.Priority.getDescribe();
        List<Schema.PicklistEntry> picklist = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : picklist) {
          pickListValuesList.add(pickListVal.getLabel());
        }
        String returnVar = pickListValuesList[0];
        return returnVar;
      }
    }
    return '';
  }

  //DML statement methods + navigation
  public PageReference createRecord() {
    PageReference createPage = Page.CreateWorkOrder;
    createPage.setRedirect(true);
    return createPage;
  }
  public PageReference cancelRecord() {
    PageReference cancelPage = Page.WorkOrder;
    cancelPage.setRedirect(true);
    return cancelPage;
  }

  public PageReference createSaveRecord() {
    try {
      upsert this.worko;
      PageReference workoPage = Page.WorkOrder;
      workoPage.setRedirect(true);
      return workoPage;
    } catch (DmlException de) {
      ApexPages.addMessages(de);
      return null;
    }
  }

  public PageReference deleteWorkOrder() {
    try {
      WorkOrder deleteRecord = new WorkOrder();
      deleteRecord = [
        SELECT Id, WorkOrderNumber
        FROM WorkOrder
        WHERE id = :passingRecordId
      ];
      delete deleteRecord;
      PageReference pageref = Page.WorkOrder;
      pageref.setRedirect(true);
      return pageref;
    } catch (Exception ex) {
      ApexPages.addMessages(ex);
      return null;
    }
  }
}
