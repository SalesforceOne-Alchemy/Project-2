public class OrderItemFVPMainExtender {
   
    public OrderItem OrdItem {get;set;}
  
    
    public ApexPages.StandardController sc;
    public OrderItemFVPMainExtender(ApexPages.StandardController sc) {
      this.sc=sc;
      Id recordId = ApexPages.currentPage().getParameters().get('id');    
      this.OrdItem =[SELECT Id,OrderId,Quantity,UnitPrice FROM OrderItem WHERE Id=:recordId];
    }
    
    // cancel edit Orderitem
public PageReference cancelOrderItem() {
   
    PageReference cancelPage = Page.OrderVFPDetail;
    cancelPage.getParameters().put('id',OrdItem.OrderId);
    cancelPage.setRedirect(true);
    return cancelPage;
  }

  // OrderItem Save
  public PageReference orderItemSave(){
    try{
        
        this.sc.save();
        PageReference savePage = Page.OrderVFPDetail;
        savePage.getParameters().put('id',OrdItem.OrderId);
         savePage.setRedirect(true);
         return savePage;
    } catch (DmlException e){
        ApexPages.addMessages(e);
        return null;
    }
  }

}