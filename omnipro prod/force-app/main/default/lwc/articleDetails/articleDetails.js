import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getArticleDetails from '@salesforce/apex/KnowledgeArticleTopicController.getArticleDetails';
import getContentDistribution from '@salesforce/apex/KnowledgeArticleTopicController.getContentDistribution';


export default class ArticleDetails extends LightningElement {
    @api recordId;
    @api topicId;
    @track docURL;
    @track articleDetails;
    @track attachedDocuments = [];
    @track hasDocuments = false;
    @track questionHtml = '';
    @track answerHtml = '';
    @track articleName;
    @track TopicUrl;
    @track topicName;
    @track error;
    @track topicLabel;
    @track currentPageURL;

    @wire(CurrentPageReference)
    pageRef;

    connectedCallback() {
        this.currentPageURL = window.location.origin;
        console.log('Current Page URL is :>>' + this.currentPageUR );
        console.log('connectedCallback invoked');
        console.log('Record ID:', this.recordId);

        if (this.pageRef) {
            console.log('CurrentPageReference:', this.pageRef);

            const urlName = this.pageRef.attributes?.urlName;
            console.log('URL Name from attributes:', urlName);

            if (this.pageRef.state) {
                console.log('Page state:', this.pageRef.state);

                const articleId = this.pageRef.state.article;
                console.log('Article ID from URL:', articleId);

                this.TopicUrl = this.pageRef.state.navUrl;
                console.log('TopicUrl from URL:', this.TopicUrl);

              
                console.log('TopicLabel from URL:', this.topicLabel);
                
                this.topicName = this.pageRef.state.topicParentName;
                console.log('Parent Topic Name from URL:', this.topicName);

               
                if (articleId) {
                    console.log('Fetching details for article ID from URL:', articleId);
                    this.fetchArticleDetails(articleId);
                } else if (this.recordId) {
                    console.log('Fetching details for article ID from recordId:', this.recordId);
                    this.fetchArticleDetails(this.recordId);
                } else {
                    console.error('Article ID and recordId are both missing');
                }
            } else {
                console.error('Page state is undefined');
            }
        } else {
            console.error('CurrentPageReference is undefined');
        }
    }

    fetchArticleDetails(articleId) {
        getArticleDetails({ articleId: articleId })
            .then(result => {
                
                console.log('In to the fetchArticleDetails');
                console.log('Fetched article details:', JSON.stringify(result));

    
                if (result && result.article) {
                    this.articleDetails = result.article;
                    this.questionHtml = result.article.Question__c || '';
                    this.answerHtml = result.article.Answer__c || '';
                    this.articleName = result.article.Title || 'Help Article';
                }
                
                this.attachedDocuments = result.attachedDocuments || [];
                this.hasDocuments = this.attachedDocuments.length > 0;
    
               
                if (!this.questionHtml && !this.answerHtml) {
                    console.log('Question and answer are empty, fetching the article again');
                    this.previewDocuments(this.attachedDocuments);
                }
            })
            .catch(error => {
                this.error = error;
                console.error('Error fetching article details:', error);
            });
    }
    

    
   


    
    previewDocuments(documents) {
       
        const documentId = documents[0].Id;
        this.showPreview(documentId);
    }

    
    showPreview(documentId) {
        console.log('Document ID to preview: ' + documentId);
        getContentDistribution({ documentId })
            .then(distResult => {
                if (distResult && distResult.length > 0) {
                    this.docURL = distResult[0].DistributionPublicUrl;

                    const showPreview = this.template.querySelector('c-document-preview-modal');
                    if (showPreview) {
                        this.isModalOpen = true; 
                        showPreview.show();
                        console.log('Preview modal opened successfully');
                    } else {
                        console.log('Preview component not found.');
                    }
                } else {
                    console.warn('No distribution results found.');
                }
            })
            .catch(distError => {
                console.error('Error fetching content   :', distError);
            });
        }


        handleOpenDocument() {
            if (this.attachedDocuments.length > 0) {
                this.previewDocuments(this.attachedDocuments);
            }
        }

        get hasContent() {
            return !!(this.questionHtml || this.answerHtml);
        }

}