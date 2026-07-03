import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";

import gettimesheets from "@salesforce/apex/TimesheetPageApexController.getTimesheetByUserAccount";

export default class PortalTimesheetWeeklyView extends LightningElement {
    //! Assets
    filterIcon = SITE_ASSETS + "/img/icons/filter-dk-grey.svg";
    calendarIcon = SITE_ASSETS + "/img/icons/calendar-dk-grey.svg";
    paginationLeft = SITE_ASSETS + "/img/icons/left-dk-grey-caret.svg";
    paginationRight = SITE_ASSETS + "/img/icons/right-dk-grey-caret.svg";
    primaryAnchorCaret = SITE_ASSETS + "/img/icons/primary-anchor-caret.svg";
    primaryAnchorCaretOpen = SITE_ASSETS + "/img/icons/primary-anchor-caret-down.svg";

    jobView = true;
    currentShiftView = true;
    numberOfRecords;

    selectedTimePeriod = "1 week";
    timePeriodOptions = [
        {
            value: "1 week",
            label: "Last 1 Week"
        },
        {
            value: "1",
            label: "Last 1 Month"
        },
        {
            value: "3",
            label: "Last 3 Months"
        },
        {
            value: "6",
            label: "Last 6 Months"
        },
        {
            value: "120",
            label: "All Time"
        }
    ];

    @track loading = true;
    @track timesheets = [];

    get viewSwitchLabel() {
        return this.jobView ? "View by Worker" : "View by Job Role";
    }

    get timePeriodSwitchLabel() {
        return this.currentShiftView ? "View Past Timesheets" : "View Current Timesheets";
    }

    get hasRecords() {
        return this.numberOfRecords > 0;
    }

    connectedCallback() {
        this.fetchTimesheets();
    }

    selectionChangeHandler(event) {
        if (event.target.value) {
            this.selectedTimePeriod = event.target.value;
        }
    }

    handleViewToggleClick() {
        this.jobView = !this.jobView;
    }

    handleTimePeriodToggleClick() {
        this.currentShiftView = !this.currentShiftView;
    }

    handlePageSelected(event) {
        const pageNumber = event.detail;
    }

    fetchTimesheets() {
        gettimesheets().then(result => {
            console.log('================================= result : ' + JSON.stringify(result));
            this.timesheets = this.transformTimesheetData(result);
            this.loading = false;
        }).catch(error => {
            console.error(error); // Log any errors encountered
        });
    }

    transformTimesheetData(timesheetData) {
        const result = [];

        timesheetData.forEach(timesheet => {
            const dayMap = {
                Monday: '',
                Tuesday: '',
                Wednesday: '',
                Thursday: '',
                Friday: '',
                Saturday: '',
                Sunday: ''
            };

            // Process timesheet lines by day
            if (timesheet.sirenum__Timesheet_Lines__r) {
                timesheet.sirenum__Timesheet_Lines__r.forEach(line => {
                    const dateStr = line.sirenum__Date__c;
                    if (dateStr) {
                        const date = new Date(dateStr);
                        const dayName = date.toLocaleDateString('en-US', { weekday: 'long' });

                        if (dayMap.hasOwnProperty(dayName)) {
                            const current = dayMap[dayName];
                            dayMap[dayName] = current
                                ? parseFloat(current) + parseFloat(line.sirenum__Hours__c || 0)
                                : line.sirenum__Hours__c || '';
                        }
                    }
                });
            }

            // Format week commencing date like "17-Mar"
            let formattedWeekCommencing = '';
            if (timesheet.sirenum__Week_Ending__c) {
                const wcDate = new Date(timesheet.sirenum__Week_Ending__c);
                const day = wcDate.getDate().toString().padStart(2, '0');
                const month = wcDate.toLocaleString('en-US', { month: 'short' });
                formattedWeekCommencing = `${day}-${month}`;
            }

            result.push({
                workerName: timesheet.sirenum__Worker__r?.Name || '',
                weekCommencing: formattedWeekCommencing,
                monHours: dayMap.Monday,
                tueHours: dayMap.Tuesday,
                wedHours: dayMap.Wednesday,
                thuHours: dayMap.Thursday,
                friHours: dayMap.Friday,
                satHours: dayMap.Saturday,
                sunHours: dayMap.Sunday,
                totalHours: timesheet.sirenum__Total_Hours__c || 0
            });
        });

        return result;
    }


}