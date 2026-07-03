import { FlexCardMixin } from "vlocity_cmt/flexCardMixin";
    import { CurrentPageReference } from 'lightning/navigation';
    import {interpolateWithRegex, interpolateKeyValue, loadCssFromStaticResource } from "vlocity_cmt/flexCardUtility";
    
          import { LightningElement, api, track, wire } from "lwc";
          import pubsub from "vlocity_cmt/pubsub";
          import { getRecord } from "lightning/uiRecordApi";
          
          import data from "./definition";
          
          import styleDef from "./styleDefinition";
              
          export default class cfESM_SelfService_ConfigureCartContainer extends FlexCardMixin(LightningElement){
              currentPageReference;        
              @wire(CurrentPageReference)
              setCurrentPageReference(currentPageReference) {
                this.currentPageReference = currentPageReference;
              }
              @api debug;
              @api recordId;
              @api objectApiName;
              
              @track record;
              @track _sessionApiVars = {};
        @api set cfSummaryPage(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["SummaryPage"] = val;
          }
        } get cfSummaryPage() {
          return this._sessionApiVars["SummaryPage"] || "";
        }
      
        @api set cfConfigurePreviousPage(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["ConfigurePreviousPage"] = val;
          }
        } get cfConfigurePreviousPage() {
          return this._sessionApiVars["ConfigurePreviousPage"] || "";
        }
      
              
              pubsubEvent = [];
              customEvent = [];
              
              connectedCallback() {
                super.connectedCallback();
                this.setThemeClass(data);
                this.setStyleDefinition(styleDef);
                data.Session = {} //reinitialize on reload
                
                
                
                this.setDefinition(data);
 this.registerEvents();
                this.setAttribute(
                  "class", (this.getAttribute("class") ? this.getAttribute("class") : "") +
                  " card-0koDp000000PctBIAS"
                );
                this.loadCustomStylesheetAttachement("00PDp00000BoRpFMAV");
                
                
              }
              
              disconnectedCallback(){
                super.disconnectedCallback();
                    
                    

                  this.unregisterEvents();
              }

              registerEvents() {
                
        this.pubsubEvent[0] = {
          [interpolateWithRegex(`onGroupsLoad`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[0],0)
        };
        this.pubsubChannel0 = interpolateWithRegex(`esm_selfservice_groupdetails`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel0,this.pubsubEvent[0]);

        this.pubsubEvent[1] = {
          [interpolateWithRegex(`onItemsLoad`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[1],1)
        };
        this.pubsubChannel1 = interpolateWithRegex(`esm_selfservice_cartitemresponse`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel1,this.pubsubEvent[1]);

            this.customEventName0 = interpolateWithRegex(`onshowspinner`,this._allMergeFields,this._regexPattern,"noparse");
            this.customEvent[0] = this.handleEventAction.bind(this, data.events[2],2);

            this.template.addEventListener(this.customEventName0,this.customEvent[0]);

          
              }

              unregisterEvents(){
                pubsub.unregister(this.pubsubChannel0,this.pubsubEvent[0]);
pubsub.unregister(this.pubsubChannel1,this.pubsubEvent[1]);

            this.template.removeEventListener(this.customEventName0,this.customEvent[0]);

              }
            
              renderedCallback() {
                super.renderedCallback();
                
              }
          }