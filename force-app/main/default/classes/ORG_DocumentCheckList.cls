/*
* @description: Controller para la creación de datatable donde se muestran los documentos adjuntos a un registro
* @author: Antonio Rubio (INETUM)
* @version: 1.0 
*/
public with sharing class ORG_DocumentCheckList {
        
    /**
    * @name: getDocumentList() method
    * @author: Antonio Rubio (INETUM)
    * @description: Obtiene los documentos adjuntos a un registro
    */
    @AuraEnabled(cacheable=true)
        public static List<ContentVersion> getDocumentList(Id objId) {
        system.debug('objectId: ' + objId);

        if (objId != null){
            List<ContentDocumentLink> documentList = [SELECT Id, LinkedEntityId, ContentDocumentId,  Visibility, IsDeleted, ShareType,
            ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :objId];
            system.debug('documentList: ' + documentList);

       
            List<Id> idDocumentos = new List<Id>();
            String idDoc = null;
            for (ContentDocumentLink cdl: documentList){

                id identificador = cdl.ContentDocumentId;
                idDocumentos.add(identificador);
            }

            List<ContentDocument> contentDocument = [Select id, LatestPublishedVersionId from ContentDocument where id IN:idDocumentos];
            system.debug('ContentDocument: ' + contentDocument);

            List<Id> idContentVersion = new List<Id>();
            for (contentDocument cd: contentDocument){
                id identificador = cd.LatestPublishedVersionId;
                idContentVersion.add(identificador);
            }

            List<Sobject> contentVersionList = [SELECT id, Title, Owner.name, FileType, ORG_Revisado__c from ContentVersion where id IN:idContentVersion];
            system.debug('contentVersionList: ' + contentVersionList);

            return contentVersionList;  
        }
        return null;     
    }
}