public with sharing class InsertAccountRecordsBatchTriggerCls {
    // public InsertAccountRecordsBatchTriggerCls() {

    // }
    @AuraEnabled
    public static string insertAccountBatchzTriggermthd(list<Map<string, object>> data){
       if(data == null || data.isEmpty()){
        return 'No Data provided for the batch processing';

       } 
       //CREATION OF THE BATCH APEX CLASS IS PENDING
       //Database.executeBatch(new insertAccountsbyBatch(data), 10); //later ucomment it
       Database.executeBatch(new insertAccountsbyBatch2(data), 2);
       return 'Batch processing started for account insertion/ Or Check Record Created or not';
       
    }
}

//chages in the js file method wich trigger the triggerapexclassforbatch is pending
//making batch of 10 so that total 5 batch will run each will 10 records toatl 50 account will be inserted
//upload to ftp server pending