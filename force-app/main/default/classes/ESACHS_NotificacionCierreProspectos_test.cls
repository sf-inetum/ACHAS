/*
* @description: Clase Test para ESACHS_NotificacionCierreProspecto_sch
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@isTest
public class ESACHS_NotificacionCierreProspectos_test {
    
    
   /**
    * @name: sendPostChatterTest() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Envia una notificación de advertencia mediante Chatter al propietario del prospecto si en un plazo de 5 días hábiles desde la creación del prospecto este no ha sido convertido.
    */ 
    static testMethod void sendPostChatterTest() {
        //Recupero Usuario Administrador:
        User userAdmin = ESACHS_FactoriaDatosTest.createUserAdmin();
        //Creo dataset de Leads: 
        List<Lead> leadLst = ESACHS_FactoriaDatosTest.createNewLeadCentroSalud(2);
        for (Lead leadTmp : leadLst){
            leadTmp.OwnerId = userAdmin.Id;
        }

        //Compruebo que inicialmente no hay post en chatter:
        List<FeedItem> postChatterLeadInit = [SELECT Id, ParentId FROM FeedItem LIMIT 200];
        System.assert(postChatterLeadInit.size() == 0);
        
        Test.startTest();
        //Inserto los Leads para que se programe el schedule:
        insert leadLst;    
        //Test.getEventBus().deliver();
        Test.stopTest();
    
        //Compruebo que se han generado post en chatter:
        List<FeedItem> postChatterLead = [SELECT Id, ParentId FROM FeedItem LIMIT 200];
        System.assert(postChatterLead.size() > 0);
        
    }
   /**
    * @name: sendPostChatterOwnerTest() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Envia una notificación de advertencia mediante Chatter a todos los miembros de la cola
    * si en un plazo de 5 días hábiles desde la creación del prospecto este no ha sido convertido.
    */ 
    static testMethod void sendPostChatterOwnerTest() {
        
        //Recupero Cola:
        Group queueGroup = ESACHS_FactoriaDatosTest.createQueue();
            
        //Creo dataset de Leads: 
        List<Lead> leadLst = ESACHS_FactoriaDatosTest.createNewLeadCentroSalud(2);
        for (Lead leadTmp : leadLst){
            leadTmp.OwnerId = queueGroup.Id;
        }

        //Compruebo que inicialmente no hay post en chatter:
        List<FeedItem> postChatterLeadInit = [SELECT Id, ParentId FROM FeedItem LIMIT 200];
        System.assert(postChatterLeadInit.size() == 0);
            
     
        Test.startTest();
        //Inserto los Leads para que se programe el schedule
        insert leadLst;                    
		//Test.getEventBus().deliver();
        Test.stopTest();
              
        //Compruebo que se han generado post en chatter:
        List<FeedItem> postChatterLead = [SELECT Id, ParentId FROM FeedItem LIMIT 200];
        System.assert(postChatterLead.size() > 0);
        
    }
}