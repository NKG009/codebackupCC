import { LightningElement, wire, api, track } from 'lwc';

export default class SearchLWC extends LightningElement {
    //Searchvalue='';
    @track Filtervalue='';
    @track DisciplineFShow=false;
    @track SpecialtyFShow=false;
    @track CityFShow=false;
    @track StateFShow=false;
    @track PostalCodeFShow=false;
    @track EducationRequirementsFShow=false;
    @track manualcomponentshowboolean=false;
    @track DistanceFShow=false;
    dataJobTitle;
    dataExperience;
    dataSkill;
    dataDiscipline;
    dataSpecialty;
    dataCity;
    dataState;
    dataPostalCode;
    dataEducationRequirements;
    dataDistance=50;
 
    

    /*get Searchoptions() {
        return [
            { label: 'Manual Search', value: 'Manual Search' },
            { label: 'Automatic Search', value: 'Automatic Search' }
        ];
    }*/

    get Filteroptions() {
        return [
            { label: 'Discipline', value: 'Discipline' },
            { label: 'Specialty', value: 'Specialty' },
            { label: 'City', value: 'City' },
            { label: 'State', value: 'State' },
            { label: 'Postal Code', value: 'Postal Code' },
            { label: 'Education Requirements', value: 'Education Requirements' },
            { label: 'Distance', value: 'Distance'}

        ];
    }
    
   /* handleSearchChange(event) {
        this.Searchvalue = event.detail.value;
        if(this.Searchvalue=='Manual Search'){
            this.manualcomponentshowboolean=true;
        }
        else{
            this.manualcomponentshowboolean=false; 
        }
    }*/
    handleFilterChange(event) {
        this.Filtervalue = event.detail.value;
        console.log('Filtervalue:'+this.Filtervalue );
        if(this.Filtervalue=='Discipline'){
            this.DisciplineFShow =true;
        }
        if(this.Filtervalue=='Specialty'){
            this.SpecialtyFShow=true;
        }
        if(this.Filtervalue=='City'){
            this.CityFShow=true;
        }
        if(this.Filtervalue=='State'){
            this.StateFShow=true;
        }
        if(this.Filtervalue=='Postal Code'){
            this.PostalCodeFShow=true;
        }
        if(this.Filtervalue=='Education Requirements'){
            this.EducationRequirementsFShow=true;
        }
        if(this.Filtervalue=='Distance'){
            this.DistanceFShow=true;
        }
        this.Filtervalue='';
    }

    handleManualSearchClick(event){
        console.log('buttonclicked');
            this.manualcomponentshowboolean=true;  
    }
    removeDisciplineField(event){
        this.DisciplineFShow =false;

    }
    removeSpecialtyField(event){
        this.SpecialtyFShow=false;

    }
    removeCityField(event){
        this.CityFShow=false;
    }
    removeStateField(event){
        this.StateFShow=false;
    }
    removePostalCodeField(event){
        this.PostalCodeFShow=false;
    }
    removeEducationRequirementsField(event){
        this.EducationRequirementsFShow=false;
    }
    removeDistanceField(event){
        this.DistanceFShow=false;
    }
}