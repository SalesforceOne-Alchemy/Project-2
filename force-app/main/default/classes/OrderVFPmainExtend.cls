// David Melech
public with sharing class OrderVFPmainExtend {
    private ApexPages.StandardSetController ssc;
    public Id ordId {get;set;}
    public OrderVFPmainExtend(ApexPages.StandardSetController ssc) {
        this.ssc = ssc;
    }
    // create new record
public PageReference createRecord() {
    PageReference createPage = Page.OrderVFPDetail;
    createPage.setRedirect(true);
    return createPage;
  }

  public PageReference deleteRecord() {
    try{
        Order orderDel = new Order(Id=ordId);
        delete orderDel;
        PageReference returnPage = Page.OrderVFPMain;
        returnPage.setRedirect(true);
        return returnPage;
    } catch (DmlException e){
        ApexPages.addMessages(e);
        return null;
   
    }
}

    // cancel edit Orderitem
    public PageReference editRecord() {
        PageReference cancelPage = Page.OrderVFPDetail;
        cancelPage.getParameters().put('id',ordId);
        cancelPage.setRedirect(true);
        return cancelPage;
      }
}