/*
Test class to test the Order Visualforce page main (home) page


*/
@isTest
public class TestOrderVFPMain {
@TestSetup
public static void makeData(){
    Account acc = new Account(Name='testacc');
    insert acc;
    Contract cont = new Contract(AccountId=acc.Id, Status='Draft', ContractTerm=21,StartDate=Date.today());
    insert cont;
    
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
    public static void testcreateRecord(){
    // Set test page
    Pagereference pageref = Page.OrderVFPmain;
    Test.setCurrentPage(pageref);
    // instantiate controler
    ApexPages.StandardSetController ssc;
    OrderVFPMainExtend ctr = new OrderVFPMainExtend(ssc);
    // test page display
    String nextPage = ctr.createRecord().getUrl();
    System.assertEquals('/apex/ordervfpdetail', nextPage);
    }

    @isTest
    public static void testeditRecord(){
        // Set test page
        Pagereference pageref = Page.OrderVFPmain;
        Test.setCurrentPage(pageref);
        // instantiate controler
        ApexPages.StandardSetController ssc;
        OrderVFPmainExtend ctr = new OrderVFPmainExtend(ssc);
        // test page display
        String nextPage = ctr.editRecord().getUrl();
        System.assertEquals('/apex/ordervfpdetail', nextPage);
        }
    @isTest      
    public static void testdeleteRecord(){
                // Set test page
                PageReference pageref = Page.OrderVFPmain;
                Test.setCurrentPage(pageref);
                Order TestOrd = [SELECT Id FROM Order WHERE Status ='Draft' LIMIT 1];
                // test 
                
                ApexPages.StandardSetController ssc;
                OrderVFPmainExtend om = new OrderVFPmainExtend(ssc);
                om.ordId= TestOrd.Id;
                om.deleteRecord();
                Order rcOrder =[SELECT Id, IsDeleted FROM Order WHERE Id=:TestOrd.Id All ROWS];
                System.assertEquals(rcOrder.IsDeleted, true);
                
                }

    @isTest                      
    public static void testNEGdeleteRecord(){
        // Set test page
        PageReference pageref = Page.OrderVFPmain;
        Test.setCurrentPage(pageref);

        Order TestOrd = [SELECT Id FROM Order LIMIT 1];
        Contract con = [SELECT Id FROM Contract LIMIT 1];
        con.Status='Activated';
        update con;
        TestOrd.Status='Activated';
        update TestOrd;
        // test              
        ApexPages.StandardSetController ssc;
        OrderVFPmainExtend om = new OrderVFPmainExtend(ssc);
        om.ordId= TestOrd.Id;
        om.deleteRecord();
        
        System.assert(ApexPages.getMessages().size()> 0);
                            
         }

}