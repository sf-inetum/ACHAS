/*
* @description: Clase Test de ESACHS_HandlerLead
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@IsTest
public class ESACHS_HandlerLead_test {

    /**
    * @name: setupData() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: DataSet Inicial
    */    
    @TestSetup
    static void setupData(){
    

    }

    /**
    * @name: retrieveProductsServicesRequestedTestCentroSalud() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: DataSet Inicial
    */    
    @isTest 
    static void retrieveProductsServicesRequestedTestCentroSalud(){
        List<Lead> newLeadLst = ESACHS_FactoriaDatosTest.createNewLeadCentroSalud(2);

        List<ESACHS_solicitudProductosLead__c> solicitudProductosLeadLst = [SELECT Id, ESACHS_Lead__c FROM ESACHS_SolicitudProductosLead__c  LIMIT 200];
        System.debug ('tamaño1: '+solicitudProductosLeadLst.size());

        Test.startTest();
        insert newLeadLst; 
        Test.stopTest();

        List<Lead> leadAfterInsertLst = [SELECT Id, ESACHS_TipoDeServicio__c FROM Lead WHERE LastName LIKE 'Name Centro Salud%' ];
        List<Id> leadIdLst = new List<Id>();
        for (Lead leadTmp : leadAfterInsertLst){
            leadIdLst.add(leadTmp.Id);
        }
        List<ESACHS_solicitudProductosLead__c> solicitudProductosLstAfterLeadInsert = [SELECT Id, ESACHS_Lead__c FROM ESACHS_SolicitudProductosLead__c WHERE ESACHS_Lead__c IN :leadIdLst];
        System.debug ('tamaño2: '+solicitudProductosLstAfterLeadInsert.size());
        for (Lead leadTmp : leadAfterInsertLst){
            System.assertEquals('Centro de Salud', leadTmp.ESACHS_TipoDeServicio__c);
        }
        System.assert(solicitudProductosLstAfterLeadInsert.size() > solicitudProductosLeadLst.size());

    }

    /**
    * @name: retrieveProductsServicesRequestedTestVSClargo() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: DataSet Inicial
    */    
    @isTest 
    static void retrieveProductsServicesRequestedTestVSClargo(){
        List<Lead> newLeadLst = ESACHS_FactoriaDatosTest.createNewLeadVSClargo(2);

        List<ESACHS_solicitudProductosLead__c> solicitudProductosLeadLst = [SELECT Id, ESACHS_Lead__c FROM ESACHS_SolicitudProductosLead__c LIMIT 200];
        System.debug ('tamaño1: '+solicitudProductosLeadLst.size());        
        
        Test.startTest();
        insert newLeadLst; 
        Test.stopTest();
        List<Lead> leadAfterInsertLst = [SELECT Id, ESACHS_TipoDeServicio__c FROM Lead WHERE LastName LIKE 'Name VSC Largo%' ];
        List<Id> leadIdLst = new List<Id>();
        for (Lead leadTmp : leadAfterInsertLst){
            leadIdLst.add(leadTmp.Id);
        }
        List<ESACHS_solicitudProductosLead__c> solicitudProductosLstAfterLeadInsert = [SELECT Id, ESACHS_Lead__c FROM ESACHS_solicitudProductosLead__c WHERE ESACHS_Lead__c IN :leadIdLst];
        System.debug ('tamaño2: '+solicitudProductosLstAfterLeadInsert.size());
        for (Lead leadTmp : leadAfterInsertLst){
            System.assertEquals('VSC Largo', leadTmp.ESACHS_TipoDeServicio__c);
        }
        System.assert(solicitudProductosLstAfterLeadInsert.size() > solicitudProductosLeadLst.size());
    }

    /**
    * @name: retrieveProductsServicesRequestedTestVSCcorto() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: DataSet Inicial
    */    
    @isTest 
    static void retrieveProductsServicesRequestedTestVSCcorto(){
        List<Lead> newLeadLst = ESACHS_FactoriaDatosTest.createNewLeadVSCcorto(2);
 
        List<ESACHS_solicitudProductosLead__c> solicitudProductosLeadLst = [SELECT Id, ESACHS_Lead__c FROM ESACHS_SolicitudProductosLead__c LIMIT 200];
        System.debug ('tamaño1: '+solicitudProductosLeadLst.size());

        Test.startTest();
        insert newLeadLst; 
        Test.stopTest();

        List<Lead> leadAfterInsertLst = [SELECT Id, ESACHS_TipoDeServicio__c FROM Lead WHERE LastName LIKE 'Name VSC Corto%' ];
        List<Id> leadIdLst = new List<Id>();
        for (Lead leadTmp : leadAfterInsertLst){
            leadIdLst.add(leadTmp.Id);
        }
        List<ESACHS_solicitudProductosLead__c> solicitudProductosLstAfterLeadInsert = [SELECT Id, ESACHS_Lead__c FROM ESACHS_SolicitudProductosLead__c WHERE ESACHS_Lead__c IN :leadIdLst];
        System.debug ('tamaño2: '+solicitudProductosLstAfterLeadInsert.size());
        for (Lead leadTmp : leadAfterInsertLst){
            System.assertEquals('VSC Corto', leadTmp.ESACHS_TipoDeServicio__c);
        }
        System.assert(solicitudProductosLstAfterLeadInsert.size() > solicitudProductosLeadLst.size());
    }
}