import { LightningElement, track, api,wire } from 'lwc';
import getWorkers from "@salesforce/apex/PreferredWorkersController.getWorkers";
import getActiveWorkers from "@salesforce/apex/PreferredWorkersController.getActiveWorkers";
import deletePreferredWorker from "@salesforce/apex/PreferredWorkersController.deletePreferredWorker";
import moveRecentWorkerRecord from "@salesforce/apex/PreferredWorkersController.moveRecentWorkerRecord";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import TIME_ZONE from "@salesforce/i18n/timeZone";
import LOCALE from "@salesforce/i18n/locale";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';


export default class PortalV2MyPreferredDatatable extends LightningElement{
    
    textFilterIcon = SITE_ASSETS + "/img/icons/filter-dk-grey.svg";
    dateFilterIcon = SITE_ASSETS + "/img/icons/calendar-dk-grey.svg";
    openTextFilterModal = false;
    openDateFilterModal = false;
    filterColumnLabel = "";
    filterClickType = "";
    filterType = "";
    defaultSelectedDate = undefined;
    selectedDatesMap = new Map();
    //defaultSelectedValues = undefined;//jyothi
    selectedValuesMap = new Map();
    timeZone = TIME_ZONE;
    loading = true;
	@api siteId;
    @api isPreferredWorker;
    @track isShowModal = false;
    filterTerms = [];
    preferredData = [];
    preferredDataBackUp = [];
    defaultSelectedValues2 = undefined;//jyothi qf;
    primaryAnchorCaret = SITE_ASSETS + "/img/icons/primary-anchor-caret.svg";
    primaryAnchorCaretOpen =  SITE_ASSETS + "/img/icons/primary-anchor-caret-down.svg";
    selectedRecordId;
	

    connectedCallback() {		
        if(this.isPreferredWorker == true){this.getPreferredWorkers();}
        else {this.getActiveWorkers();}
        
    }

    getPreferredWorkers() {
        this.filterTerms = []; 
        try {
            this.loading = true;  
            console.log('##this.siteId:before call:'+this.siteId);
                getWorkers({siteId:(this.siteId+'')}) .then(result => {
                    console.log('###result::'+JSON.stringify(this.result));
                    this.preferredDataBackUp = result;
                    this.preferredData = result;  
                    this.preferredData.forEach((pData) => {
                        this.filterTerms.push(pData.workerName);
                    });  
                    if(this.preferredData.length == 0){
                        //this.showModalBox('No endorsement worker records to display'); //jyothi
                        this.showModalBox('No preferred workers to display'); //jyothi
                    }              
                }).catch(error => {
                    console.log('ERRor:'+JSON.stringify(error));
                });               
            this.loading = false;
        } catch (e) {
            console.error('##ERRor:'+JSON.stringify(e.message));
            this.loading = false;
        }
    }


    getActiveWorkers() {
        this.filterTerms = []; 
        try {
            this.loading = true;
            getActiveWorkers({siteId:(this.siteId+'')}) .then(result => {
                this.preferredDataBackUp = result;
                this.preferredData = result;
                this.preferredData.forEach((pData) => {
                    this.filterTerms.push(pData.workerName);
                }); 
                if(this.preferredData.length == 0){
                    //this.showModalBox('No New shift workers records to display'); //jyothi
                    this.showModalBox('No recent workers to display'); //jyothi
                }
            }).catch(error => {
                console.log(error);
            });        
            this.loading = false;
        } catch (e) {
            console.error('##ERRor:'+JSON.stringify(e.message));
            this.loading = false;
        }
    }

    toggleSubTableShow(event) {
        var preferredDataCopy = [...this.preferredData];
        let endosId = event.target.name;
   
        const record = preferredDataCopy.find((endos) => {
          return endos.workerId.includes(endosId);
        });
        record.isHidden = !record.isHidden;
        this.preferredData = preferredDataCopy;
    }

    showModalBox(msg) {  
        this.showMessageToUser("info", "dismissible", msg);
    }

    hideModalBox() {  
        this.isShowModal = false;
    }

