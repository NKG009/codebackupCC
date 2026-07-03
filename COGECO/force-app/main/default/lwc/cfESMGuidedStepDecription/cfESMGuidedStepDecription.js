import { FlexCardMixin } from "vlocity_cmt/flexCardMixin";
    import { CurrentPageReference } from 'lightning/navigation';
    import {interpolateWithRegex, interpolateKeyValue, loadCssFromStaticResource } from "vlocity_cmt/flexCardUtility";
    
          import { LightningElement, api, track, wire } from "lwc";
          import pubsub from "vlocity_cmt/pubsub";
          import { getRecord } from "lightning/uiRecordApi";
          import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
          import data from "./definition";
          
          import styleDef from "./styleDefinition";
              
          export default class cfESMGuidedStepDecription extends FlexCardMixin(OmniscriptBaseMixin(LightningElement)){
              currentPageReference;        
              @wire(CurrentPageReference)
              setCurrentPageReference(currentPageReference) {
                this.currentPageReference = currentPageReference;
              }
              @api debug;
              @api recordId;
              @api objectApiName;
              @track _omniSupportKey = 'cfESMGuidedStepDecription';
                  @api get omniSupportKey() {
                    return this._omniSupportKey;
                  }
                  set omniSupportKey(parentRecordKey) {
                    this._omniSupportKey = this._omniSupportKey  + '_' + parentRecordKey;
                  }
              @track record;
              @track _sessionApiVars = {};
        @api set cfIconType(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["IconType"] = val;
          }
        } get cfIconType() {
          return this._sessionApiVars["IconType"] || "standard:quotes";
        }
      
        @api set cfTitle(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["Title"] = val;
          }
        } get cfTitle() {
          return this._sessionApiVars["Title"] || "Quote Creation Journey";
        }
      
        @api set cfDescription(val) {
          if(typeof val !== "undefined") {
            this._sessionApiVars["Description"] = val;
          }
        } get cfDescription() {
          return this._sessionApiVars["Description"] || "Sit nulla est ex deserunt exercitation anim occaecat. Nostrud ullamco deserunt aute id dee doo da fauxet la gigman roo. i";
        }
      
              @track Label={CMEXConfigureProductStep:"Edit, clone, or delete products.",
        CMEXConfigureProducts:"Configure Products",
        CMEXSelectYourProducts:"Select products to add to the quote",
        CMEXSelectProducts:"Select Products",
        CMEXAddSubscriberLabelDescription:"Add subscribers manually or upload a file containing details of multiple subscribers.",
        CMEXAddSubscriberLabel:"Add Subscribers to Quote",
        CMEXCreateQuoteJourneyDescriptionOnLocationPage:"Add locations manually or upload a file containing details of multiple addresses",
        CMEXGuidedAddLocations:"Add Locations to Quote",
        CMEXESMQuoteJourneyDescription:"Create or configure your enterprise quote.",
        CMEXESMQuoteJourneyTitle:"Get Started",
        CMEXCreateQuoteJourneyDescription:"Provide basic quote details and select whether to include guided assistance when creating a quote.",
        CMEXCreateQuoteJourney:"Create an Enterprise Quote"
        };
              pubsubEvent = [];
              customEvent = [];
              
              connectedCallback() {
                super.connectedCallback();
                this.setThemeClass(data);
                this.setStyleDefinition(styleDef);
                data.Session = {} //reinitialize on reload
                
                
                this.customLabels = this.Label;
                      
                this.setDefinition(data);
 this.registerEvents();
                
                
              }
              
              disconnectedCallback(){
                super.disconnectedCallback();
                    this.omniSaveState(this.records,this.omniSupportKey,true);
                    

                  this.unregisterEvents();
              }

              registerEvents() {
                
              }

              unregisterEvents(){
                
              }
            
              renderedCallback() {
                super.renderedCallback();
                
              }
          }