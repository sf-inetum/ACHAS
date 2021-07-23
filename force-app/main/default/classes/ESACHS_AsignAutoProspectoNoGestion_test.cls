/*
* @description: Clase Test para ESACHS_NotificacionCierreProspecto_sch
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@isTest
public class ESACHS_AsignAutoProspectoNoGestion_test {
    
   /**
    * @name: changeLeadOwner() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description:  Asigna a los 10 días automaticamente el Lead a ESACHS_Gerencia
    */ 
    static testMethod void changeLeadOwnerTest() {
        
        //Creo los leads
        List<Lead> leadLst = ESACHS_FactoriaDatosTest.createNewLeadCentroSalud(2);

        //Inserto los Leads para que salte la lógica del Schedule (se programa al insertar Leads):
        Test.startTest();
        insert leadLst;
        Test.stopTest();

        //Compruebo que el Owner ahora es ESACHS_Gerencia
        List<Lead> leadAfterFinishJobLst = [SELECT Id, OwnerId FROM Lead WHERE LastName LIKE 'Name Centro Salud%' ];
        Group queueGerencia = [SELECT Id FROM Group WHERE Type = :ESACHS_Constantes.QUEUE AND DeveloperName = :ESACHS_Constantes.ESACHS_GERENCIA LIMIT 1];
        for (Lead leadAfterFinishJob : leadAfterFinishJobLst){
            System.assertEquals(queueGerencia.Id, leadAfterFinishJob.OwnerId);
        }
    }
}