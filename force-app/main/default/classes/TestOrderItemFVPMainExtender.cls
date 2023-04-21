/*
Test class to test the Order Visualforce page main (home) page

*/
@isTest
public class TestOrderItemFVPMainExtender {
    @TestSetup
    public static void makeData(){
        Account acc = new Account(Name='testacc');
        insert acc;
        Contract cont = new Contract(AccountId=acc.Id, Status='Draft', ContractTerm=21,StartDate=Date.today());
        insert cont;
        cont.Status='Activated';
        update cont;
        Product2 pro = new Product2(Name = 'test product',IsActive=true);
        insert pro;
        //PriceBook2 pb2= new Pricebook2(Name='Standard Price Book',IsActive=true);
        //insert pb2;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,Product2Id=pro.Id,UnitPrice =1,IsActive=true,UseStandardPrice=false);
        insert pbe;
        Order ord = new Order(AccountId=acc.Id,ContractId=cont.Id,EffectiveDate= Date.today(),Status='Draft',Pricebook2Id =pricebookId);
        insert ord;
        OrderItem orItem = new OrderItem(Product2Id=pro.Id,PriceBookEntryId=pbe.Id,OrderId=ord.Id,UnitPrice =1,Quantity =1);
        insert orItem;
        }
     
        @isTest
        public static void testcancelOrderItem(){
        // Set test page
        OrderItem ordItem = [SELECT Id,OrderId FROM OrderItem LIMIT 1];
        Pagereference pageref = Page.OrderItemVFPMain;
        pageref.getParameters().put('id',ordItem.Id);
        Test.setCurrentPage(pageref);
        // instantiate controler
        ApexPages.StandardController sc;
        OrderItemFVPMainExtender ctr = new OrderItemFVPMainExtender(sc);
        // test page display
        String nextPage = ctr.cancelOrderItem().getUrl();
        Pagereference pageref2 = Page.OrderVFPdetail;
        pageref2.getParameters().put('id',ordItem.OrderId);
        String URLtest = pageref2.getUrl();
        System.assertEquals(URLTest, nextPage);
        }
        @isTest
        public static void testorderItemSave(){
        // Set test page
        OrderItem ordItem = [SELECT Id,OrderId,Quantity,UnitPrice FROM OrderItem LIMIT 1];
        Pagereference pageref = Page.OrderItemVFPMain;
        pageref.getParameters().put('id',ordItem.Id);
        Test.setCurrentPage(pageref);
        // instantiate controler
        ApexPages.StandardController sc= new ApexPages.StandardController(ordItem);
        OrderItemFVPMainExtender ctr = new OrderItemFVPMainExtender(sc);
        
        // test page display
        String nextPage = ctr.orderItemSave().getUrl();
        Pagereference pageref2 = Page.OrderVFPdetail;
        pageref2.getParameters().put('id',ordItem.OrderId);
        String URLtest = pageref2.getUrl();
        System.assertEquals(URLTest, nextPage);
        }        

}