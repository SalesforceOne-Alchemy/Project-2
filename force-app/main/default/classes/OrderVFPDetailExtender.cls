// David Melech
public with sharing class OrderVFPDetailExtender {
    public Order ord{get;set;}
    public OrderItem ordItem{get;set;}
    public Id delId {get;set;}
    public Id addProId {get;set;}
    
    public Boolean ShowAddProduct{get;set;}
    private ApexPages.StandardController sc;

    Id recordId = ApexPages.currentPage().getParameters().get('id');
   
    public OrderVFPDetailExtender(ApexPages.StandardController sc) {
        this.ShowAddProduct = false; //hide product add section
        this.sc = sc;
        if (this.recordId == null){
            this.ord = new Order();
        }else{
            this.ord =(Order)sc.getRecord();
            this.ord.Id = recordId;
            }
    }

    // cancel button
    public PageReference cancelRecord() {
        PageReference cancelPage = Page.OrderVFPMain;
        cancelPage.setRedirect(true);
        return cancelPage;
      }

// inline delete OrderItem
    public void deleteRecord() {
        try{
            OrderItem c = [SELECT id FROM OrderItem WHERE id =: this.delId];
            delete c;
            this.sc.save();
        } catch (DmlException e){
            ApexPages.addMessages(e);
       
        }
    }
    
// main save 
    public void saveList() {
        try{
            
            this.sc.save();
            this.ord =(Order)sc.getRecord();
        } catch (DmlException e){
            ApexPages.addMessages(e);
       
        }
    }

// make new OrderItem
    public void makeAddProduct(){
        
        this.ordItem = new OrderItem(OrderId = this.ord.Id);

        ShowAddProduct = true; //show add product section
    }

// add Product to OrderItem
    public void addOrderItem(){
      
       try{
           List<PricebookEntry> PBE = [SELECT Id,Pricebook2Id,Product2Id, UnitPrice,Name FROM PricebookEntry WHERE Pricebook2Id =:ord.Pricebook2Id AND Product2Id =:this.ordItem.Product2Id];
           for(PricebookEntry pbeList :PBE){
           this.OrdItem.UnitPrice = pbeList.UnitPrice;
          this.OrdItem.ListPrice = pbeList.UnitPrice;
           this.OrdItem.Product2Id = this.addProId; // might not need
           this.OrdItem.PricebookEntryId = pbeList.Id;
           }
           insert this.OrdItem;
            this.sc.save();
           ShowAddProduct = false; //rehide add product
           
       } catch (DmlException e){
           ApexPages.addMessages(e);
           
        }
    }

    public PageReference editOrderItem() {
    
        PageReference cancelPage = Page.OrderItemVFPMain;
        cancelPage.getParameters().put('id',delId);
        cancelPage.setRedirect(true);
        return cancelPage;
      }
    

}
