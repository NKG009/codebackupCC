import { FlexCardMixin } from "vlocity_cmt/flexCardMixin";
    import { CurrentPageReference } from 'lightning/navigation';
    import {interpolateWithRegex, interpolateKeyValue, loadCssFromStaticResource } from "vlocity_cmt/flexCardUtility";
    
          import { LightningElement, api, track, wire } from "lwc";
          import pubsub from "vlocity_cmt/pubsub";
          import { getRecord } from "lightning/uiRecordApi";
          
          import data from "./definition";
          
          import styleDef from "./styleDefinition";
              
          export default class cfESM_SelfService_OrderSummary_4_salesforce extends FlexCardMixin(LightningElement){
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
        @api set cfConfigurePageApi(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["ConfigurePageApi"] = val;
          }
        } get cfConfigurePageApi() {
          return this._sessionApiVars["ConfigurePageApi"] || "undefined";
        }
      
        @api set cfChangeToOrderPageApi(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["ChangeToOrderPageApi"] = val;
          }
        } get cfChangeToOrderPageApi() {
          return this._sessionApiVars["ChangeToOrderPageApi"] || "undefined";
        }
      
        @api set cfOrderConfirmationPageApi(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["OrderConfirmationPageApi"] = val;
          }
        } get cfOrderConfirmationPageApi() {
          return this._sessionApiVars["OrderConfirmationPageApi"] || "undefined";
        }
      
        @api set cfCartId(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["CartId"] = val;
          }
        } get cfCartId() {
          return this._sessionApiVars["CartId"] || "";
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
                
                
              }
              
              disconnectedCallback(){
                super.disconnectedCallback();
                    
                    

                  this.unregisterEvents();
              }

              registerEvents() {
                
        this.pubsubEvent[0] = {
          [interpolateWithRegex(`onload`,this._allMergeFields,this._regexPattern,"noparse")]: this.handleEventAction.bind(this, data.events[0],0)
        };
        this.pubsubChannel0 = interpolateWithRegex(`esm_selfservice_ordersummary_onload`,this._allMergeFields,this._regexPattern,"noparse");
        pubsub.register(this.pubsubChannel0,this.pubsubEvent[0]);

            this.customEventName0 = interpolateWithRegex(`esm_selfservice_ordersummary_load`,this._allMergeFields,this._regexPattern,"noparse");
            this.customEvent[0] = this.handleEventAction.bind(this, data.events[1],1);

            this.template.addEventListener(this.customEventName0,this.customEvent[0]);

          
              }

              unregisterEvents(){
                pubsub.unregister(this.pubsubChannel0,this.pubsubEvent[0]);

            this.template.removeEventListener(this.customEventName0,this.customEvent[0]);

              }
            
              renderedCallback() {
                super.renderedCallback();
                
              }
          }