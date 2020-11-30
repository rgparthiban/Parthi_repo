({
    
	readCSV: function (cmp, event) {  
     
      var filename = event.getSource().get("v.files");   
          var toastEvent = $A.get("e.force:showToast");
        var str = $A.get("$Label.c.test_message");
         toastEvent.setParams({                                      
                                       //message: string.format($A.get("$Label.c.test_message",filename)),  
             message: str.replace("{0}",'welcome home'),               
                                       type: 'success',
                                   });
         toastEvent.fire();
        var textdata;
        var reader = new FileReader();
       cmp.set("v.spinner","true")
        var infolst = [];
        reader.onload = function() { 
           
            var text = reader.result; /*Get the data stored in file*/
            console.log(reader.result.substring(0, 200));
            console.log('Data from CSV file' + text);
            textdata = text;
            var rows = textdata.split('\n'); /*Spilt based on new line to get each row*/
            console.log('File header' + rows[0]);
           // component.set("v.showSpinner", false);
 
            /* Ignore the first row (header)  and start from second*/
            for (var i = 1; i<rows.length; i = i + 1) {                
                console.log('Length', +rows.length); //total number of rows in the file including header
                /*Spilt based on the comma*/
                var cells = rows[i].split(';');
                console.log('One row' + cells);
                console.log('Row length' + cells.length); 
                      alert("cell value"+cells[0]);     
                var cellinfo = {
                    'Stuedentid': cells[0],
                    'Name': cells[1],
                    'address': cells[2]                   
                };
 
                infolst.push(cellinfo);                   
                cmp.set("v.csvResult",infolst);
                
                
            }
             cmp.set("v.spinner","false")
 
        };
       if (filename[0] !== undefined && filename[0] !== null && filename[0] !== '') {
            reader.readAsText(filename[0]);           
        }
        
    },
    onSave : function (component, event, helper) {
        var editedRecords =  component.find("accountDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        console.log("editedRecords::"+editedRecords);
         var action = component.get("c.updateAccounts");
        action.setParams({
            'editedAccountList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === true){                    
                    $A.enqueueAction(component.get('c.reloadDataTable'));
                    
                } else{ //if update got failed
                    /*helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": "Error in update"
                    });*/
                }
            }
        });
        $A.enqueueAction(action);
    },
    reloadDataTable : function(){
    var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    }        
        
        // This will contain the List of File uploaded data and status        
        
       /* var reader = new FileReader();
        cmp.set("v.csvFileBody",uploadedFiles[0]);
        
        var csvfilebody = cmp.get("v.csvFileBody");              
        console.log(reader.readAsText(cmp.get("v.csvFileBody")));
        
        cmp.set("v.csvstring",csvfilebody.toString()); 	
        alert(cmp.get("v.csvstring"));
        var csvstring = [];
        csvstring =cmp.get("v.csvstring").split('\n');
        
        alert("string"+csvstring);
        cmp.set("v.csvFileLines",csvstring);    
        var csvFileLines = [];
        csvFileLines = cmp.get("v.csvFileLines");
		alert("sizel"+csvFileLines.length);
         var csvRecordData = [];
         for(var i=0; i<csvFileLines.length; i++){                            
             csvRecordData = csvFileLines[i].split(',');             
               alert("stuedentxzzzz"+csvRecordData[0]['Stuedentid']); 
               alert(csvRecordData[1]);
               alert(csvRecordData[2]);
           }
        */
       //alert("Files uploaded : " + uploadedFiles.length);
        /* if (uploadedFiles.length >0)
         {
             $A.get('e.lightning:openFiles').fire({
            recordIds: [documentid]
        });*/
 
            
})