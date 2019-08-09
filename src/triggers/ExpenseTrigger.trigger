trigger ExpenseTrigger on Expenses__c (before insert, before update, after insert, after update, after delete) {
	if(Trigger.isBefore){
        if(Trigger.isInsert){
            ExpenseHandler.makeValidExpense(Trigger.new[0]);
            ExpenseHandler.validateDate(Trigger.new[0]);
            ExpenseHandler.checkBudget(Trigger.new[0]);
            ExpenseHandler.checkBankAccount(Trigger.new[0]);
        }
        else if(Trigger.isUpdate){
            ExpenseHandler.makeValidExpense(Trigger.new[0]);
            ExpenseHandler.validateDate(Trigger.new[0]);
            //ExpenseHandler.checkBudget(Trigger.new[0]);
            ExpenseHandler.checkBankAccount(Trigger.new[0]);
        }
    }
    else{
        if(Trigger.isInsert){
            ExpenseHandler.updateBalance(Trigger.new[0]);
            ExpenseHandler.updateAmountLeftOnBudget(Trigger.new[0]);
        }
        else if(Trigger.isUpdate){
            
            ExpenseHandler.updateBalance(Trigger.new[0], Trigger.old[0]);
            //Must go after updateBalance on update because it will screw up the AmountLeft
            ExpenseHandler.updateAmountLeftOnBudget(Trigger.new[0]);
        }
        else if(Trigger.isDelete){
            ExpenseHandler.expensesDelete(Trigger.old[0]);
        }
    }
}