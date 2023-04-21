/*
Test class to test the Order Visualforce page main (home) page
David Melech
*/
@isTest
public class TestOrderVFPDetailExtender {
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
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,Product2Id=pro.Id,UnitPrice =1,IsActive=true,UseStandardPrice=false);
        insert pbe;
        Order ord = new Order(AccountId=acc.Id,ContractId=cont.Id,EffectiveDate= Date.today(),Status='Draft',Pricebook2Id =pricebookId);
        insert ord;
        OrderItem orItem = new OrderItem(Product2Id=pro.Id,PriceBookEntryId=pbe.Id,OrderId=ord.Id,UnitPrice =1,Quantity =1);
        insert orItem;
        }
     
        @isTest
        public static void testcancelRecord(){
        // Set test page
        Order ordItem = [SELECT Id FROM Order LIMIT 1];
        Pagereference pageref = Page.OrderItemVFPMain;
        pageref.getParameters().put('id',ordItem.Id);
        Test.setCurrentPage(pageref);
        // instantiate controler
       
        ApexPages.StandardController sc= new ApexPages.StandardController(ordItem);
        OrderVFPDetailExtender ctr = new OrderVFPDetailExtender(sc);
        // test page display
        String nextPage = ctr.cancelRecord().getUrl();
        Pagereference pageref2 = Page.OrderVFPMain;
        String URLtest = pageref2.getUrl();
        System.assertEquals(URLtest, nextPage);
        }
        @isTest      
        public static void testdeleteRecord(){
            // Set test page
            PageReference pageref = Page.OrderVFPmain;
            Test.setCurrentPage(pageref);
            OrderItem TestOrd = [SELECT Id FROM OrderItem LIMIT 1];
            // test 
                    
            ApexPages.StandardController sc= new ApexPages.StandardController(TestOrd);
            OrderVFPDetailExtender oi = new OrderVFPDetailExtender(sc);
            oi.delId= TestOrd.Id;
            oi.deleteRecord();
            OrderItem rcOrder =[SELECT Id, IsDeleted FROM OrderItem WHERE Id=:TestOrd.Id All ROWS];
            System.assertEquals(rcOrder.IsDeleted, true);
                    
        }
        @isTest
        public static void testsaveList(){
        // Set test page
        Order ordItem = [SELECT Id FROM Order LIMIT 1];
        Pagereference pageref = Page.OrderItemVFPMain;
        pageref.getParameters().put('id',ordItem.Id);
        Test.setCurrentPage(pageref);
        // instantiate controler
       
        ApexPages.StandardController sc= new ApexPages.StandardController(ordItem);
        OrderVFPDetailExtender ctr = new OrderVFPDetailExtender(sc);
        // test page display
        ctr.saveList();
        System.assert(ApexPages.getMessages().size()< 1);
        }  

        @isTest
        public static void testmakeAddProduct(){
        // Set test page
        Order ordItem = [SELECT Id FROM Order LIMIT 1];
        Pagereference pageref = Page.OrderItemVFPMain;
        pageref.getParameters().put('id',ordItem.Id);
        Test.setCurrentPage(pageref);
        // instantiate controler
       
        ApexPages.StandardController sc= new ApexPages.StandardController(ordItem);
        OrderVFPDetailExtender ctr = new OrderVFPDetailExtender(sc);
        // test page display
        ctr.makeAddProduct();
        List<OrderItem> testres =[SELECT Id FROM OrderItem];
        Integer listSize = testres.size();

        System.assertEquals(listSize, 1);
        } 
        @isTest
        public static void testeditOrderItem(){
        // Set test page
        Order ordItem = [SELECT Id FROM Order LIMIT 1];
        Pagereference pageref = Page.OrderVFPDetail;
        pageref.getParameters().put('id',ordItem.Id);
        Test.setCurrentPage(pageref);
        // instantiate controler
        OrderItem testitem =[SELECT Id,OrderId FROM OrderItem];
        ApexPages.StandardController sc =new ApexPages.StandardController(ordItem);
        OrderVFPDetailExtender ctr = new OrderVFPDetailExtender(sc);
        ctr.delId= ordItem.Id;
        // test page display
        String nextPage = ctr.editOrderItem().getUrl();
        Pagereference pageref2 = Page.orderitemvfpmain;
        pageref2.getParameters().put('id',testitem.OrderId);
        String URLtest = pageref2.getUrl();
        System.assertEquals(URLTest, nextPage);
        } 
        @isTest
        public static void testaddOrderItem(){
        // Set test page
        Order ordItem = [SELECT Id,Pricebook2Id FROM Order LIMIT 1];
        Pagereference pageref = Page.OrderItemVFPMain;
        pageref.getParameters().put('id',ordItem.Id);
        Test.setCurrentPage(pageref);
        // instantiate controler
        Product2 p2 = [SELECT Id FROM Product2 LIMIT 1];
        OrderItem ordItem2 = new OrderItem(OrderId = ordItem.Id,Quantity=1,Product2Id=p2.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(ordItem);
        OrderVFPDetailExtender ctr = new OrderVFPDetailExtender(sc);
        ctr.ordItem= ordItem2;
        // test page display
        ctr.addOrderItem();
        List<OrderItem> testres =[SELECT Id FROM OrderItem];
        Integer listSize = testres.size();

        System.assertEquals(listSize, 2);
        }     
}    
