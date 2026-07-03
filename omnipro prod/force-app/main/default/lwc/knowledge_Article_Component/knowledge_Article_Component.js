import { LightningElement, wire, track, api } from 'lwc';
import networkId from '@salesforce/community/Id';
import basePath from '@salesforce/community/basePath';
import { CurrentPageReference } from 'lightning/navigation';
import getFeaturedTopicsAndPermissionSets from '@salesforce/apex/KnowledgeArticleTopicController.getFeaturedTopicsAndPermissionSets';
import getManagedTopics from '@salesforce/apex/KnowledgeArticleTopicController.getManagedTopics';
import getAccessToken from '@salesforce/apex/KnowledgeArticleTopicController.getAccessToken';
import fetchSubtopics from '@salesforce/apex/KnowledgeArticleTopicController.fetchSubtopics';
import queryKnowledgeArticles from '@salesforce/apex/KnowledgeArticleTopicController.getKnowledgeArticles';
import getArticleDetails from '@salesforce/apex/KnowledgeArticleTopicController.getArticleDetails';
import getContentDistribution from '@salesforce/apex/KnowledgeArticleTopicController.getContentDistribution';
import { NavigationMixin } from 'lightning/navigation';
import KnowledgeArticleCompCSS from "@salesforce/resourceUrl/KnowledgeArticleCompCSS";
import fetchTopic from '@salesforce/apex/KnowledgeArticleTopicController.fetchTopic';
import { loadStyle } from "lightning/platformResourceLoader";
import currentUserId from '@salesforce/user/Id';

export default class KnowledgeArticleComponent extends NavigationMixin(LightningElement) {
    @track featuredTopics = [];
    @track userId;
    
   // @api recordId;
    @track gridData = [];
    @track gridColumns = [
        {
            label: 'Subtopics',
            fieldName: 'label',
            type: 'button',
            typeAttributes: {
                label: { fieldName: 'label' },
                target: '_blank'
            },
            
            hideDefaultActions: true,
        }
    ];

    @track currentParentTopicId;
    @track gridExpandedRows = [];
    @track gridLoadingState = false;
    @track isLoading = false;
    @track topicParentName;
    @track formattedParentName;
    @track subChildId;
    @track articles = [];
    @track fileDetails;
    @track fileExtension;
    @track url;
    @track docURL;
    @track error;
    @track articleDetails;
    @track attachedDocuments = [];
    @track hasDocuments = false;
    @track isModalOpen = false;
    @track articlesForModal = [];
    @track articleURLName;
    @track topicLabel;
    @track communityUrl;
    @api navUrl;

    

    expandedRowsMap = new Map();
    dataCache = new Map();
    topicDataMap = new Map();

    @wire(CurrentPageReference)
    pageRef;

    // @wire(getTopics)
    // wiredGetTopics({ error, data }) {
    //     if (data) {
    //         this.featuredTopics = data.map(topic => ({ label: topic.Name, value: topic.Id }));
    //     } else if (error) {
    //         this.error = error;
    //         console.error('Error fetching topics:', error);
    //     }
    // }

    @wire(getFeaturedTopicsAndPermissionSets, { userId: currentUserId })
    wiredGetFeaturedTopics({ error, data }) {
        if (data) {
            this.featuredTopics = data.map(topic => ({
                value: topic.Id,
                label: topic.Name,
                description: topic.Description
            }));
        } else if (error) {
            this.error = error;
            console.error('Error fetching featured topics and permissions:', error);
        }
    }

    connectedCallback() {
        const before_ = `${basePath}`.substring(0, `${basePath}`.indexOf('/s')+1);
        this.communityUrl = `https://${location.host}${before_}`;
        console.log('Community Url Is :>>' + this.communityUrl);
        this.userId = currentUserId;
        console.log('Current User ID:', this.userId);
        this.fetchAccessToken();
        this.extractTopicIdFromUrl();
        this.updateGridColumns();
        Promise.all([
            loadStyle(this, KnowledgeArticleCompCSS)
        ]);
    }
    
    getBaseUrl() {
        let baseUrl = 'https://' + location.host + '/';
        return baseUrl;
    }

    updateGridColumns() {
        this.gridColumns = [
            {
                label: this.topicParentName || 'Subtopics',  
                fieldName: 'label',
                type: 'button',
                typeAttributes: {
                    label: { fieldName: 'label' },
                    title: { fieldName: 'title' },
                    target: '_blank'
                },
                hideDefaultActions: true,
            }
        ];
    }
    
