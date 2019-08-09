@isTest
public class TestOrg {
    
    
    @testSetup
    static void setup(){
        /**
        List<Expenses__c> testExpenses = new List<Expenses__c>();
        List<Budget__c> testBudget = new List<Budget__c>();
        List<Income__c> testIncome = new List<Income__c>();
        List<Bank_Account__c> testBank = new List<Bank_Account__c>();
        
        testBank.add(new Bank_Account__c(Name='Checkings', Balance__c=20000 ) );
        testBank.add(new Bank_Account__c(Name='Savings', Balance__c=50000));
        insert testBank;
        
        List<Id> testBankId = new List<Id>();
        for(Bank_Account__c i : [SELECT Id FROM Bank_Account__c]){
            testBankId.add(i.Id);
        }
        
        Decimal money = -20;
        Date theDate = Date.today();
        
        for(Integer i = 0; i < 100; i++){
            
            testExpenses.add(new Expenses__c(Expense__c=money, Expense_Date__c=theDate, Bank_Account__c=testBankId.get(Math.mod(i, 2))));
            
            money += 5;
        }
        
        for (Integer i = 0; i < 10; i++){
            testIncome.add(new Income__c(Income__c=money, Income_category__c='Cash', Income_Date__c=theDate, Bank_Account__c=testBankId.get(Math.mod(i, 2))));
            money +=1000;
        }
        
        insert testExpenses;
        insert testIncome;
        
    }
    **/
    
    
    }
    @isTest
    static void testMakeValidExpense(){
        for(Expenses__c e : [SELECT Id, Expense__c FROM Expenses__c]){
            ExpenseHandler.makeValidExpense(e);
        }
        
        for(Expenses__c e : [SELECT Id, Expense__c FROM Expenses__c]){
            System.assertEquals(e.Expense__c >= 0, e.Expense__c >= 0, 'Expense should be greated than 0');
        }
    }
    
    @isTest
    static void testUpdateBalance(){
        
        for(Expenses__c e : [SELECT Id, Expense__c, Bank_Account__c FROM Expenses__c]){
            ExpenseHandler.updateBalance(e);
        }
        
        for(Expenses__c e : [SELECT Id, Expense__c, Bank_Account__c FROM Expenses__c]){
            System.assertEquals(e.Bank_Account__c, e.Bank_Account__c, 'Bank Accounts not equal');
        }
    }
    
    @isTest
    static void testUpdateBalanceTwo(){
        
        for(Expenses__c e : [SELECT Id, Expense__c, Bank_Account__c FROM Expenses__c]){
            ExpenseHandler.updateBalance(e);
        }
        
        for(Expenses__c e : [SELECT Id, Expense__c, Bank_Account__c FROM Expenses__c]){
            System.assertEquals(e.Bank_Account__c, e.Bank_Account__c, 'Bank Accounts not equal');
        }
    }
    
    @isTest
    static void testExpense(){
        Bank_Account__c b = new Bank_Account__c(Name='Checkings', Balance__c=1000); 
        Budget__c budget = new Budget__c(Name='Test Budget', Budgeted_Amount__c=100, Start_Date__c=Date.newInstance(2019, 8, 1), End_Date__c=Date.newInstance(2019, 8, 1));
        insert b;
        insert budget;
        Expenses__c e = new Expenses__c(Expense__c=90, Expense_Date__c=Date.today(), Bank_Account__c=b.id, Budget__c=budget.id);
        insert e;
        
        b = [SELECT Name, Balance__c FROM Bank_Account__c WHERE Name='Checkings' LIMIT 1];
        System.assertEquals(910, b.Balance__c, 'Does not equal each other');
        
        e.Expense__c = 80;
        update e;
        
        System.assertEquals(910, b.Balance__c, 'Does not equal each other');
        
        delete e;
    }
    
    @isTest
    static void testIncome(){
        Bank_Account__c b = new Bank_Account__c(Name='Checkings', Balance__c=1000);
        insert b;
        
        Income__c i = new Income__c(Income__c=1000, Income_Category__c='Cash', Income_Date__c=Date.today(), Bank_Account__c=b.id);
        insert i;
        
        i.Income__c = 1100;
        update i;
    }
    
    
}