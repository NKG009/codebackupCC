import { LightningElement } from 'lwc';

export default class PortalV2MyShiftsWeeklyView extends LightningElement {
    showjoborderdetail =false;
   //filteredShifts=[{"candidateId":"001","candidateName":"John Doe","weekCommencing":"2025-05-27","days":{"Mon":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"09:05","actualEnd":"16:55","breaks":"30 mins"},"Tue":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"","actualEnd":"","breaks":""},"Wed":{"hours":0,"scheduledStart":"","scheduledEnd":"","actualStart":"","actualEnd":"","breaks":""},"Thu":{"hours":0},"Fri":{"hours":0},"Sat":{"hours":0},"Sun":{"hours":0}},"totalHours":16},{"candidateId":"002","candidateName":"Jane Smith","weekCommencing":"2025-05-27","days":{"Mon":{"hours":6,"scheduledStart":"10:00","scheduledEnd":"16:00","actualStart":"10:10","actualEnd":"15:55","breaks":"20 mins"},"Tue":{"hours":7,"scheduledStart":"09:00","scheduledEnd":"16:00","actualStart":"09:00","actualEnd":"16:00","breaks":"30 mins"}},"totalHours":13}];
   joborderdetaildata;
filteredShifts=[{"candidateId":"001","candidateName":"John Doe","weekCommencing":"2025-05-27","days":{"Mon":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"09:05","actualEnd":"16:55","breaks":"30 mins"},"Tue":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"09:00","actualEnd":"17:00","breaks":"30 mins"},"Wed":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"09:10","actualEnd":"16:50","breaks":"30 mins"},"Thu":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"09:00","actualEnd":"17:00","breaks":"30 mins"},"Fri":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"08:55","actualEnd":"16:45","breaks":"30 mins"},"Sat":{"hours":4,"scheduledStart":"09:00","scheduledEnd":"13:00","actualStart":"09:00","actualEnd":"13:00","breaks":"15 mins"},"Sun":{"hours":0,"scheduledStart":"00:00","scheduledEnd":"00:00","actualStart":"00:00","actualEnd":"00:00","breaks":"0 mins"}},"totalHours":44},{"candidateId":"002","candidateName":"Jane Smith","weekCommencing":"2025-05-27","days":{"Mon":{"hours":6,"scheduledStart":"10:00","scheduledEnd":"16:00","actualStart":"10:10","actualEnd":"15:55","breaks":"20 mins"},"Tue":{"hours":7,"scheduledStart":"09:00","scheduledEnd":"16:00","actualStart":"09:00","actualEnd":"16:00","breaks":"30 mins"},"Wed":{"hours":10,"scheduledStart":"09:00","scheduledEnd":"19:00","actualStart":"09:00","actualEnd":"19:00","breaks":"30 mins"},"Thu":{"hours":8,"scheduledStart":"09:00","scheduledEnd":"17:00","actualStart":"09:00","actualEnd":"17:00","breaks":"30 mins"},"Fri":{"hours":5,"scheduledStart":"09:00","scheduledEnd":"14:00","actualStart":"09:10","actualEnd":"13:55","breaks":"15 mins"},"Sat":{"hours":4,"scheduledStart":"10:00","scheduledEnd":"14:00","actualStart":"10:00","actualEnd":"14:00","breaks":"15 mins"},"Sun":{"hours":0,"scheduledStart":"00:00","scheduledEnd":"00:00","actualStart":"00:00","actualEnd":"00:00","breaks":"0 mins"}},"totalHours":40}];





 handleRowClick(event) {
    event.preventDefault();
    const jobOrderId = event.target.getAttribute('data-id');
    console.log('Row clicked for JobOrder Id:', jobOrderId);
    this.joborderdetaildata = this.filteredShifts.find(jobOrder => jobOrder.candidateId === jobOrderId);
    this.showjoborderdetail = true;
    console.log('Details:', JSON.stringify(this.joborderdetaildata));
     console.log('daysList:', JSON.stringify(Object.keys(this.joborderdetaildata.days || {})));
    }




get daysList() {
 const daysObj = this.joborderdetaildata?.days || {};
  return Object.keys(daysObj).map(dayName => {
    return { dayName, ...daysObj[dayName] };
  });
}






}