import { LightningElement, track } from 'lwc';
import submitEnquiry from '@salesforce/apex/PublicEnquiryController.submitEnquiry';

const COUNTRY_OPTIONS = [
    { label: 'United Kingdom', value: 'UK' },
    { label: 'Republic of Ireland', value: 'Republic of Ireland' },
    { label: 'India', value: 'India' },
    { label: 'China', value: 'China' },
    { label: 'United States', value: 'USA' },
    { label: 'Other', value: 'Other' }
];

const LEVEL_OPTIONS = [
    { label: 'Undergraduate', value: 'UG' },
    { label: 'Postgraduate', value: 'PG' },
    { label: 'Other', value: 'Other' }
];

const PROGRAMME_OPTIONS = [
    { label: 'Engineering', value: 'Engineering' },
    { label: 'Business', value: 'Business' },
    { label: 'Sciences', value: 'Sciences' },
    { label: 'Arts', value: 'Arts' }
];

export default class EnquiryForm extends LightningElement {
    @track form = {
        enquirerName: '',
        enquirerEmail: '',
        enquirerPhone: '',
        country: '',
        countryOther: '',
        programmeLevel: '',
        programmeOfInterest: '',
        consentGiven: false,
        idempotencyKey: ''
    };

    isSubmitting = false;
    isSubmitted = false;
    enquiryNumber = '';
    errorMessage = '';

    countryOptions = COUNTRY_OPTIONS;
    levelOptions = LEVEL_OPTIONS;
    programmeOptions = PROGRAMME_OPTIONS;

    connectedCallback() {
        // Generate the idempotency key once per form load.
        // crypto.randomUUID is available in modern browsers; fallback for older.
        this.form.idempotencyKey = (typeof crypto !== 'undefined' && crypto.randomUUID)
            ? crypto.randomUUID()
            : this.fallbackUuid();
    }

    fallbackUuid() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
            const r = (Math.random() * 16) | 0;
            const v = c === 'x' ? r : (r & 0x3) | 0x8;
            return v.toString(16);
        });
    }

    get isCountryOther() {
        return this.form.country === 'Other';
    }

    handleChange(event) {
        const field = event.target.name;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;
        this.form = { ...this.form, [field]: value };
    }

    validate() {
        if (!this.form.enquirerName) return 'Please enter your full name.';
        if (!this.form.enquirerEmail) return 'Please enter your email address.';
        if (!this.form.country) return 'Please select your country.';
        if (this.form.country === 'Other' && !this.form.countryOther) return 'Please specify your country.';
        if (!this.form.programmeLevel) return 'Please select a programme level.';
        if (!this.form.consentGiven) return 'We need your explicit consent to process this enquiry.';
        return null;
    }

    async handleSubmit() {
        this.errorMessage = '';
        const localError = this.validate();
        if (localError) {
            this.errorMessage = localError;
            return;
        }

        this.isSubmitting = true;
        try {
            const result = await submitEnquiry({ formData: this.form });
            if (result && result.success) {
                this.enquiryNumber = result.enquiryNumber;
                this.isSubmitted = true;
            } else {
                this.errorMessage = (result && result.errorMessage)
                    ? result.errorMessage
                    : 'Something went wrong. Please try again.';
            }
        } catch (e) {
            this.errorMessage = (e && e.body && e.body.message) ? e.body.message : 'Network error. Please try again.';
        } finally {
            this.isSubmitting = false;
        }
    }

    handleReset() {
        // Re-mount semantics: regenerate idempotency key, clear form
        this.form = {
            enquirerName: '',
            enquirerEmail: '',
            enquirerPhone: '',
            country: '',
            countryOther: '',
            programmeLevel: '',
            programmeOfInterest: '',
            consentGiven: false,
            idempotencyKey: this.fallbackUuid()
        };
        this.connectedCallback();
        this.isSubmitted = false;
        this.enquiryNumber = '';
        this.errorMessage = '';
    }
}