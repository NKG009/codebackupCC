import { LightningElement, wire, api, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import CreateTimerRecord from '@salesforce/apex/timeTrackerLWCController.CreateTimerRecord';
import getTimerRecords from '@salesforce/apex/timeTrackerLWCController.GetTimerRecords';
import updateComments from '@salesforce/apex/timeTrackerLWCController.updateComments';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';


export default class TimeTrackerLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @track timerData = [];
    @track error;
    showPlay = true;
    showPause = false;
    showCancel = false;
    showStop = false;
    @track sessionTimer = '00:00:00';
    @track totalMilliseconds = 0;
    @track totalRecords = 0;
    @track isLoading = false;
    @track wiredSessionData;
    @track columns;
    @track setTimeInterval;
    @track isModalOpen = false;
    @track startTime;
    totaltimespent;
    startDateTime;
    hours;
    minutes;
    comments='';
    @track draftValues = [];


    columns = [
        { label: 'TIME TRACKER NO.', fieldName: 'TTNumber', hideDefaultActions: true },
        { label: 'USER', fieldName: 'TTUserName', hideDefaultActions: true },
        { label: 'START DATE', fieldName: 'TTStartDate', hideDefaultActions: true },
        { label: 'START TIME', fieldName: 'TTStartTime', hideDefaultActions: true },
        { label: 'TIME SPENT', fieldName: 'TTTimeSpent', hideDefaultActions: true },
        { label: 'COMMENTS', fieldName: 'TTComments', hideDefaultActions: true, editable: true },
    ];

   
    @wire(getTimerRecords, { recordId: '$recordId' })
    wiredtimerrecord(response) {
        console.log('called getTimerRecords:', JSON.stringify(response));
        this.wiredSessionData = response;
        const { data, error } = response;
        if (data) {
            let totalseconds = 0;
            this.timerData = data.map(timerdata => {
                const startDate = new Date(timerdata.Started_Date_Time__c).toLocaleDateString();
                const startTime = new Date(timerdata.Started_Date_Time__c).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                
                totalseconds=totalseconds+ timerdata.Total_Time_Tracked_Seconds__c;
                console.log(
                    'totalseconds:',
                    totalseconds);
                const hours = Math.floor(totalseconds / 3600);
                const minutes = Math.floor((totalseconds % 3600) / 60);
                const seconds = totalseconds % 60;
                
                if (hours > 0) {
                    this.totaltimespent = `${hours} hours ${minutes} minutes ${seconds} seconds`;
                } else if (minutes > 0) {
                    this.totaltimespent = `${minutes} minutes ${seconds} seconds`;
                } else {
                    this.totaltimespent = `${seconds} seconds`; 
                }

                return {
                    TTId: timerdata.Id,
                    TTNumber: timerdata.Name,
                    TTUserName: timerdata.CreatedBy.Name,
                    TTStartDate: startDate,
                    TTStartTime: startTime,
                    TTTimeSpent: timerdata.Total_Time_Tracked_String__c,
                    TTComments: timerdata.Comments__c
                };
            });
            this.totalRecords = data.length;
        } else if (error) {
            this.error = error;
            console.log(
                'Error on wire:',
                JSON.stringify(error));
            console.error('Error retrieving timer data:', error);
        }
    }

    handlePlay() {
        console.log(
            'called play case timer');
            this.showPlay = false;
            this.showPause = true;
            this.showCancel = true;
            this.showStop = true;
        this.isLoading = true;
        this.startSessionTimer();
        this.startTime = Date.now();
        this.isLoading = false;
    }

    handlePause() {
        this.isLoading = true;
        this.showPlay = true;
        this.showPause = false;
        this.showCancel = true;
        this.showStop = true;
        clearTimeout(this.setTimeInterval);
        this.isLoading = false;
        this.showToast('Paused', 'Case Timer is paused.', 'info');
    }

    handlecancel() {
        this.isLoading = true;
        this.resetButtons();
        clearInterval(this.setTimeInterval);
        this.totalMilliseconds = 0;
        this.sessionTimer = '00:00:00';
        this.showToast(
            'Timer Cancelled!',
            'Timer has been successfully cancelled.',
            'success'
        );
        this.isLoading = false;
        
    }

    handleStop() {
        console.log('called stop timer');
        this.isLoading = true;
        this.resetButtons();
        clearInterval(this.setTimeInterval);
        console.log('called before apex timer');
        const startDateTime = new Date(this.startTime);
        CreateTimerRecord({
            recordId: this.recordId,
            starteddatetime:startDateTime,
            trackedTime: this.sessionTimer,
            trackedtotalSeconds:Math.floor(this.totalMilliseconds / 1000),
            comments: this.comments
        })
            .then(() => {
                this.isLoading = false;
                this.totalMilliseconds = 0;
                this.sessionTimer = '00:00:00';
                this.showToast(
                    'Success!',
                    'Timer Record is successfully created.',
                    'success'
                );
                refreshApex(this.wiredSessionData);
            })
            .catch(error => {
                this.isLoading = false;
                console.log(
                    'Error on Stop:',
                    JSON.stringify(error));
                this.showToast('Error!', 'An error occurred.', 'error');
                console.error('Error on Stop:', error);
            });
    }
    resetButtons() {
        this.showPlay = true;
        this.showPause = false;
        this.showCancel = false;
        this.showStop = false;
    }

   

    startSessionTimer() {
        this.setTimeInterval = setInterval(() => {
            let hours = Math.floor(this.totalMilliseconds / 3600000);
            let minutes = Math.floor((this.totalMilliseconds % 3600000) / 60000);
            let seconds = Math.floor((this.totalMilliseconds % 60000) / 1000);
            this.sessionTimer = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            this.totalMilliseconds += 1000;
        }, 1000);
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(evt);
    }

    handleSaveldt(event) {
        console.log('handlesave called');
        const updatedFields = event.detail.draftValues;

        updateComments({ updatedList: updatedFields })
            .then(() => {
                this.draftValues = [];

                getRecordNotifyChange([{ recordId: updatedFields[0].TTId }]);
                refreshApex(this.wiredSessionData);
                this.showToast('Success', 'Comments updated successfully', 'success');

            })
            .catch(error => {
                this.showToast('Error', 'An error occurred while updating comments', 'error');
                console.error('Error updating comments:', error);
            });
    }

    handleCancel(event) {
        this.isModalOpen = false;
    }

    handleNew(event) {
        console.log(
            'handleNew called');
        this.isModalOpen = true;
    }
    handleSaveNew(event) {
        console.log('handleSaveNew called');
        
        let missingFields = [];

        if (!this.startDateTime) {
            missingFields.push('Start Date Time');
        }
        if (!this.hours) {
            missingFields.push('Hours');
        }
        if (!this.minutes) {
            missingFields.push('Minutes');
        }

        if (missingFields.length > 0) {
            this.showToast('Error', `please populate: ${missingFields.join(', ')}`, 'error');
            return; 
        }

        this.isLoading = true;
        const totalSeconds = (parseInt(this.hours, 10) * 3600) + (parseInt(this.minutes, 10) * 60);

        const trackedTime = this.formatTime(this.hours, this.minutes);

        CreateTimerRecord({
            recordId: this.recordId, // Pass your specific recordId
            starteddatetime: this.startDateTime,
            trackedTime: trackedTime,
            trackedtotalSeconds: totalSeconds,
            comments: this.comments
        })
        .then(() => {
            this.isModalOpen = false;
            this.isLoading = false;
            this.showToast('Success', 'Time Tracker record created successfully', 'success');
            this.clearForm();
        })
        .catch(error => {
            this.showToast('Error', 'Failed to create record: ' + error.body.message, 'error');
        });

    }

    formatTime(hours, minutes) {
        const paddedHours = String(hours).padStart(2, '0');
        const paddedMinutes = String(minutes).padStart(2, '0');
        return `${paddedHours}:${paddedMinutes}:00`; 
    }

    clearForm() {
        this.startDateTime = null;
        this.hours = null;
        this.minutes = null;
        this.comments = null;
        this.template.querySelector('[data-id="startDateTime"]').value = '';
        this.template.querySelector('[data-id="hours"]').value = '';
        this.template.querySelector('[data-id="minutes"]').value = '';
        this.template.querySelector('[data-id="comments"]').value = '';
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        const value = event.target.value;
        console.log(
            'handleInputChange called',
            'field: ' + field,
            'value: ' + value);
        // Update corresponding variables based on the input field
        if (field === 'startDateTime') {
            this.startDateTime = value;
        } else if (field === 'hours') {
            this.hours = value;
        } else if (field === 'minutes') {
            this.minutes = value;
        } else if (field === 'comments') {
            this.comments = value;
        }
    }
    
        showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
            mode
        });
        this.dispatchEvent(event);
    }
}
