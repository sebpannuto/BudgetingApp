public class IncomeHandler {
    public static void checkValidIncome(List<Income__c> incomeList){
        for(Income__c i : incomeList){
            if(i.income__c < 0){
                i.addError('Please insert a positive value');
            }
        }
    }
    
    public static void updateBalance(Income__c updateIncome){
        Bank_Account__c myBankAccount = [SELECT Name, Id, Balance__c FROM Bank_Account__c WHERE Id = :updateIncome.Bank_Account__c];
        myBankAccount.Balance__c += updateIncome.Income__c; 
        update myBankAccount;
    }
    
    public static void updateBalance(Income__c newIncome, Income__c oldIncome){
        Bank_Account__c myBankAccount = [SELECT Name, Id, Balance__c FROM Bank_Account__c WHERE Id = :newIncome.Bank_Account__c];
        if(newIncome.Bank_Account__c == oldIncome.Bank_Account__c){
            if(newIncome.Income__c != oldIncome.Income__c){
                myBankAccount.Balance__c -= oldIncome.Income__c;
                myBankAccount.Balance__c += newIncome.Income__c;
            }
        }
        else{
            myBankAccount.Balance__c += newIncome.Income__c;
			incomeDelete(oldIncome);
        }
        update myBankAccount;
    }
    
    public static void incomeDelete(Income__c oldIncome){
        Bank_Account__c oldBankAccount = [SELECT Name, Id, Balance__c FROM Bank_Account__c WHERE Id = :oldIncome.Bank_Account__c];
        oldBankAccount.Balance__c -=oldIncome.Income__c;
        update oldBankAccount;
    }
}