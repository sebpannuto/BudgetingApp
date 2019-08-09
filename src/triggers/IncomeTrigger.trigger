trigger IncomeTrigger on Income__c (before insert, before update, after insert, after update, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            IncomeHandler.checkValidIncome(Trigger.new);
        }
        else if(Trigger.isUpdate){
            IncomeHandler.checkValidIncome(Trigger.new);
        }
    }
    else{
        if(Trigger.isInsert){
            IncomeHandler.updateBalance(Trigger.new[0]);
        }
        else if(Trigger.isUpdate){
            IncomeHandler.updateBalance(Trigger.new[0], Trigger.old[0]);
        }
        else if(Trigger.isDelete){
            IncomeHandler.incomeDelete(Trigger.old[0]);
        }
    }
}