    filterDisplayed(jobRecords, flag) {
        let filteredItems = jobRecords.filter(item => {
            if (item.selected == flag) {
                return true;
            } else{
                return false;
            }
        });
        return filteredItems;
    }

    deleteRecord(){ 
        console.log('delete');
        let isChanged = false;
        let preferredData = this.preferredData.filter(item => {
            if (item.jobRecords && item.jobRecords.length > 0) {
                
                item.jobRecords.forEach((pd) => {
                    if(!pd.selected)isChanged = true;
                });  

                item.jobRecords = this.filterDisplayed(item.jobRecords, false);
                return (item.jobRecords.length > 0) ? false : true;
            }            
            return false;
        });

        console.log('###isChanged:'+isChanged);
        
        //if(isChanged){
            //this.preferredData = preferredData;
            deletePreferredWorker({preferredData:JSON.stringify(this.preferredData)}) .then(result => {
                console.log('deleted successfully!');
                if(this.isPreferredWorker == true){this.getPreferredWorkers();}
                else {this.getActiveWorkers();}
            }).catch(error => {
                console.log(error);
            });  
        //}
    }

    moveRecentRecord(){ 
        console.log('move');
        let preferredData = this.preferredData.filter(item => {
            if (item.jobRecords && item.jobRecords.length > 0) {
                item.jobRecords = this.filterDisplayed(item.jobRecords, true);
                return (item.jobRecords.length > 0) ? true : false;
            }            
            return false;
        });

        //this.preferredData = preferredData;

        moveRecentWorkerRecord({preferredData:JSON.stringify(this.preferredData)}) .then(result => {
            console.log('moved successfully!');
            if(this.isPreferredWorker == true){this.getPreferredWorkers();}
            else {this.getActiveWorkers();}
        }).catch(error => {
            console.log('Errror:'+JSON.stringify(error));
        });  
    }
    

    handleEndorsedChange(event){

        
        const { id } = event.target.dataset;        
        var workerId = id.split('#')[0];         
        var jobTypeId = id.split('#')[1]; 
        

        
        console.log('###jobTypeId.startsWith:'+jobTypeId+':::'+jobTypeId.startsWith('a3S'));
        this.selectedRecordId = jobTypeId;
        //this.isShowModal = true;
        const parentR = this.preferredData.find(
        (shiftRecord) => shiftRecord.workerId === workerId
        );
        console.log('###parentR:'+JSON.stringify(parentR));
        const record = parentR.jobRecords.find(
        (shiftRecord) => shiftRecord.jobTypeId === id
        ); 
        console.log('###record:'+JSON.stringify(record));  
        record.selected = !record.selected; 

        console.log('###selected:'+record.selected);

        this.loading = true;  
        setTimeout(() => {
            this.loading = false;
        }, 1); 

        if(!jobTypeId.startsWith('a3S')){
            setTimeout(() => {
                this.deleteRecord();
            }, 5000);             
            
        }
        else if(jobTypeId.startsWith('a3S')){
            setTimeout(() => {
                this.moveRecentRecord();
            }, 5000);             
            
        }
    }

    handleFilterClick(event) {
        this.openTextFilterModal = false;
        this.openDateFilterModal = false;
    
        this.filterColumnLabel = event.target.title;
        this.filterClickType = event.target.name;
    
        let filterType = event.target.alt;
    
        if (filterType === "Date") { 
          this.openDateFilterModal = true;
        } else if (filterType === "Text") {
          this.openTextFilterModal = true;
        }
    }

    handleDateFilterModalClose() {
        this.openDateFilterModal = false;
    }
    
    handleResetFilter(event){

        if (this.openDateFilterModal) {
            this.defaultSelectedDate = undefined;//jyothi
            this.preferredData = this.preferredDataBackUp;
            this.openDateFilterModal = false;
        }
        if (this.openTextFilterModal) {
            this.defaultSelectedValues2 = undefined;//jyothi
            this.valuesToFilter = undefined;
            this.preferredData = this.preferredDataBackUp;
            this.openTextFilterModal = false;
        }
        
    }

    handleTextFilterModalClose() {
        this.openTextFilterModal = false;
    }

