import { LightningElement } from "lwc";
    import b2bCartSummary from "vlocity_cmt/b2bCartSummary";
    import template from "./customb2bexp.html"
    import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
    export default class customb2bexp extends OmniscriptBaseMixin(b2bCartSummary){
        // your properties and methods here
        
      connectedCallback() {
        // Call omniUpdateDataJson to update the omniscript
        // this.omniUpdateDataJson({'key':'value'});
      }
    
        render()
          {
            return template;
          }
    }