    extractTopicIdFromUrl() {
        const { state, attributes } = this.pageRef || {};
        console.log('Page state:', this.pageRef?.state);
        console.log('Record Id Is:', this.recordId);
    
        if (state && state.recordName && attributes.recordId) {
            const recordName = state.recordName;
            const recordId = attributes.recordId;
            
           
            this.navUrl = `${this.communityUrl}s/topic/${recordId}/${recordName}`;
            this.formattedParentName = this.formatFieldName(this.topicParentName);
    
           
            this.fetchTopicParentName(recordId)
                .then(() => {
                    
                    this.updateGridColumns();
                })
                .catch(error => {
                    console.error('Error fetching topic name:', error);
                });
    
            
            this.fetchManagedTopics(recordId);
        } else {
            console.error('CurrentPageReference or state is undefined');
        }
    }
    
    fetchTopicParentName(topicRecordId) {
       
        return fetchTopic({ topicName: null, topicRecordId: topicRecordId })
            .then(result => {
                console.log('Topic Name fetched:', result);
                this.topicParentName = result;  
            })
            .catch(error => {
                console.error('Error fetching topic name:', error);
            });
    }
    


    fetchAccessToken() {
        getAccessToken()
            .then(result => console.log('Access Token fetched successfully:', result))
            .catch(error => console.error('Error fetching access token:', error));
    }

