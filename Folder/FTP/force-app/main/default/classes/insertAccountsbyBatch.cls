public  class insertAccountsbyBatch implements Database.Batchable<SObject>,Database.stateful {
    private List<Map<String,Object>> data;
    
    //CONSTURCTOR FOR TAKING THE INPUT DATA FROM THE TRIGGERING CLASS - OF ACCOUNTS RECORDS
    public insertAccountsbyBatch(List<Map<String,Object>> csvData) {
        this.data=csvData;
    }

    //start - no query here so will take iterable method direclty - so make syntax working
    public Iterable<SObject> start(Database.BatchableContext bc){
        //prepare data for batch processing by creating dumy Sobject list (can be empty)
       list<Account> accountsToProcess=new list<account>(); //create list of accont
       //Convert input data (csvData) inot Account object
       for(Map<String,Object> row: data){
        account account=new account();
        account.Name=string.valueOf(row.get('Name'));
        account.Phone=string.valueOf(row.get('Phone'));
        account.Description=string.valueOf(row.get('Description'));
        accountsToProcess.add(account);//add the accoun to the list
       }
        return accountsToProcess; //return iteratble list of dummy records
    }
    //execute
    public void execute(Database.BatchableContext bc, List<SObject> scope){
        list<account> accountsToInsert= new list<account>();

        for(SObject sObj: scope){
            account account= (account) sObj; //cast to acccount
            for(Map<String,Object> row: data){
                //account account=new account();
                account.name=String.valueOf(row.get('Name'));
                account.phone=String.valueOf(row.get('Phone'));
                account.Description=string.valueOf(row.get('Description'));
                // account.Site=String.valueOf(row.get('Site'));
                accountsToInsert.add(account);
            }
        }
        
        if(!accountsToInsert.isEmpty()){
            insert accountsToInsert;
        }
    }

    //finish method
    public void finish(Database.BatchableContext bc){
        //log completion or notify user/admin
        System.debug('Batch Process Complete');
    }
}