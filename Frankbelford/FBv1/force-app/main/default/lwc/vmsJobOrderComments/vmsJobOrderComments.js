import { LightningElement, api, wire, track } from 'lwc';
import getJobOrderComments from '@salesforce/apex/PortalV2MyJobOrdersController.getJobOrderCommentscached';
import { createRecord } from 'lightning/uiRecordApi';
import JOB_ORDER_COMMENT_OBJECT from '@salesforce/schema/Job_Order_Comments__c';
import COMMENT_TEXT_FIELD from '@salesforce/schema/Job_Order_Comments__c.Comment_Text__c';
import COMMENT_TYPE_FIELD from '@salesforce/schema/Job_Order_Comments__c.Comment_Type__c';
import JOB_ORDER_FIELD from '@salesforce/schema/Job_Order_Comments__c.Job_Order__c';
import { refreshApex } from '@salesforce/apex';

export default class JobOrderComments extends LightningElement {
    @api recordId; // This will capture the current record's ID (Job Order ID)
    @track allCommentRecords = [];
    @track newComment = '';

    // Fetch Job Order Comments based on the recordId (Job Order ID)
    @wire(getJobOrderComments, { jobOrderId: '$recordId' })
    wiredComments({ error, data }) {
        if (data) {
            this.allCommentRecords = data;
            console.log('Comments fetched: ', data);
        } else if (error) {
            console.error('Error fetching comments: ', error);
        }
    }

    handleCommentChange(event) {
        this.newComment = event.target.value;
    }

    handleSubmitNewComment() {
        if (this.newComment.trim() !== '') {
            const newChatMessage = {
                Comment_Text__c: this.newComment,
                Comment_Type__c: 'Internal',
                Job_Order__c: this.recordId,  
                CreatedDate: new Date().toISOString()
            };

            const fields = {};
            fields[COMMENT_TEXT_FIELD.fieldApiName] = newChatMessage.Comment_Text__c;
            fields[COMMENT_TYPE_FIELD.fieldApiName] = newChatMessage.Comment_Type__c;
            fields[JOB_ORDER_FIELD.fieldApiName] = newChatMessage.Job_Order__c;

            const recordInput = { apiName: JOB_ORDER_COMMENT_OBJECT.objectApiName, fields };

            createRecord(recordInput)
                .then(result => {
                    newChatMessage.Id = result.id;
              this.allCommentRecords = [...this.allCommentRecords, newChatMessage];

              this.newComment = '';
              this.scrollToLastComment();
                   
                    console.log('Comment successfully added: ', result.id);
                })
                .catch(error => {
                    console.error('Error creating comment: ', error);
                });
        }
    }

    scrollToLastComment() {
        setTimeout(() => {
            const commentElements = this.template.querySelectorAll('[data-id]');
            if (commentElements.length > 0) {
                const lastCommentElement = commentElements[commentElements.length - 1];
                lastCommentElement.scrollIntoView({ behavior: 'smooth', block: 'end' });
            }
        }, 0);
    }
}