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

    /**
    * @name: mapContactIdToOpportunityAfterConversionTest() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Actualiza el campo "Nombre del contacto" con el Id del Contacto que se crea en la conversión del Lead
    */    
    @isTest 
    static void mapContactIdToOpportunityAfterConversionTest(){
        Lead newLead = ESACHS_FactoriaDatosTest.createNewLeadForConversion();
       
        //Lanzo la conversion del Lead:
        Test.startTest();
 		
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(newLead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        Test.stopTest();

        Lead leadAfterConversion = [SELECT Id, ConvertedOpportunityId, ConvertedContactId FROM Lead WHERE LastName = 'Name Centro Salud' ];
        Opportunity newOppAfterConversion = [SELECT Id, Nombre_del_contacto__c FROM Opportunity WHERE Id = :leadAfterConversion.ConvertedOpportunityId ];
        //Compruebo que el campo Nombre del contacto de la oportunidad coincide con el contacto dado de alta tras la conversión del Lead:
        System.assertEquals(leadAfterConversion.ConvertedContactId, newOppAfterConversion.Nombre_del_contacto__c);
    
    }
}