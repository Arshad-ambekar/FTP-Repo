public class CalloutToFTPServer {
    //HIC tututorial has apex class name = loadFromFTP
    // public CalloutToFTPServer() {
    // }
    @AuraEnabled
    public static string getCSV(string csvName){
        //setting up the callout things
        string filepath='/htdocs/Salesforce Object CSV Files'; //remote folder path
        string endpoint='https://www.ftp-api.com/ftp/download?fileName='+ filepath +'/'+ csvName +'.csv';
        string username='if0_37723262';
        string password='9RCriaZTGc1hSt';
        string ftpHost='ftpupload.net';
        Integer ftpPort=21;
        string ftpType='FTP'; 

        //set up the request and get response
        HttpRequest request=new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('username', username);
        request.setHeader('password', password);
        request.setHeader('ftp-host', ftpHost);
        request.setHeader('port', string.valueOf(ftpPort));
        request.setHeader('ftp-type', ftpType);
        // request.setHeader('path', '/'); //already included in the above url and path
        request.setTimeOut(30000);

        Http http=new Http();
        HttpResponse response=http.send(request);

        if(response.getStatusCode()==200){
            //get the file content
            string filecontent=response.getBody();
            //get the file name
            string filename='sample.txt';
            //log the file name and content
            System.debug('File Name: ' +filecontent);
            System.debug('File Content:'+filecontent);
        }
        else{
            //Handling error is pending
            System.debug('Error downloading fiel. Status code: ' +response.getStatusCode());
        }

        //GET THE FILE CONTENT IN THE OBJECT FORMATE
        string filecontent=response.getBody();
        System.debug('Content  responsbody ->'+filecontent);
        Map<String,Object> responseMap= (Map<String,Object>)JSON.deserializeUntyped(filecontent);
        System.debug('fileContentMap: '+responseMap);
        list<object> filelist= (list<Object>) responseMap.get('Files');
        string csvContentBase64= (string) ((Map<string, object>) filelist[0]).get('body');
        //converting to the blob
        Blob csvBlob = EncodingUtil.base64Decode(csvContentBase64);

        string csvData= csvBlob.toString();
        System.debug('csvData: '+csvData);
        
        //Changing return type message is pending
        return csvData;
    }

}