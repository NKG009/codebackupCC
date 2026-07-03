import { LightningElement, api, track} from 'lwc';

export default class ProgressBarTile extends LightningElement {

    @api value;
    @api size;
    @api barColor;
    @api barHeight;

    get valueStyle(){
        return 'width: ' + parseInt(this.value) + '%';
    }

    renderedCallback(){
        var progressbar = this.template.querySelector(".slds-progress-bar");
        if(progressbar != null){
            progressbar.style.setProperty('--custom-progressBarHeight', this.barHeight);            
        }
        var progressbarvalue = this.template.querySelector(".slds-progress-bar__value");
        if(progressbarvalue != null){
            progressbarvalue.style.setProperty('--custom-progressBarColor', this.barColor);
        }        
    }    

}

/*
    <lightning-progress-bar value={value} size="Large" variant="circular">        
    </lightning-progress-bar>

        var progressbar = this.template.querySelector("lightning-progress-bar");
        if(progressbar != null){
            progressbar.style.setProperty("--lwc-progressBarColorBackgroundFill", this.barColor);  
        }        
*/