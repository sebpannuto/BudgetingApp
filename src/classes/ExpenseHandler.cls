public class ExpenseHandler {
    
/******************************************************************************************
* Used on: before insert
* Function: Checks to make sure that expenses being entered are positive values
* 
******************************************************************************************/
    
    public static void makeValidExpense(Expenses__c expense){
        if(expense.Expense__c < 0){
            expense.Expense__c = math.abs(expense.Expense__c);
            update expense;
        }
    }
    
/******************************************************************************************
* Used on: after insert
* Function: Updates the balance on an insert
* 
******************************************************************************************/
    
    public static void updateBalance(Expenses__c updateExpenses){
        Bank_Account__c myBankAccount = [SELECT Name, Id, Balance__c FROM Bank_Account__c WHERE Id = :updateExpenses.Bank_Account__c];
        myBankAccount.Balance__c -= updateExpenses.Expense__c; 
        update myBankAccount;
    }
    
/******************************************************************************************************************
* Used on: after update
* Function: Updates the balance during an Update trigger
* This is to update fields that would display incorrect data due to leaving the previous value in the equation
* 
******************************************************************************************************************/
    
    public static void updateBalance(Expenses__c newExpenses, Expenses__c oldExpenses){
        Bank_Account__c myBankAccount = [SELECT Name, Id, Balance__c FROM Bank_Account__c WHERE Id = :newExpenses.Bank_Account__c];
        if(newExpenses.Bank_Account__c == oldExpenses.Bank_Account__c){
            if(newExpenses.Expense__c != oldExpenses.Expense__c){
                myBankAccount.Balance__c += oldExpenses.Expense__c;
                myBankAccount.Balance__c -= newExpenses.Expense__c;
            }
        }
        else{
            myBankAccount.Balance__c -= newExpenses.Expense__c;
            expensesDelete(oldExpenses);
        }
        update myBankAccount;
    }
/***********************************************************************************************************************
* Used on: after delete
* Function: Deletes the expense from the expense object
* Sets the amount left on the budget when the expense is deleted
* 
**********************************************************************************************************************/
    
    
    public static void expensesDelete(Expenses__c oldExpenses){
        Bank_Account__c oldBankAccount = [SELECT Name, Id, Balance__c FROM Bank_Account__c WHERE Id = :oldExpenses.Bank_Account__c];
        oldBankAccount.Balance__c +=oldExpenses.Expense__c;
        update oldBankAccount;
        
        
        if(oldExpenses.Budget__c != NULL){
            Budget__c budget = [SELECT Name, Budgeted_Amount__c, Amount_Left_on_Budget__c FROM Budget__c WHERE Id = :oldExpenses.Budget__c];
            budget.Amount_Left_on_Budget__c += oldExpenses.Expense__c;
            update budget;
        }
        
    }
    
/******************************************************************************************************************
* Used on: after insert, after update
* Function: updates the Amount_Left_on_Budget__c after an expense is updated or inserted.
*  
******************************************************************************************************************/
    public static void updateAmountLeftOnBudget(Expenses__c expense){
        //Add function to select the budgeted amount on the date
        if(expense.Budget__c != NULL){
            Budget__c budget = [SELECT Name, Budgeted_Amount__c, Amount_Left_on_Budget__c FROM Budget__c WHERE Id = :expense.Budget__c];
            budget.Amount_Left_on_Budget__c -= expense.Expense__c;
            update budget;
        }
    }
    
/******************************************************************************************************************
* Used on: before insert, before update
* Function: If a budget was specified for the expense it checks to see if the expense date falls within the 
* 			budget range
*  
******************************************************************************************************************/
    public static void validateDate(Expenses__c expense){
        System.debug('Entering validation');
        if(expense.Budget__c != NULL){
            Budget__c budget = [SELECT Name, Start_Date__c, End_Date__c FROM Budget__c WHERE Id = :expense.Budget__c];
            
            System.debug('Checking month');
            if(budget.Start_Date__c.month() == expense.Expense_Date__c.month() && budget.End_Date__c.month() == expense.Expense_Date__c.month()){
                System.debug('Checking year');
                if(budget.Start_Date__c.year() == expense.Expense_Date__c.year() && budget.End_Date__c.year() == expense.Expense_Date__c.year()){
                    System.debug('It worked');
                }
                else{
                    expense.addError('Expense date is not between budget limit');
                }
            }
            else{
                expense.addError('Expense date is not between budget limit');
            }
        }
        System.debug('It ended');
    }
/******************************************************************************************************************
* Used on: before insert, before update
* Function: Checks to see if the expense being added will put you over budget
*  
******************************************************************************************************************/
    
    public static void checkBudget(Expenses__c expense){
        if (expense.Budget__c != NULL){
            Budget__c budget = [SELECT Name, Budgeted_Amount__c, Amount_Left_on_Budget__c FROM Budget__c WHERE Id = :expense.Budget__c];
            budget.Amount_Left_on_Budget__c -= expense.Expense__c;
            if (budget.Amount_Left_on_Budget__c < 0){
                //expense.addError('Cannot add to budget because you are over budget! ' + budget.Amount_Left_on_Budget__c);
            }
        }
    }
/******************************************************************************************************************
* Used on: before insert, before update
* Function: Checks to see if the expense being added will put you in the negative in your bank account
*  
******************************************************************************************************************/    
    public static void checkBankAccount(Expenses__c expense){
        
        Bank_Account__c bank = [SELECT Name, Balance__c FROM Bank_Account__c WHERE Id = :expense.Bank_Account__c];
        bank.Balance__c -= expense.Expense__c;
        if (bank.Balance__c < 0){
            expense.addError('Cannot add to bank account because it\'ll make you broke!');
        }
        
    }
    
}