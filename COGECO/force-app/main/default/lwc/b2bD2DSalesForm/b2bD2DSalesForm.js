import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createLead from '@salesforce/apex/LeadCreationController.createLead';
import uploadFiles from '@salesforce/apex/LeadCreationController.uploadFiles';
import logo from '@salesforce/resourceUrl/Cogeco_Logo';

export default class B2bD2DSalesForm extends LightningElement {
  logoUrl = logo;

  @track formData = {};
  @track filesToUpload = [];
  @track currentStep = 1;
  @track isSubmitted = false;

  // Text labels used for file UI (set in connectedCallback/updateFileTexts)
  @track fileButtonText = 'Choose Files';
  @track filePlaceholderText = 'No file chosen';
  @track removeButtonText = 'Remove';

  preferredLanguageOptions = [
    { label: 'English', value: 'English' },
    { label: 'French', value: 'French' }
  ];

  // Contact role options for English and French
  contactRoleOptionsMap = {
    English: [
      { label: 'Owner', value: 'Owner' },
      { label: 'Manager', value: 'Manager' },
      { label: 'Administrator', value: 'Administrator' }
    ],
    French: [
      { label: 'Propriétaire', value: 'Owner' },
      { label: 'Gérant.e', value: 'Manager' },
      { label: 'Administrateur.rice', value: 'Administrator' }
    ]
  };

  yesNoOptionsMap = {
    English: [
      { label: 'Yes', value: 'Yes' },
      { label: 'No', value: 'No' }
    ],
    French: [
      { label: 'Oui', value: 'Yes' },
      { label: 'Non', value: 'No' }
    ]
  };

  speedOptionsMap = {
    English: [
      { label: '2GB', value: '2GB' },
      { label: '1GB', value: '1GB' },
      { label: '360Mbps', value: '360Mbps' },
      { label: '120Mbps', value: '120Mbps' },
      { label: '80MBps', value: '80MBps' }
    ],
    French: [
      { label: '2 Go', value: '2GB' },
      { label: '1 Go', value: '1GB' },
      { label: '360 Mbps', value: '360Mbps' },
      { label: '120 Mbps', value: '120Mbps' },
      { label: '80 Mbps', value: '80MBps' }
    ]
  };

  internetTermOptionsMap = {
    English: [
      { label: 'No Term', value: 'No Term' },
      { label: '36 Months', value: '36 Months' }
    ],
    French: [
      { label: 'Pass de durée définie', value: 'No Term' },
      { label: '36 Mois', value: '36 Months' }
    ]
  };

  configurationOptionsMap = {
    English: [
      { label: 'Basic - No Wi-Fi', value: 'Basic - No Wi-Fi' },
      { label: 'Wi-Fi', value: 'Wi-Fi' },
      { label: 'Static IP', value: 'Static IP' }
    ],
    French: [
      { label: 'Basique - Pas de Wi-Fi', value: 'Basic - No Wi-Fi' },
      { label: 'Wi-Fi', value: 'Wi-Fi' },
      { label: 'IP Statique', value: 'Static IP' }
    ]
  };

  wifiTypeOptionsMap = {
    English: [
      { label: 'Wi-Fi AC Modem', value: 'Wi-Fi AC Modem' },
      { label: 'Wi-Fi 6 Modem', value: 'Wi-Fi 6 Modem' }
    ],
    French: [
      { label: 'Modem Wi-Fi AC', value: 'Wi-Fi AC Modem' },
      { label: 'Modem Wi-Fi 6', value: 'Wi-Fi 6 Modem' }
    ]
  };

  wifiExtenderOptions = Array.from({ length: 9 }, (_, i) => ({ label: String(i), value: String(i) }));

  numberTypeOptionsMap = {
    English: [
      { label: 'New Number/s', value: 'New Number/s' },
      { label: 'Ported Number/s', value: 'Ported Number/s' }
    ],
    French: [
      { label: 'Nouveau(x) numéro(s)', value: 'New Number/s' },
      { label: 'Numéro(s) transféré(s)', value: 'Ported Number/s' }
    ]
  };

