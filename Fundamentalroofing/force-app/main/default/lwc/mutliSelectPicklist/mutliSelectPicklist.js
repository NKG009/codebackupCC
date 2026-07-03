import { LightningElement, track, api } from 'lwc';

export default class App extends LightningElement {

    @api
    values = [];

    @track
    selectedvalues = [];

    @api
    picklistlabel = 'Status';

    @api
    picklistfieldname='';

    showdropdown;

    handleleave() {
        console.log('handle leave');
         setTimeout(() => { 
        let sddcheck= this.showdropdown;

        if(sddcheck){
            this.showdropdown = false;
            this.fetchSelectedValues();
        }
     },1000);
    }

    connectedCallback(){
        console.log('in connected callback');
        this.values.forEach(element => element.selected 
                            ? this.selectedvalues.push(element.value) : '');
        console.log(this.selectedvalues);
    }

    fetchSelectedValues() {
        console.log('in fetch selected values');
        this.selectedvalues = [];

        //get all the selected values
        this.template.querySelectorAll('c-picklist-value').forEach(
            element => {
                if(element.selected){
                    console.log(element.value);
                    this.selectedvalues.push(element.value);
                }
            }
        );

        //refresh original list
        this.refreshOrginalList();
    }

    refreshOrginalList() {
        //update the original value array to shown after close
        console.log('in refresh original list');
        const picklistvalues = this.values.map(eachvalue => ({...eachvalue}));

        picklistvalues.forEach((element, index) => {
            if(this.selectedvalues.includes(element.value)){
                picklistvalues[index].selected = true;
            }else{
                picklistvalues[index].selected = false;
            }
        });

        this.values = picklistvalues;

        console.log('refreshed original list', JSON.stringify(this.values));
        console.log('selected values', JSON.stringify(this.selectedvalues));
        this.dispatchEvent(
            new CustomEvent('selectionchange', { 
                detail:{ 'value': this.values,
                     'picklistfieldname':this.picklistfieldname,
                     'selectedvalues': this.selectedvalues
                    }
             })
            );
    }

    handleShowdropdown(){
        console.log('in handle show dropdown');
        let sdd = this.showdropdown;
        if(sdd){
            this.showdropdown = false;
            this.fetchSelectedValues();
        }else{
            this.showdropdown = true;
        }
    }

    closePill(event){
        console.log('in close pill');
        console.log(event.target.dataset.value);
        console.log('inclose selection',JSON.stringify(event.target));
        let selection = event.target.dataset.value;
        let selectedpills = this.selectedvalues;
        console.log(selectedpills);
        let pillIndex = selectedpills.indexOf(selection);
        console.log(pillIndex);
        this.selectedvalues.splice(pillIndex, 1);
        this.refreshOrginalList();
    }

    get selectedmessage() {
        return this.selectedvalues.length + ' values are selected';
    }
}