    handleTopicClick(event) {
        if (this.isLoading) return;

        this.isLoading = true;
        const { id: topicId, name: topicName } = event.currentTarget.dataset;
        this.currentParentTopicId = topicId;

        console.log('Topic ID:', topicId);
        console.log('Topic Name:', topicName);


        this.topicParentName = topicName;
        this.gridLoadingState = true;
        this.articles = [];

        const baseUrl = this.communityUrl+'s/topic/';
        const fullUrl = `${baseUrl}${topicId}/${topicName}`;

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: fullUrl
            }
        });

        if (this.topicDataMap.has(topicId)) {
            this.gridData = this.topicDataMap.get(topicId);
            this.gridLoadingState = false;
            this.isLoading = false;
        } else {
            this.fetchManagedTopics(topicId);
        }
    }

    fetchManagedTopics(topicId) {
        console.log('current user id >>' + this.userId);
        console.log('fetchManagedTopics topicId: ' + topicId);
        this.currentParentTopicId = topicId;
    
        getManagedTopics({ featuredtopicid: topicId, userId: this.userId })
            .then(result => {
                // Create shallow copy of orginal array before sorting bcus original array cant be modified
                let sortableResult = [...result];
    
                sortableResult.sort((a, b) => a.label.localeCompare(b.label));
    
                console.log('Sorted result:', JSON.stringify(sortableResult));
    
                // Transform the sorted data
                const transformedData = this.transformData(sortableResult);
    
                // Cache and update grid data
                this.topicDataMap.set(topicId, transformedData);
                this.gridData = transformedData;
    
                this.gridLoadingState = false;
                this.isLoading = false;
            })
            .catch(error => {
                this.gridLoadingState = false;
                this.isLoading = false;
                console.error('Error fetching initial subtopics:', error);
            });
    }
    

    transformData(data) {
        const transformItem = item => ({
            id: item.name,
            title: item.title,
            label: item.label,
            url: item.url,
            _children: item.children || []
        });

        return data.map(transformItem);
    }

    handleRowToggle(event) {
        if (this.isLoading) return;

        console.log('handleRowToggle CLicked ');
    
        const row = event.detail.row;
        const { id: rowId, label } = row;
        //console.log('rowId :' + rowId);
        console.log('Row label  ' + label);
        
        this.subChildId = rowId;
        console.log('this.subChildId From the HandleRowToggle >>' + this.subChildId);
    
        if (rowId.startsWith('ka0')) {
            console.log('Opening Articles ');
            this.fetchArticleDetails(rowId);
            return;
        }else{
            this.topicLabel = label;
        }
    
        const isRowExpanded = this.expandedRowsMap.has(rowId);
    
        if (isRowExpanded) {
            console.log('Inside the row expanded');
            this.expandedRowsMap.delete(rowId);
            this.gridData = this.collapseRow(rowId, this.gridData);
        } else {
            this.expandedRowsMap.set(rowId, true);
    
            if (row.url) {
                if (this.dataCache.has(label)) {
                    console.log('Using cached data for label:', label);
                    this.gridData = this.updateDataWithChildren(label, this.dataCache.get(label));
                } else {
                    console.log('Loading child data from URL:', row.url);
                    this.loadChildData(row.url, label);
                }
            } else {
                console.error('URL is missing for row:', row);
            }
    
            if (!(row._children && row._children.length > 0)) {
                this.queryKnowledgeArticles(rowId);
            }
        }
    
        this.gridExpandedRows = Array.from(this.expandedRowsMap.keys());
        //console.log('this.gridExpandedRows :' + this.gridExpandedRows);
    }
    
    collapseRow(id, data) {
        console.log('Into Collapse row');
        return data.map(item => {
            if (item.id === id) {
                return {
                    ...item,
                    _children: [],
                    _articles: [] 
                };
            }
            if (item._children) {
                return {
                    ...item,
                    _children: this.collapseRow(id, item._children)
                };
            }
            return item;
        });
    }

    queryKnowledgeArticles(articleId) {
        const formattedParentName = this.formatFieldName(this.topicParentName);
        const formattedSubChildId = this.formatFieldName(this.subChildId);
        console.log('formattedParentName :' + formattedParentName);
        console.log('formattedSubChildId :' + formattedSubChildId);
    
        queryKnowledgeArticles({ parentName: formattedParentName, subChildId: formattedSubChildId })
            .then(result => {
                console.log('Articles are: ' + JSON.stringify(result));
    
                if (result && result.length > 0) {
                    const baseUrl = this.communityUrl+'s/knowledgearticledetails?article=';
                    this.articles = result.map(article => {
                        let trimLabel = article.label;
                        let fulllabel = article.label;
                        if (trimLabel.length > 80) {
                            trimLabel = trimLabel.substring(0, 80) + '...';
                        }
    
                        return {
                            id: article.labelid,
                            title: fulllabel,
                            label: trimLabel,
                            url: `${baseUrl}${article.labelid}`
                        };
                    });
                    this.addArticlesToSubtopic(); 
                    console.log('articles added to subtopic: ' + JSON.stringify(this.articles));
                } else {
                    console.log('No articles found.');
                }
            })
            .catch(error => {
                console.error('Error querying knowledge articles:', error);
            });
    }
    

    addArticlesToSubtopic() {
        if (!this.subChildId || !this.gridData || !this.articles) return;

        const existingArticleIds = new Set();

        const updateSubtopic = data => data.map(item => {
            if (item.id === this.subChildId) {
                (item._articles || []).forEach(article => existingArticleIds.add(article.id));

                const newArticles = this.articles.filter(article => !existingArticleIds.has(article.id));
                newArticles.forEach(article => existingArticleIds.add(article.id));

                return {
                    ...item,
                    _children: [
                        ...newArticles
                    ]
                };
            }

            if (item._children?.length > 0) {
                return {
                    ...item,
                    _children: updateSubtopic(item._children)
                };
            }

            return item;
        });

        this.gridData = updateSubtopic(this.gridData);
    }

    formatFieldName(name) {
        return name ? name.replace(/[\s-]+/g, '_') + '__c' : '';
    }

    loadChildData(suburl, label) {
        console.log('Parent Label >' + label);
       
        if (this.isLoading) return;
    
        this.gridLoadingState = true;
        this.isLoading = true;
    
       
        if (!suburl) {
            console.error('SubURL is missing');
            this.gridLoadingState = false;
            this.isLoading = false;
            return;
        }
    
      
        const cachedData = sessionStorage.getItem(label);
        if (cachedData) {
            console.log('Data retrieved from sessionStorage for label:', label);
            this.gridData = this.updateDataWithChildren(label, JSON.parse(cachedData));
            this.gridLoadingState = false;
            this.isLoading = false;
            return;
        }
    
        console.log('this parent label  ' + label);
        console.log('this this.currentParentTopicId  ' + this.currentParentTopicId);

       fetchSubtopics({ SubTopicUrl: suburl, parentName: label, userId: this.userId, ParentTopicId: this.currentParentTopicId })
            .then(result => {
                console.log('Subtopics are: ' + JSON.stringify(result));

                if (result.length === 0) {
                    console.log('No subtopics found.');
                } else {
                    console.log('Sorting subtopics alphabetically for label:', label);

                    // Create shallow copy of orginal array before sorting bcus original array cant be modified
                    let sortableResult = [...result];

                    // Sort the copied array alphabetically by 'label'
                    sortableResult.sort((a, b) => a.label.localeCompare(b.label));

                    //console.log('Sorted subtopics:', JSON.stringify(sortableResult));

                    //console.log('Fetching new data and caching for label:', label);

                    // Cache the sorted result
                    sessionStorage.setItem(label, JSON.stringify(sortableResult));
                    console.log('SessionStorage updated for label:', label);

                    // Update the grid data with sorted children
                    this.gridData = this.updateDataWithChildren(label, sortableResult);
                    console.log('Updated grid data: ' + JSON.stringify(this.gridData));
                }
                this.gridLoadingState = false;
                this.isLoading = false;
            })
            .catch(error => {
                console.error('Error fetching subtopics:', error);
                this.gridLoadingState = false;
                this.isLoading = false;
            });


    }
    
    
    updateDataWithChildren(parentLabel, children) {
        const updatedData = this.recursivelyUpdateData(this.gridData, parentLabel, children);
        return updatedData;
    }
    
    recursivelyUpdateData(data, parentLabel, children) {
        return data.map(item => {
            if (item.label === parentLabel) {
                return {
                    ...item,
                    _children: this.transformData(children) || []
                };
            }
    
            if (item._children && item._children.length > 0) {
                return {
                    ...item,
                    _children: this.recursivelyUpdateData(item._children, parentLabel, children)
                };
            }
    
            return item;
        });
    }
    

    fetchArticleDetails(articleId) {
        console.log('article id to fetch data :' + articleId);
        getArticleDetails({ articleId })
            .then(result => {
                console.log('fetched articles details are :' + JSON.stringify(result));
                this.articleDetails = result.article;
                this.attachedDocuments = result.attachedDocuments;
                this.hasDocuments = this.attachedDocuments.length > 0;
                this.articleURLName = result.article.UrlName;
                console.log('this.articleURLName >>> ' + this.articleURLName);

                if (this.hasDocuments) {
                    console.log('Document Present');
                    this.previewDocuments(this.attachedDocuments);
                } else {
                    console.log('Article Present');
                    this.displayQuestionAnswer(this.articleURLName);
                }
            })
            .catch(error => console.error('Error fetching article details:', error));
    }

    previewDocuments(documents) {
        const documentId = documents[0].Id;
        this.showPreview(documentId);
    }

    showPreview(documentId) {
        console.log('document id to preview: ' + documentId);
        getContentDistribution({ documentId })
            .then(distResult => {
                if (distResult && distResult.length > 0) {
                    this.docURL = distResult[0].DistributionPublicUrl;

                    const showPreview = this.template.querySelector('c-document-preview-modal');
                    if (showPreview) {
                        this.isModalOpen = false;
                        showPreview.show();
                        console.log('preview modal Successfully');
                    } else {
                        console.log('Preview component not found.');
                    }
                } else {
                    console.warn('No distribution results found.');
                }
            })
            .catch(distError => {
                console.error('Error fetching content distribution:', distError);
            });
    }

    displayQuestionAnswer(articleName) {
        console.log('this.navUrl >>>' + this.navUrl);


        console.log('this.navUrl >>>' + this.navUrl);

        // Construct the full URL manually, appending articleName
        const baseUrl = this.communityUrl+'s/article/';
        const fullUrl = baseUrl + articleName;
    
        // Navigate directly to the constructed URL
        window.open(fullUrl, '_blank');

        // const pageReference = {
        //     type: 'comm__namedPage',
        //     attributes: {
        //         name: 'Article_Detail'  
        //     },
        //     state: {
        //         article: this.articleId
        //     }
        // };

        
        // this[NavigationMixin.GenerateUrl](pageReference)
        //     .then(url => {
        //         const baseUrl = 'https://omniproireland2--omniprodev.sandbox.my.site.com/helpcenter/s/article/';
        //          const fullUrl = baseUrl + this.articleName;
        //         window.location.href = url;  
        //     })
        //     .catch(error => {
        //         console.error('Error generating URL:', error);
        //     });
    
    
    
        // Define the page reference for the standard community page "Article_Detail"
        // const pageReference = {
        //     type: 'comm__namedPage',  // Standard community page
        //     attributes: {
        //         name: 'Article_Detail'  // API name of the standard page (Article_Detail)
        //     },
        //     state: {
        //         'article': articleId,                // Pass the articleId as state
        //         'navUrl': this.navUrl,               // Pass your navUrl
        //         'topicLabel': this.topicLabel,       // Pass the topicLabel
        //         'urlName': this.articleURLName,      // Article URL Name
        //         'topicParentName': this.topicParentName, // Topic Parent Name
        //         'recordId': this.recordId,           // Record ID, if needed
        //     }
        // };
    
        // // Generate the URL and open it in a new tab
        // this[NavigationMixin.GenerateUrl](pageReference)
        //     .then(url => {
        //         window.open(url, '_blank');  // Open the generated URL in a new tab
        //     })
        //     .catch(error => {
        //         console.error('Error generating URL:', error);
        //     });
    }
    
    

    navigateToWebPage(file) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: file.fileUrl
            }
        }, false);
    }

    handleSelect() {
        console.log('handleSelect Clicked');
    }

    rowhandleselect() {
        console.log('rowhandleselect Clicked');
    }

    onSelectToggle(){
        console.log('onSelectToggle Clicked');
    }

    handleRowAction(event) {
        console.log('handleRowAction Clicked');

        const row = event.detail.row;
        console.log('Selected handleRowAction details:', JSON.stringify(row));
    }

    rowselectionHandle() {
        console.log('rowselectionHandle Clicked');
    }
}