/*
* @description: Clase Test para ESACHS_EventNotificacionLeadHandler_test
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@isTest
public class ESACHS_EventNotificacionLeadHandler_test {

   /**
    * @name: postChatterTest() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Envia una notificación de advertencia mediante Chatter al propietario del prospecto si en un plazo de 5 días hábiles desde la creación del prospecto este no ha sido convertido.
    */ 
    static testMethod void postChatterTest() {
        //Lo inserto porque es contexto de trigger After Insert:
        //Recupero Usuario Administrador:
        User userAdmin = ESACHS_FactoriaDatosTest.createUserAdmin();
        //Creo dataset de Leads:
        List<Lead> leadLst = ESACHS_FactoriaDatosTest.createNewLeadCentroSalud(2);
        for (Lead leadTmp : leadLst){
            leadTmp.OwnerId = userAdmin.Id;
        }
       
        insert leadLst;    
        
        List<ESACHS_EventNotificacionProspecto__e> eventNotificationLeadLst = new List<ESACHS_EventNotificacionProspecto__e>();
    
        //Compruebo que inicialmente no hay post en chatter:
        List<FeedItem> postChatterLeadInit = [SELECT Id, ParentId FROM FeedItem LIMIT 200];
        System.assert(postChatterLeadInit.size() == 0);
        
        for (Lead leadTmp : leadLst){
            ESACHS_EventNotificacionProspecto__e eventNotificationLead = new ESACHS_EventNotificacionProspecto__e();
            eventNotificationLead.ESACHS_PostParentId__c = leadTmp.OwnerId;
            eventNotificationLead.ESACHS_PostBody__c = 'Test Event';
            eventNotificationLeadLst.add(eventNotificationLead);
        }

      
        Test.startTest();
        ESACHS_EventNotificacionLeadHandler.postChatter(eventNotificationLeadLst);
        Test.stopTest();
    

        //Compruebo que se han generado post en chatter:
        List<FeedItem> postChatterLead = [SELECT Id, ParentId FROM FeedItem LIMIT 200];
        System.assert(postChatterLead.size() >0);
        
    }
 
}