  // Translation dictionaries for English and French
  LABELS = {
    English: {
      REP_ID: 'REP ID',
      REP_Name: 'REP Name',
      REP_Email: 'REP Email',
      Business_Name: 'Business Name',
      Business_Phone: 'Business Phone#',
      Service_Address: 'Service Address',
      Postal_Code: 'Postal Code',
      Billing_Address: 'Billing Address (leave blank if same)',
      Contact_Name: 'Contact Name',
      Contact_Role: 'Contact Role',
      Contact_Phone: 'Contact Phone#',
      Contact_Email: 'Contact Email',
      Internet_Sold: 'Internet Sold?',
      Speed: 'Speed',
      Internet_Term: 'Internet Term',
      Configuration: 'Configuration',
      Wi_Fi_Type: 'Wi-Fi Type',
      WiFi_6_Extenders_Required: 'WiFi 6 Extenders Required?',
      Total_Internet_MRR: 'Total Internet MRR',
      Voice_Sold: 'Voice Sold?',
      of_Lines: '# of Lines',
      Voice_Term: 'Voice Term',
      Number_Type: 'Number Type',
      Total_Voice_MRR: 'Total Voice MRR',
      Video_Sold: 'Video Sold?',
      Package: 'Package',
      Video_Term: 'Video Term',
      Number_of_Boxes_Required: 'Number of Boxes Required',
      List_any_additional_channels_packages_to: 'List any additional channels/packages to be subscribed to?',
      Total_Video_MRC: 'Total Video MRC',
      Professional_Install_Fee: 'Professional Install Fee',
      Additional_Comments: 'Additional Comments',
      Upload_Required_Files: 'Upload any required files',
      view_please_indicate: 'if waived please indicate with 0.00'
    },
    French: {
      REP_ID: 'ID de représentant',
      REP_Name: 'Nom du représentant',
      REP_Email: 'Courriel du représentant',
      Business_Name: 'Nom de l\'entreprise',
      Business_Phone: 'Téléphone de l\'entreprise',
      Service_Address: 'Adresse de service',
      Postal_Code: 'Code postal',
      Billing_Address: 'Adresse de facturation (si différente de l’adresse de service)',
      Contact_Name: 'Nom de la personne-ressource',
      Contact_Role: 'Rôle de la personne-ressource',
      Contact_Phone: 'Téléphone de la personne-ressource',
      Contact_Email: 'Courriel de la personne-ressource',
      Internet_Sold: 'Internet vendu?',
      Speed: 'Vitesse',
      Internet_Term: 'Durée Internet',
      Configuration: 'Configuration',
      Wi_Fi_Type: 'Type de Wi-Fi',
      WiFi_6_Extenders_Required: 'Amplificateurs WiFi 6 requis?',
      Total_Internet_MRR: 'Revenu mensuel Internet total',
      Voice_Sold: 'Voix vendue?',
      of_Lines: 'Nombre de lignes',
      Voice_Term: 'Durée de la voix',
      Number_Type: 'Type de numéro',
      Total_Voice_MRR: 'Revenu mensuel Voix total',
      Video_Sold: 'Vidéo vendue?',
      Package: 'Forfait',
      Video_Term: 'Durée Vidéo',
      Number_of_Boxes_Required: 'Nombre de décodeurs requis',
      List_any_additional_channels_packages_to: 'Liste des chaînes/forfaits supplémentaires?',
      Total_Video_MRC: 'Revenu mensuel Vidéo total',
      Professional_Install_Fee: 'Frais d\'installation professionnelle',
      Additional_Comments: 'Commentaires supplémentaires',
      Upload_Required_Files: 'Téléchargez les fichiers requis',
      view_please_indicate: 'Si les frais sont annulés, entrez 0,00'
    }
  };

  // step getters adjusted to new total steps = 13
  get isStep1() { return this.currentStep === 1; }
  get isStep2() { return this.currentStep === 2; }
  get isStep3() { return this.currentStep === 3; }
  get isStep4() { return this.currentStep === 4; }
  get isStep5() { return this.currentStep === 5; }
  get isStep6() { return this.currentStep === 6; }
  get isStep7() { return this.currentStep === 7; }
  get isStep8() { return this.currentStep === 8; }
  get isStep9() { return this.currentStep === 9; }
  get isStep10() { return this.currentStep === 10; }
  get isStep11() { return this.currentStep === 11; }
  get isStep12() { return this.currentStep === 12; }
  get isStep13() { return this.currentStep === 13; }

