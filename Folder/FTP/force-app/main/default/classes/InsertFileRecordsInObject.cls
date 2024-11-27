public with sharing class InsertFileRecordsInObject {
    //IN HIC APEX CLASS NAME FileUploader 
    // public InsertFileRecordsInObject() 
    // }
    @AuraEnabled
    Public static string InsertAccounts(list<Map<string, object>> data){

        System.debug('Accounts Data '+data);
        list<Account> accounts = new list<Account>();
        for(Map<string, Object> row: data){
            Account account=new account();
            //CREATION OF CSV FILE AND UPLOADINT TO THE FTP SERVER IS PENDING WITH BELOW FEILDS & HAVE TO CHECK CAN WE USE BATCH APEX LATER FIRST TRY SIMPEL APEX
            account.Name= String.valueOf(row.get('Name'));
            account.Phone=String.valueOf(row.get('Phone'));
            account.Description=string.valueOf(row.get('Description'));
            // account.Site=String.valueOf(row.get('Site'));
            // account.Type=String.valueOf(row.get('Type'));
            // System.debug('Account Name '+account.Name);
            // account.Site=String.valueOf(row.get('Site'));
            // account.Type=String.valueOf(row.get('Type'));
            accounts.add(account);
        }
        if(!accounts.isEmpty()){
            insert accounts;
        }
        string successmsg='DML Successfull';
        System.debug(successmsg);
        return successmsg;

    }
}