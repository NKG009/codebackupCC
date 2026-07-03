/**
 * Created by Charlie Nash (RSS Global) on 24/10/2023.
 */

import { LightningElement } from 'lwc';
import beginSetup from '@salesforce/apex/NewSelfRegController.initiateSelfReg';
import returnContactEmail from '@salesforce/apex/NewSelfRegController.returnContactEmailFromId';


export default class SelfRegisterLwc extends LightningElement {

    isLoading = false;
    validEmail = false;

    showEmailInput = true;

    question1Value = '';
    question2Value = '';

    showSignUpButton = false;

    firstName = '';
    lastName = '';
    email = '';
    emailError = '';

    a_Record_URL = '';

    displayScreen1 = true;

    resultFromSubmissionText = '';

    renderedCallback() {
            //  the required business logic to be executed when component is rendered
            console.log('onload logic ran');

            this.a_Record_URL = window.location.origin + '/candidate/s/login/';

            console.log('URL: ',this.a_Record_URL, '/candidate/s/login/');

            const queryString = window.location.search;
            console.log(queryString);

            const urlParams = new URLSearchParams(queryString);

            const contactIdParam = urlParams.get('Id');
            const contactEmailParam = urlParams.get('email');
            console.log(contactIdParam);
            console.log(contactEmailParam);
            if(contactIdParam != null){
                console.log('Id not null, blocking email entry');
                returnContactEmail({contactId: contactIdParam})
                .then(result => {
                    this.email = result;
                    this.showEmailInput = false;
                })
                .catch(error => {
                    console.log('error retrieving contact Email: ',error);
                });
            }
            else{
                if(contactEmailParam != null){
                    console.log('email param detected');
                    this.email = contactEmailParam;
                    this.showEmailInput = false;
                }
            }

        }

        get options() {
            return [
                { label: 'Yes', value: 'yes' },
                { label: 'No', value: 'no' },
            ];
        }

    updateFirstName(event){
        this.firstName= event.target.value;
        this.compatibilityCheck();
    }
    updateLastName(event){
        this.lastName= event.target.value;
        this.compatibilityCheck();
    }
    updateEmail(event){
        this.email= event.target.value;
        this.compatibilityCheck();
    }
    updateQ1(event){
        this.question1Value= event.target.value;
        this.compatibilityCheck();
    }
    updateQ2(event){
        this.question2Value= event.target.value;
        this.compatibilityCheck();
    }

    compatibilityCheck(){

        if(this.question1Value != '' && this.question2Value != '' && this.firstName != '' && this.lastName != '' && this.email != ''){
            this.showSignUpButton = true;
        }
        else{
            this.showSignUpButton = false;
        }

    }

    clickSignUp(event){
        this.ValidateEmail(event);
        if(this.validEmail == true){

            this.isLoading = true;
            console.log('ran');
            console.log('details: ',this.firstName,this.lastName,this.email,this.question1Value,this.question2Value);





        if(this.question1Value != 'no' && this.question2Value != 'no'){
        beginSetup({firstName:this.firstName, lastName:this.lastName, emailAddress:this.email})
        .then(result => {

            console.log('response from apex: ',result);
            this.resultFromSubmissionText = result;
            this.displayScreen1 = false;
            this.isLoading = false;

        })
        .catch(error => {
            console.log('error: ',error);
            this.isLoading = false;
            this.displayScreen1 = false;
        });
        }
        else{
            this.resultFromSubmissionText = 'Thank you for your interest, unfortunately you are unable to progress further at this stage due to not currently being able to work in the UK. Please contact us if your circumstances change in the future.';
            this.displayScreen1 = false;
            this.isLoading = false;
        }

        }
        else{
            this.isLoading = false;
            console.log('Invalid email logic running');
        }

    }

    ValidateEmail(event) {

      var validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

      if (this.email.match(validRegex)) {

        //alert("Valid email address!");
        this.emailError = '';

        this.validEmail = true;

      } else {

        //alert("Invalid email address!");
        this.emailError = 'Invalid Email Entered.';

      }

    }

    clickLoginPage(){
        window.location.href = this.a_Record_URL;
    }

}