  get isFormVisible() { return !this.isSubmitted; }

  // Helper to get current language, defaulting to English
  get currentLang() {
    return this.formData.Preferred_Language__c === 'French' ? 'French' : 'English';
  }

  get isEnglish() {
    return this.currentLang === 'English';
  }

  get isFrench() {
    return this.currentLang === 'French';
  }

  get contactRoleOptions() {
    return this.contactRoleOptionsMap[this.currentLang];
  }

  get yesNoOptions() {
    return this.yesNoOptionsMap[this.currentLang];
  }

  get speedOptions() {
    return this.speedOptionsMap[this.currentLang];
  }

  get internetTermOptions() {
    return this.internetTermOptionsMap[this.currentLang];
  }

  get configurationOptions() {
    return this.configurationOptionsMap[this.currentLang];
  }

  get wifiTypeOptions() {
    return this.wifiTypeOptionsMap[this.currentLang];
  }

  get numberTypeOptions() {
    return this.numberTypeOptionsMap[this.currentLang];
  }

  // Dynamic button labels
  get nextLabel() {
    return this.currentLang === 'French' ? 'Suivant' : 'Next';
  }

  get previousLabel() {
    return this.currentLang === 'French' ? 'Précédent' : 'Previous';
  }

  get requiredFieldMessage() {
    return this.currentLang === 'French' ? 'Champ Obligatoire' : 'Complete this field.';
  }

  get submitbutton() {
    return this.currentLang === 'French' ? 'Soumettre' : 'Submit';
  }

  // Placeholder for all dropdowns
  get selectOptionPlaceholder() {
    return this.currentLang === 'French' ? 'Sélectionnez une option' : 'Select an option';
  }

  get removeButton() {
    return this.currentLang === 'French' ? 'Supprimer' : 'Remove';
  }

  get headerText() {
    return this.currentLang === 'French'
      ? 'Formulaire de vente B2B et porte-a-porte ON'
      : 'B2B-D2D Sales Form ON';
  }

  // Getters for each field label
  get repIdLabel() { return this.LABELS[this.currentLang].REP_ID; }
  get repNameLabel() { return this.LABELS[this.currentLang].REP_Name; }
  get repEmailLabel() { return this.LABELS[this.currentLang].REP_Email; }
  get businessNameLabel() { return this.LABELS[this.currentLang].Business_Name; }
  get businessPhoneLabel() { return this.LABELS[this.currentLang].Business_Phone; }
  get serviceAddressLabel() { return this.LABELS[this.currentLang].Service_Address; }
  get postalCodeLabel() { return this.LABELS[this.currentLang].Postal_Code; }
  get billingAddressLabel() { return this.LABELS[this.currentLang].Billing_Address; }
  get contactNameLabel() { return this.LABELS[this.currentLang].Contact_Name; }
  get contactRoleLabel() { return this.LABELS[this.currentLang].Contact_Role; }
  get contactPhoneLabel() { return this.LABELS[this.currentLang].Contact_Phone; }
  get contactEmailLabel() { return this.LABELS[this.currentLang].Contact_Email; }

  get internetSoldLabel() { return this.LABELS[this.currentLang].Internet_Sold; }
  get speedLabel() { return this.LABELS[this.currentLang].Speed; }
  get internetTermLabel() { return this.LABELS[this.currentLang].Internet_Term; }
  get configurationLabel() { return this.LABELS[this.currentLang].Configuration; }
  get wifiTypeLabel() { return this.LABELS[this.currentLang].Wi_Fi_Type; }
  get wifi6ExtendersLabel() { return this.LABELS[this.currentLang].WiFi_6_Extenders_Required; }
  get totalInternetMrrLabel() { return this.LABELS[this.currentLang].Total_Internet_MRR; }

  get voiceSoldLabel() { return this.LABELS[this.currentLang].Voice_Sold; }
  get numberOfLinesLabel() { return this.LABELS[this.currentLang].of_Lines; }
  get voiceTermLabel() { return this.LABELS[this.currentLang].Voice_Term; }
  get numberTypeLabel() { return this.LABELS[this.currentLang].Number_Type; }
  get totalVoiceMrrLabel() { return this.LABELS[this.currentLang].Total_Voice_MRR; }

