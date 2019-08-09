trigger BudgetTrigger on Budget__c (before insert, after insert) {
    if(Trigger.isBefore){
        //BudgetHandler.setBudgetedAmount(Trigger.new[0]);
    }
    else{
        if(Trigger.isInsert){
            //BudgetHandler.setBudgetedAmount(Trigger.new[0]);
        }
    }
}