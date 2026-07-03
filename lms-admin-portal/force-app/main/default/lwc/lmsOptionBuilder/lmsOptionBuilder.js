import { LightningElement, api, track } from 'lwc';

export default class LmsOptionBuilder extends LightningElement {
    @api
    get correctAnswer() { return this._correctAnswer; }
    set correctAnswer(val) { this._correctAnswer = val; this.buildOptions(); }
    _correctAnswer = null;

    @api
    get optionA() { return this._a; } set optionA(v) { this._a = v; this.buildOptions(); } _a = '';
    @api
    get optionB() { return this._b; } set optionB(v) { this._b = v; this.buildOptions(); } _b = '';
    @api
    get optionC() { return this._c; } set optionC(v) { this._c = v; this.buildOptions(); } _c = '';
    @api
    get optionD() { return this._d; } set optionD(v) { this._d = v; this.buildOptions(); } _d = '';

    @track options = [];

    buildOptions() {
    const vals = {
        A: this._a,
        B: this._b,
        C: this._c,
        D: this._d
    };

    this.options = ['A', 'B', 'C', 'D'].map(k => ({
        key: k,
        value: vals[k] || '',
        isCorrect: this._correctAnswer === k,
        placeholder: `Option ${k}`,
        ariaLabel: `Mark option ${k} correct`
    }));
}

    connectedCallback() { this.buildOptions(); }

    handleCorrect(e) {
        this._correctAnswer = e.target.value;
        this.buildOptions();
        this.dispatchEvent(new CustomEvent('change', { detail: { field: 'Correct_Answer__c', value: this._correctAnswer } }));
    }

    handleText(e) {
        const key = e.target.dataset.key;
        const field = `Option_${key}__c`;
        this[`_${key.toLowerCase()}`] = e.target.value;
        this.buildOptions();
        this.dispatchEvent(new CustomEvent('change', { detail: { field, value: e.target.value } }));
    }
}