  get videoSoldLabel() { return this.LABELS[this.currentLang].Video_Sold; }
  get packageLabel() { return this.LABELS[this.currentLang].Package; }
  get videoTermLabel() { return this.LABELS[this.currentLang].Video_Term; }
  get numberOfBoxesRequiredLabel() { return this.LABELS[this.currentLang].Number_of_Boxes_Required; }
  get additionalChannelsPackagesLabel() { return this.LABELS[this.currentLang].List_any_additional_channels_packages_to; }
  get totalVideoMrcLabel() { return this.LABELS[this.currentLang].Total_Video_MRC; }

  get professionalInstallFeeLabel() { return this.LABELS[this.currentLang].Professional_Install_Fee; }
  get additionalCommentsLabel() { return this.LABELS[this.currentLang].Additional_Comments; }
  get uploadRequiredFilesLabel() { return this.LABELS[this.currentLang].Upload_Required_Files; }
  get viewpleaseindicateLabel() { return this.LABELS[this.currentLang].view_please_indicate; }

  /* ======================
     Event handlers & logic
     ====================== */

  handleChange(event) {
    const field = event.target.dataset.field;
    if (field) {
      this.formData[field] = event.target.value;
    }
  }

  handleRadioChange(event) {
    // Generic handler for lightning-radio-group
    const field = event.target.dataset.field;
    const value = event.detail && event.detail.value ? event.detail.value : event.target.value;
    if (field) {
      this.formData[field] = value;
    }

    // If language changed, update UI texts
    if (field === 'Preferred_Language__c') {
      this.updateFileTexts();
    }
  }

  goNext() {
    const stepSelector = `div[data-step="${this.currentStep}"]`;
    const inputs = Array.from(
      this.template.querySelectorAll(
        `${stepSelector} lightning-input, ${stepSelector} lightning-combobox, ${stepSelector} lightning-radio-group, ${stepSelector} lightning-textarea`
      )
    );

    const allValid = inputs.reduce((validSoFar, inputCmp) => {
      if (inputCmp.required) {
        if (typeof inputCmp.reportValidity === 'function') {
          inputCmp.reportValidity();
        }
        if (typeof inputCmp.checkValidity === 'function') {
          return validSoFar && inputCmp.checkValidity();
        } else {
          const value = inputCmp.value;
          return validSoFar && (value !== undefined && value !== null && value !== '');
        }
      }
      return validSoFar;
    }, true);

    if (!allValid) {
      this.showToast('Error', this.currentLang === 'French' ? 'Veuillez remplir tous les champs requis sur cette page' : 'Please fill all required fields on this page', 'error');
      return;
    }

    // Conditional skips/jumps
    if (this.currentStep === 3) {
      if (this.formData.Internet_Sold__c === 'No') {
        this.currentStep = 7;
        window.scrollTo(0, 0);
        return;
      } else {
        this.currentStep = Math.min(13, this.currentStep + 1);
        window.scrollTo(0, 0);
        return;
      }
    }

    // Skip Page 5 if Configuration = "Basic - No Wi-Fi"
    if (this.currentStep === 4 && this.formData.Configuration__c === 'Basic - No Wi-Fi') {
      this.currentStep = 6; // Jump directly to Internet Revenue page
      window.scrollTo(0, 0);
      return;
    }

    if (this.currentStep === 7) {
      if (this.formData.Voice_Sold__c === 'No') {
        this.currentStep = 10;
        window.scrollTo(0, 0);
        return;
      } else {
        this.currentStep = Math.min(13, this.currentStep + 1);
        window.scrollTo(0, 0);
        return;
      }
    }

    if (this.currentStep === 10) {
      if (this.formData.Video_Sold__c === 'No') {
        this.currentStep = 13;
        window.scrollTo(0, 0);
        return;
      } else {
        this.currentStep = Math.min(13, this.currentStep + 1);
        window.scrollTo(0, 0);
        return;
      }
    }

    if (this.currentStep < 13) {
      this.currentStep++;
      window.scrollTo(0, 0);
    }
  }

  goPrevious() {
    if (this.currentStep > 1) {
      this.currentStep--;
      window.scrollTo(0, 0);
    }
  }

