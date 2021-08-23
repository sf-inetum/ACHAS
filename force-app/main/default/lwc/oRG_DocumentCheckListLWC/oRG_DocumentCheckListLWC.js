import { LightningElement ,api, wire, track} from 'lwc';
import getDocumentList from '@salesforce/apex/ORG_DocumentCheckList.getDocumentList';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ORG_DocumentCheckListLWC extends LightningElement {
    draftValues = [];
    @api recordId;
    @track columns = [{
        label: 'NOMBRE',
        fieldName: 'TitleUrl',
        type: 'url',
        sortable: true,
        typeAttributes: {
            label: { 
                fieldName: 'Title' 
            },
            target : '_blank'
        }
    },
    {
        label: 'TIPO DE DOCUMENTO',
        fieldName: 'FileType',
        type: 'text',
        sortable: true
    },
    {
        label: 'PROPIETARIO',
        fieldName: 'Owner',
        type: 'text',
        sortable: true
    },
    {
        label: 'REVISADO',
        fieldName: 'ORG_Revisado__c',
        type: 'boolean',
        cellAttributes: { class: 'slds-text-heading_medium' },
        sortable: true,
        editable: true
    },
    ];

    @track error;
    @track docList ;
    refreshTable;
    @wire(getDocumentList, {objId: '$recordId'})
    wiredDocuments(result){
        this.refreshTable = result;
        if (result.data) {
            let baseUrl = 'https://'+location.host+'/';
            let tempDatos = [];
            result.data.forEach(dato => {
                let tempDato = {};
                tempDato.Id = dato.Id;
                tempDato.TitleUrl = baseUrl+dato.Id;
                tempDato.Title = dato.Title;
                tempDato.FileType = dato.FileType;
                tempDato.Owner = dato.Owner.Name;
                tempDato.ORG_Revisado__c = dato.ORG_Revisado__c;
                tempDatos.push(tempDato);
            });
            this.docList = tempDatos;
        } else if (result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading record',
                    message: 'error',
                    variant: 'error'
                })
            );
            this.data = [];
            this.error = result.error;
        }
    }

    handleSave(event) {

        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(docum => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Data updated',
                    variant: 'success'
                })
            );
            // Display fresh data in the datatable
            return refreshApex(this.refreshTable).then(() => {
                // Clear all draft values in the datatable
                this.draftValues = [];
            });
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading record',
                    message: 'error',
                    variant: 'error'
                })
            );
        });
    }

}