public class BudgetHandler {
    public static void setBudgetedAmount(Budget__c amountLeft){
        amountLeft.Amount_Left_on_Budget__c = amountLeft.Budgeted_Amount__c;
        insert amountLeft;
    }
    
    //gets budget record type name
    //Schema.getGlobalDescribe().get('Budget__c').getDescribe().getRecordTypeInfosById().get('0123i0000004yt4AAA').getName()
}