  handleFileSelection(event) {
    if (!event || !event.target || !event.target.files) return;
    Array.from(event.target.files).forEach((file) => {
      // Avoid duplicate file names in the pending list
      if (!this.filesToUpload.some((f) => f.name === file.name)) {
        this.filesToUpload = [...this.filesToUpload, file];
      }
    });
    // Update placeholder text count
    this.updateFileTexts();
  }

  removePendingFile(event) {
    const fileName = event.target.dataset.name;
    this.filesToUpload = this.filesToUpload.filter((f) => f.name !== fileName);
    this.updateFileTexts();
  }

  handleSubmit() {
    // Validate step 13 required fields
    const stepSelector = `div[data-step="13"]`;
    const inputs = Array.from(
      this.template.querySelectorAll(
        `${stepSelector} lightning-input, ${stepSelector} lightning-combobox, ${stepSelector} lightning-radio-group, ${stepSelector} lightning-textarea`
      )
    );

    const allValid = inputs.reduce((validSoFar, inputCmp) => {
      if (inputCmp.required) {
        if (typeof inputCmp.reportValidity === 'function') {
          inputCmp.reportValidity();
        }
        if (typeof inputCmp.checkValidity === 'function') {
          return validSoFar && inputCmp.checkValidity();
        } else {
          const value = inputCmp.value;
          return validSoFar && (value !== undefined && value !== null && value !== '');
        }
      }
      return validSoFar;
    }, true);

    if (!allValid) {
      this.showToast('Error', this.currentLang === 'French' ? 'Veuillez remplir tous les champs requis sur cette page' : 'Please fill all required fields on this page', 'error');
      return;
    }

    // Create lead
    createLead({ formData: this.formData })
      .then((leadId) => {
        // If there are files to upload, convert to base64 and upload
        if (this.filesToUpload && this.filesToUpload.length > 0) {
          const files = this.filesToUpload.map((file) => ({ fileName: file.name, base64Data: '', contentType: file.type }));
          Promise.all(this.filesToUpload.map((file) => this.convertToBase64(file)))
            .then((base64Files) => {
              files.forEach((f, idx) => (f.base64Data = base64Files[idx]));
              return uploadFiles({ leadId: leadId, files: files });
            })
            .then(() => {
              this.isSubmitted = true;
              const successMsg = this.currentLang === 'French' ? 'Prospect et fichiers téléchargés avec succès!' : 'Lead and files uploaded successfully!';
              this.showToast('Success', successMsg, 'success');
            })
            .catch((error) => {
              this.showToast('Error', error?.body?.message || error?.message || JSON.stringify(error), 'error');
            });
        } else {
          // No files, just mark submitted and show success toast
          this.isSubmitted = true;
          const msg = this.currentLang === 'French' ? 'Prospect créé avec succès!' : 'Lead created successfully!';
          this.showToast('Success', msg, 'success');
        }
      })
      .catch((error) => {
        this.showToast('Error', error?.body?.message || error?.message || JSON.stringify(error), 'error');
      });
  }

  connectedCallback() {
    // Set default language if not present
    if (!this.formData.Preferred_Language__c) {
      this.formData.Preferred_Language__c = 'English';
    }
    this.updateFileTexts();
  }

  // Sets button texts based on selected language
  updateFileTexts() {
    const lang = this.formData.Preferred_Language__c === 'French' ? 'French' : 'English';
    if (lang === 'French') {
      this.fileButtonText = 'Sélectionner les fichiers';
      this.filePlaceholderText = this.filesToUpload && this.filesToUpload.length > 0 ? `${this.filesToUpload.length} fichier(s) sélectionné(s)` : 'Aucun fichier sélectionné';
      this.removeButtonText = 'Supprimer';
    } else {
      this.fileButtonText = 'Choose Files';
      this.filePlaceholderText = this.filesToUpload && this.filesToUpload.length > 0 ? `${this.filesToUpload.length} file(s) chosen` : 'No file chosen';
      this.removeButtonText = 'Remove';
    }
  }

  triggerFileInput() {
    const input = this.template.querySelector('input[type="file"]');
    if (input) {
      input.click();
    }
  }

  convertToBase64(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => {
        const parts = reader.result.split(',');
        resolve(parts.length > 1 ? parts[1] : '');
      };
      reader.onerror = (error) => reject(error);
      reader.readAsDataURL(file);
    });
  }

  showToast(title, message, variant) {
    this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
  }
}