import { LightningElement, api } from 'lwc';

export default class EnquiryConfirmation extends LightningElement {
    @api enquiryNumber;

    handleReset() {
        // Notify parent to reset to a fresh form (also re-generates idempotency key)
        this.dispatchEvent(new CustomEvent('reset'));
    }
}
