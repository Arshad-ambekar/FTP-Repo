public class insertAccountsbyBatch2 implements Database.Batchable<SObject>, Database.stateful {
    private list<Map<String,Object>> inputdata;
    private list<account> accountToInsert;
   //constructor to initialize the input 
    public insertAccountsbyBatch2(list<Map<string,object>> data) {
        this.inputdata=data;
    }
    //Start method - prepare the account records
    public Iterable<SObject> start (Database.BatchableContext bc){
        accountToInsert=new List<Account>();
        for(Map<String,Object> row: inputdata){
            Account account=new Account();
            account.Name=string.valueof(row.get('Name'));
            account.Phone=string.valueof(row.get('Phone'));
            account.Description=string.valueof(row.get('Description'));
            accountToInsert.add(account);
        }
        return accountToInsert; //return iterable list of account records
    }
    //execute method
    public void execute(Database.BatchableContext bc, List<Account> scope){
        list<account> batchaccounts= (List<Account>) scope;
        if(!batchaccounts.isEmpty()){
            insert batchaccounts;
        }
    }
    //finish method
    public void finish(Database.BatchableContext bc){
        System.debug('batch process completed :'+accountToInsert.size()+'accounts processed.');
    }
}