import { LightningElement, track } from 'lwc';
import invokeBatch from '@salesforce/apex/BatchInvoker.invokeBatch';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BatchButton extends LightningElement {
    handleRunBatch() {
        invokeBatch()
            .then(() => {
                this.showToast('Success', 'Batch job has been initiated!', 'success');
            })
            .catch(error => {
                this.showToast('Error', 'Error invoking batch: ' + error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}
