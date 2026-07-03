import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getMyPortfolio from '@salesforce/apex/PortfolioViewerController.getMyPortfolio';

export default class PortfolioViewer extends LightningElement {

    currentPageReference = null; 
    urlStateParameters = null;

    @api usrId;    
    @api defaultUsrId;  

    @api header;    
    @api headerFontSize;
    @api headerFontColor;
    @api headerFontFamily;

    @api title;    
    @api agencyTitle;
    @api teamTitle;

    @api progressBarColor;
    @api progressBarHeight;

    @api agencyProgressBarColor;
    @api agencyProgressBarHeight;  

    @api teamProgressBarColor;
    @api teamProgressBarHeight;    

    @api labelFontSize;
    @api labelFontColor;
    @api labelFontFamily;
    @api labelPercentColor;

    @api agencyLabelFontSize;
    @api agencyLabelFontFamily;

    @api teamLabelFontSize;
    @api teamLabelFontColor;
    @api teamLabelFontFamily;    
    @api teamLabelPercentColor;   

    @api portfolio;
    @api error;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }   
 
    setParametersBasedOnUrl() {
        this.usrId = this.urlStateParameters.usrId || null;
        this.callGetMyPortfolio();        
    }

    connectedCallback(){
        this.callGetMyPortfolio();
    }

    callGetMyPortfolio(){
        console.log('callGetMyPortfolio start');   
        getMyPortfolio({aUsrId: this.usrId, aDefaultUsrId: this.defaultUsrId})
        .then(result => {
            console.log('getMyPortfolio result start');
            this.portfolio = result;
            this.error = undefined;
            console.log('getMyPortfolio result end');
        })
        .catch(error => {
            console.log('getMyPortfolio error start');
            this.portfolio = undefined;
            this.error = error;
            console.log(error);
            console.log('getMyPortfolio error end');
        });

        console.log('callGetMyPortfolio end');

    }

    renderedCallback(){

        var headerlabels = this.template.querySelectorAll(".header-label");
        if(headerlabels != null){            
            for (var i = 0; i < headerlabels.length; i++) {
                headerlabels[i].style.setProperty("--header-font-size", this.headerFontSize);
                headerlabels[i].style.setProperty("--header-font-color", this.headerFontColor);
                headerlabels[i].style.setProperty("--header-font-family", this.headerFontFamily);
            }
        }          
        
        var progressbarlabels = this.template.querySelectorAll(".custom-label");
        if(progressbarlabels != null){            
            for (var i = 0; i < progressbarlabels.length; i++) {
                progressbarlabels[i].style.setProperty("--label-font-size", this.labelFontSize);
                progressbarlabels[i].style.setProperty("--label-font-color", this.labelFontColor);
                progressbarlabels[i].style.setProperty("--label-font-family", this.labelFontFamily);
                progressbarlabels[i].style.setProperty("--percent-color", this.labelPercentColor);                
            }
        }     

        var teambarlabels = this.template.querySelectorAll(".team-label");
        if(teambarlabels != null){            
            for (var i = 0; i < teambarlabels.length; i++) {
                teambarlabels[i].style.setProperty("--team-font-size", this.teamLabelFontSize);
                teambarlabels[i].style.setProperty("--team-font-color", this.teamLabelFontColor);
                teambarlabels[i].style.setProperty("--team-font-family", this.teamLabelFontFamily);
                teambarlabels[i].style.setProperty("--team-percent-color", this.teamLabelPercentColor);                
            }
        }  

    }

}