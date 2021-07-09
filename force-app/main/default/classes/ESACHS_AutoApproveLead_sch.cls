/*
* @description: Si en un plazo de 48 para su calificación, si no hay comentarios se asumirá su factibilidad
* para que lo gestione o asigne a un nuevo usuario
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
* @sharing: Without sharing porque se ejecuta en contexto usuario
*/
global class ESACHS_AutoApproveLead_sch implements Schedulable {

    List<Lead> leadToApproveLst = new List<Lead>();
    List<Id> leadToApproveIdLst = new List<Id>();

    //Constructor
    public ESACHS_AutoApproveLead_sch (List<Lead> leadLst, List<Id> leadIdLst){
        leadToApproveLst = leadLst;
        leadToApproveIdLst = leadIdLst;
    }
    
    /**
    * @name: execute() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Método execute del schedule
    */ 
    global void execute(SchedulableContext SC) {

        submitForApproval(leadToApproveLst, leadToApproveIdLst);
        Id jobId = SC.getTriggerId();
        finish(jobId);
         
    }

    /**
    * @name: finish() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Método finish del schedule para que el proceso solo se lance una vez
    */ 
    private void finish(Id jobIdToAbort)
    {
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        List<CronTrigger> triggerList = [ SELECT Id FROM CronTrigger WHERE Id = :jobIdToAbort];
        for (CronTrigger t : triggerList) {
            //then use the active job id and abort it
            System.abortJob(t.Id);
        }   
   
    }

    /**
    * @name: submitForApproval() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Método que aprueba el proceso de aprobación pendiente a las 48 horas
    */ 

    public static void submitForApproval(List<Lead> leadsForApproveLst, List<Id> leadsForApproveIdLst){
        List<Id> leadIdLst = new List<Id>();

        //Mapa para comprobar el estado tras 48 horas en el Lead:   
        Map<Id,Lead> leadActualMap = new Map<Id,Lead>([SELECT Id, Status FROM Lead WHERE Id IN :leadsForApproveIdLst]);
        for (Lead leadTmp : leadsForApproveLst){
            Lead leadStatusActual = leadActualMap.get(leadTmp.Id);
            //Compruebo que el Lead Status Actual sigue siendo factibilidad ya que entonces necesitaría aún ser aprobado. 
            if (leadStatusActual.Status == ESACHS_Constantes.ESACHS_FACTIBILIDAD){
                leadIdLst.add(leadTmp.Id);
            }
        }
        if (leadIdLst.size() > 0){
            ORG_ApprovalProcessAction.approvalRequest(leadIdLst);
        }       
    }
    
 }