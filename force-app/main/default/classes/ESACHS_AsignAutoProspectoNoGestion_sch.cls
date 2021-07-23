/*
* @description:  Si han transcurrido 10 días desde la creación de un prospecto tipo de registro "Ventas ESACHS" 
* y este aún no es convertido o descartado el sistema debe asignar automáticamente el prospecto al perfil "ESACHS - Gerencia" 
* para que lo gestione o asigne a un nuevo usuario
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
* @sharing: Without sharing porque se ejecuta en contexto usuario
*/
global class ESACHS_AsignAutoProspectoNoGestion_sch implements Schedulable {

    List<Lead> leadsToChangeOwnerLst = new List<Lead>();
    List<Id> leadsIdToChangeOwnerLst = new List<Id>();

    //Constructor
    public ESACHS_AsignAutoProspectoNoGestion_sch (List<Lead> ownerLeadLst, List<Id> ownerIdLeadLst ){
        leadsToChangeOwnerLst = ownerLeadLst;
        leadsIdToChangeOwnerLst = ownerIdLeadLst;
    }
    
    /**
    * @name: execute() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Método execute del schedule
    */ 
    global void execute(SchedulableContext SC) {

        changeLeadOwner(leadsToChangeOwnerLst, leadsIdToChangeOwnerLst);
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
    * @name: changeLeadOwner() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Asigna a los 10 días automáticamente el Lead a ESACHS_Gerencia
    */ 

    public static void changeLeadOwner(List<Lead> leadsLst, List<Id> leadIdLst){

        //Recupero el Id de la Cola ESACHS - Gerencia
        Group queueGerencia = [SELECT Id FROM Group WHERE Type = :ESACHS_Constantes.QUEUE AND DeveloperName = :ESACHS_Constantes.ESACHS_GERENCIA LIMIT 1];
        List<Lead> leadToUpdateOwnerLst = new List<Lead>();

        //Mapa para comprobar el estado que tiene el lead a los 5 días:
        Map<Id,Lead> leadActualMap = new Map<Id,Lead>([SELECT Id, Status FROM Lead WHERE Id IN :leadIdLst]);
        for(Lead leadTmp : leadsLst){
            Lead leadActual = leadActualMap.get(leadTmp.Id);
            if (leadActual.Status != ESACHS_Constantes.STATUS_CONVERTIDO && leadActual.Status != ESACHS_Constantes.STATUS_DESCARTADO ){
                Lead leadToUpdate = new Lead(Id = leadTmp.Id);
                leadToUpdate.OwnerId = queueGerencia.Id;
                leadToUpdateOwnerLst.add(leadToUpdate);
        
            }
 
        }
        if (leadToUpdateOwnerLst.size() > 0){
            update leadToUpdateOwnerLst;
        }
        
    }
    
 }