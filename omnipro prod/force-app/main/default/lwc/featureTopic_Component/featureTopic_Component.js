import { LightningElement, wire, track, api } from 'lwc';
import getFeaturedTopicsAndPermissionSets from '@salesforce/apex/KnowledgeArticleTopicController.getFeaturedTopicsAndPermissionSets';
import currentUserId from '@salesforce/user/Id';
import ARC from '@salesforce/resourceUrl/ARC';
import Knowledgehub from '@salesforce/resourceUrl/Knowledgehub';
import FRS102 from '@salesforce/resourceUrl/FRS102';
import CompaniesAct from '@salesforce/resourceUrl/CompaniesAct';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FeatureTopic_Component extends NavigationMixin(LightningElement) {

    @track featuredTopics = [];
    @track userId = currentUserId;

    @wire(getFeaturedTopicsAndPermissionSets, { userId: currentUserId })
wiredGetFeaturedTopics({ error, data }) {
    if (data) {
        if (data.length === 0) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'No Topics available. Please contact the System Administrator regarding Permission Set assignment.',
                    variant: 'error',
                    mode: 'sticky'
                })
            );
        } else {
            this.featuredTopics = data.map(topic => ({
                value: topic.Id,
                label: topic.Name,
                description: topic.Description,
                image: this.getImagePath(topic.Name)
            }));
            console.log('featuredTopics: ' + JSON.stringify(this.featuredTopics));
        }
    } else if (error) {
        this.error = error;
        console.error('Error fetching featured topics and permissions:', error);

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'An error occurred while fetching featured topics.',
                variant: 'error',
                mode: 'sticky'
            })
        );
    }
}


    getImagePath(topicName) {
        let imageUrl = '';
        switch (topicName) {
            case 'Accountants Resource Centre':
                imageUrl = ARC; 
                break;
            case 'CompaniesAct2014.com Premium Toolkit':
                imageUrl = CompaniesAct; 
                break;
            case 'FRS102.com Premium Toolkit':
                imageUrl = FRS102; 
                break;
            case 'KnowledgeHUB':
                imageUrl = Knowledgehub; 
                break;
            
        }
        return imageUrl;
    }


    // handleClick(event) {
    //     console.log('Image clicked: ' + event.target.dataset.id);
    //     console.log('Image clicked: ' + event.target.dataset.name);


    //     const topicId = event.target.dataset.id;
    // }
    handleClick(event) {
        console.log('Image clicked Id: ' + event.target.dataset.id);
        console.log('Image clicked Name: ' + event.target.dataset.name);

        const topicId = event.target.dataset.id;
        const topicName = event.target.dataset.name;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: topicId, 
                objectApiName: 'Topic', 
                actionName: 'view' 
            }
        });
    }
}