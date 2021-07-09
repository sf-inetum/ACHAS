/*
* @description: Clase Test para ESACHS_AutoApproveLead_sch
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@isTest
public class ESACHS_AutoApproveLead_test {
 
    /**
    * @name: setupData() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: DataSet Inicial
    */    
    @TestSetup
    static void setupData(){
        //Recupero Usuario Administrador:
        User userAdmin = ESACHS_FactoriaDatosTest.createUserAdmin();
        //Creo dataset de Leads:
        List<Lead> leadLst = ESACHS_FactoriaDatosTest.createNewLeadCentroSalud(2);
        for (Lead leadTmp : leadLst){
            leadTmp.OwnerId = userAdmin.Id;
        }   
        insert leadLst;

    }
   /**
    * @name: submitForApprovalTest() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description:  Envía a aprobación automaticamente trancurridas 48 horas (sin recibir actualizaciones) test
    */ 
    static testMethod void submitForApprovalTest() {

        List<Lead> leadToUpdateLst = [SELECT Id, ESACHS_TipoDeServicio__c, Status, ESACHS_AprobacionRequerida__c FROM Lead WHERE LastName LIKE 'Name Centro Salud%' LIMIT 200];
        
        //Actualizo la lista de Leads para que entren en el proceso de aprobación
        for (Lead leadTmp : leadToUpdateLst){
            //Actualizo el STATUS para que cumpla con los criterios para entrar en el proceso de aprobación
            leadTmp.Status = ESACHS_Constantes.ESACHS_VALIDACIONINFORMACION;
        }   
        update leadToUpdateLst;
        
        //Creo petición de approval process:
        list<Approval.ProcessSubmitRequest> requestLst = new List<Approval.ProcessSubmitRequest>();
        Approval.ProcessResult[] processResults = null;
        for (Lead leadTmpForApproval : leadToUpdateLst){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval ');
            req.setObjectId(leadTmpForApproval.id);
            requestLst.add(req);
        }            
            
        Test.startTest();
        //Envío los registros a aprobación
        processResults = Approval.process(requestLst);
        Test.stopTest();

        //Compruebo que el status de los leads updateados ahora es "Calificado", lo que asegura que se haya aprobado el Approval Process
        List<Lead> afterApproveLeadLst = [SELECT Id, ESACHS_TipoDeServicio__c, Status, ESACHS_AprobacionRequerida__c FROM Lead WHERE LastName LIKE 'Name Centro Salud%' ];
        for(Lead leadApproveTmp : afterApproveLeadLst){
            System.assertEquals(ESACHS_Constantes.ESACHS_CALIFICADO, leadApproveTmp.Status);
        }
    }

}