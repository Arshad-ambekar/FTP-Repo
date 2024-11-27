import { LightningElement, track,api,wire } from 'lwc';
//importing of apex class method is pending
import getCSV from '@salesforce/apex/CalloutToFTPServer.getCSV';
import insertAccount from '@salesforce/apex/InsertFileRecordsInObject.InsertAccounts';
//calling batchapex method/class
import insertAccountBatchzTriggermthd from '@salesforce/apex/InsertAccountRecordsBatchTriggerCls.insertAccountBatchzTriggermthd';

export default class FtpComponent extends LightningElement {
    csvFileName='No CSV file uploaded';
    @track data=[];
    @track columns=[];
    @track isTableVisible=false;
    message;
    errorFromFTP;//Error in handleFTPUpload (returning Error object)
    errorNoFileName;//no file name entered
    csvData; //don whats the use of this variable will see later



    /////////WORKING ON JS FILE Done



    //upload csv file from local storage adn insert data into the salesforce account object
    handleFileUpload(event){
        const files=event.detail.files;
        if(files.length>0){
            const file=files[0];
            this.csvFileName=file.name;
            //sending this selected file name to readcsvfile method/function
            this.readCSVFile(file);
        }
    }

    //Search the file name on FTP server and then insert the records into the salsesforce object
    handleButtonClick(event){
        try{
            const inputElement= this.template.querySelector('[data-id="File-input"]');
            this.csvFileName=inputElement.value;
            console.log('File name Entered:',this.csvFileName);
            if(!this.csvFileName){
                throw new Error('No file name entered')
            }
            //if filename found then share it handleFTPupload funciton
            alert('CSV file name ->'+this.csvFileName);
            this.handlFTPupload(this.csvFileName);
        }catch(error){
            console.error(error);
            this.errorNoFileName=error;
        }
    }

    //after searching name on input fild - if data yes - then insert into the object by confirming the this button
    handleUpload(event){
        alert('This.data =>'+this.data);
        //insertAccount({data:this.data}) //letter revoke this after testing
        insertAccountBatchzTriggermthd({data:this.data})
        .then((result) =>{
            this.message=result;
            console.log('Success Message; ',this.message);
            this.errorFromFTP=undefined;
        })
        .catch((error)=>{
            this.errorFromFTP=error;
            //alert('EFF: error'+this.errorFromFTP);
            this.message=undefined;
        })
        .finally(()=>{
            setTimeout(() => {
                this.isTableVisible=false;
            }, 2000);
        });
    }

    //DEFING AN ASYCHORNUS FUNCTION 'HANDLEFTPUPLOAD'WHICH TAKES FILE NAME AS INPUT PARAMETER
    async handlFTPupload(fileName){ // this funciton input from handlebuttonclikc method with file name
        try{
            console.log('Calling the getCSV apex method with file name: ', fileName);
            alert('Recived csv filename =>'+fileName);
            this.csvData=await getCSV({csvName:fileName});
            console.log('CSV Data Recieved: ',this.csvData);
            //after receving data sending to parseSCV method to get data in required form
            alert('csv Data =->'+this.csvData);
            this.parseCSV(this.csvData);
        }catch(error){
            console.error('Error in handleETPUpload: ',error);
            this.errorFromFTP=error;
            alert('EFTP ->'+JSON.stringify(this.errorFromFTP));
        }
    }

    //Method for reading csvfile - input coming from handlefileupload method - when you select csv file
    //reading loading file
    async readCSVFile(file){
        try{
            const result = await this.loadFile(file); //creat loadfile first
            this.parseCSV(result);// 2nd create parsecsv method
            console.log(result);

        }catch(e){
            console.error(e);
            this.dispatchEvent(
                new CustomEvent('uploaderror',{detail:e})
            );
        }
    }

    //loading file - taking input from readCSvfile form above
    async loadFile(file){
        return new Promise((resolve,reject)=>{
            const reader=new FileReader();
            reader.onload=()=>{
                resolve(reader.result)
            };
            reader.onerror=()=>{
                reject(reader.error);
            };
            reader.readAsText(file); //check we have to create any readasText method or not
        });
    }

    //creatd parseCSV methof - which take input from readcsv file
    parseCSV(csv){
        const lines = csv.split(/\r\n|\n/);
        const headers=lines[0].split(',');
        this.columns=headers.map((header)=>{
            return {label:header,fieldName:header};
        });

        const data =[];
        for(let i=1; i<lines.length;i++){
            const line=lines[i];
            if(!line){
                //skip empty lines
                continue;
            }
            const ojb ={};
            const currentline=line.split(',');
            for(let j=0; j<headers.length;j++){
                ojb[headers[j]]=currentline[j];
            }
            data.push(ojb);
        }
        if(data.length===0){
            throw new Error('No data found in CSV file');
        }

        //Now addint the data in datatable table - data object
        this.data=data;
        console.log('Data: ', JSON.stringify(this.data));
        //adding conditional rendering to the data table
        if(this.data.length){
            this.isTableVisible=true;
            } 
        }

        //Insert the data to the salesforce object - go above method 3rd
        //handleUpload


    


}