    handleApplyFilter(event) {
    
        this.columnToFilter = event.detail.column;
        this.valuesToFilter = event.detail.filterTerms;      

        if (this.openTextFilterModal) {
            //this.defaultSelectedValues2 = new Set();//jyothi
            this.defaultSelectedValues2 = '';
            var defaultSelectedValuesList = (event.detail.filterTerms).toString().split(',');
            if(defaultSelectedValuesList != undefined && defaultSelectedValuesList != ''){
                for(var i=0; i<defaultSelectedValuesList.length;i++){
                    //this.defaultSelectedValues2.add(defaultSelectedValuesList[i]);//jyothi
                    this.defaultSelectedValues2 = this.defaultSelectedValues2 +','+ (defaultSelectedValuesList[i]);//jyothi
                }
            }
            this.filterredWorkerName();
            
        }else if (this.openDateFilterModal) {    
            this.defaultSelectedDate = {"column":"lastWorked","filterTerms":{"endDate":this.valuesToFilter.endDate,"startDate":this.valuesToFilter.startDate}};
            this.filterredLastTimesheet();
        }

        this.openTextFilterModal = false;
        this.openDateFilterModal = false;
      }
      //get defaultSelectedValues() {//jyothi
      get defaultSelectedValues() {//jyothi
        return (this.defaultSelectedValues2)?this.defaultSelectedValues2+'':undefined;
      }

      //joythi.start
      get defaultSelectedDate2(){
        return (this.defaultSelectedDate)?this.defaultSelectedDate:undefined;
      }
      //joythi.stop
      filterredLastTimesheet(){
        
        let timezoneFormatter = new Intl.DateTimeFormat(LOCALE, {
            timeZone: this.timeZone
        });
        let startDateToCompare = Date.parse(
            this.formatLocaleDate(
                timezoneFormatter.format(new Date(this.valuesToFilter.startDate))
            )
        );

        let endDateToCompare = Date.parse(
            this.formatLocaleDate(
                timezoneFormatter.format(new Date(this.valuesToFilter.endDate))
            )
        );
        let toBeDisplayed = [];
        let theValue;
        this.preferredDataBackUp.forEach((pData) => {
            
            if (this.openDateFilterModal) {                
                theValue = pData['lastWorked'];
                if (theValue) {
                    theValue = this.formatLocaleDate2(theValue);
                    let dateValue = Date.parse(
                        this.formatLocaleDate(timezoneFormatter.format(new Date(theValue)))
                    );
                    if (
                        this.columnToFilter == "column" && startDateToCompare <= dateValue && endDateToCompare >= dateValue 
                    ) {
                        toBeDisplayed.push(pData);
                    }

                }
            } 
        });
        this.preferredData = toBeDisplayed;
      }
      filterredWorkerName(){
        let toBeDisplayed = [];
        let theValue;
        this.preferredDataBackUp.forEach((pData) => {
            if (this.openTextFilterModal) {                
                theValue = pData[this.columnToFilter];     
                if (theValue && this.valuesToFilter) {                   
                    if (
                        this.columnToFilter == "workerName" && this.valuesToFilter.includes(theValue)
                    ) {
                        toBeDisplayed.push(pData);
                        return;
                    }

                }
            }            
        });
        this.preferredData = toBeDisplayed;
      }

      formatLocaleDate(theDateString) {
        let theDateParts = theDateString.split("/");
        return theDateParts[2] + "-" + theDateParts[1] + "-" + theDateParts[0];
      }

      formatLocaleDate2(theDateString) {
        let theDateParts = theDateString.split("-");
        let month = (theDateParts[1].length == 1)?'0'+theDateParts[1]:theDateParts[1];
        let day = (theDateParts[0].length == 1)?'0'+theDateParts[0]:theDateParts[0];
        return theDateParts[2] + "-" + month + "-" +day ;
      }

      showMessageToUser(theVariant, theMode, theMessage) {
        const event = new ShowToastEvent({
          message: theMessage,
          variant: theVariant,
          mode: theMode
        });
        this.dispatchEvent(event);
      }

}