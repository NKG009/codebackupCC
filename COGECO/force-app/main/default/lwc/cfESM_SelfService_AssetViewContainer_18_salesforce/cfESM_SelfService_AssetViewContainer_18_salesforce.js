import { FlexCardMixin } from "vlocity_cmt/flexCardMixin";
    import { CurrentPageReference } from 'lightning/navigation';
    import {interpolateWithRegex, interpolateKeyValue, loadCssFromStaticResource } from "vlocity_cmt/flexCardUtility";
    
          import { LightningElement, api, track, wire } from "lwc";
          import pubsub from "vlocity_cmt/pubsub";
          import { getRecord } from "lightning/uiRecordApi";
          
          import data from "./definition";
          
          import styleDef from "./styleDefinition";
              
          export default class cfESM_SelfService_AssetViewContainer_18_salesforce extends FlexCardMixin(LightningElement){
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
        @api set cfChangeToOrderPage(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["ChangeToOrderPage"] = val;
          }
        } get cfChangeToOrderPage() {
          return this._sessionApiVars["ChangeToOrderPage"] || "";
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
                  " card-0koDp000000PctWIAS"
                );
                this.loadCustomStylesheetAttachement("00PDp00000BoRpmMAF");
                
                
              }
              
              disconnectedCallback(){
                super.disconnectedCallback();
                    
                    

                  this.unregisterEvents();
              }

              registerEvents() {
                
        this.pubsubEvent[0] = {
          [interpolateWithRegex(`onAssetsLoad`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[0],0)
        };
        this.pubsubChannel0 = interpolateWithRegex(`esm_selfservice_getassets`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel0,this.pubsubEvent[0]);

        this.pubsubEvent[1] = {
          [interpolateWithRegex(`baseinputvaluechange`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[1],1)
        };
        this.pubsubChannel1 = interpolateWithRegex(`esm_selfservice_groupby`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel1,this.pubsubEvent[1]);

        this.pubsubEvent[2] = {
          [interpolateWithRegex(`onPageClick`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[2],2)
        };
        this.pubsubChannel2 = interpolateWithRegex(`esm_selfservice_gotopage`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel2,this.pubsubEvent[2]);

        this.pubsubEvent[3] = {
          [interpolateWithRegex(`onAssetsLoad`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[3],3)
        };
        this.pubsubChannel3 = interpolateWithRegex(`esm_selfservice_updatecountdetails`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel3,this.pubsubEvent[3]);

        this.pubsubEvent[4] = {
          [interpolateWithRegex(`onItemsSelected`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[4],4)
        };
        this.pubsubChannel4 = interpolateWithRegex(`esm_selfservice_updateselection`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel4,this.pubsubEvent[4]);

        this.pubsubEvent[5] = {
          [interpolateWithRegex(`onSortingDirectionChange`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[8],8)
        };
        this.pubsubChannel5 = interpolateWithRegex(`esm_selfservice_updatesortdirection`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel5,this.pubsubEvent[5]);

            this.customEventName0 = interpolateWithRegex(`oncolumnsort`,this._allMergeFields,this._regexPattern,"noparse");
            this.customEvent[0] = this.handleEventAction.bind(this, data.events[5],5);

            this.template.addEventListener(this.customEventName0,this.customEvent[0]);

          
            this.customEventName1 = interpolateWithRegex(`onselectalltoggle`,this._allMergeFields,this._regexPattern,"noparse");
            this.customEvent[1] = this.handleEventAction.bind(this, data.events[6],6);

            this.template.addEventListener(this.customEventName1,this.customEvent[1]);

          
            this.customEventName2 = interpolateWithRegex(`onassetexpansion`,this._allMergeFields,this._regexPattern,"noparse");
            this.customEvent[2] = this.handleEventAction.bind(this, data.events[7],7);

            this.template.addEventListener(this.customEventName2,this.customEvent[2]);

          
              }

              unregisterEvents(){
                pubsub.unregister(this.pubsubChannel0,this.pubsubEvent[0]);
pubsub.unregister(this.pubsubChannel1,this.pubsubEvent[1]);
pubsub.unregister(this.pubsubChannel2,this.pubsubEvent[2]);
pubsub.unregister(this.pubsubChannel3,this.pubsubEvent[3]);
pubsub.unregister(this.pubsubChannel4,this.pubsubEvent[4]);
pubsub.unregister(this.pubsubChannel5,this.pubsubEvent[5]);

            this.template.removeEventListener(this.customEventName0,this.customEvent[0]);

            this.template.removeEventListener(this.customEventName1,this.customEvent[1]);

            this.template.removeEventListener(this.customEventName2,this.customEvent[2]);

              }
            
              renderedCallback() {
                super.renderedCallback();
                
              }
          }