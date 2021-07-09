/*
* @description:  Gatille una notificación de advertencia mediante Chatter al propietario del prospecto 
*                si en un plazo de 5 días hábiles desde la creación del prospecto este no ha sido convertido
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
* @sharing: Without sharing porque se ejecuta en contexto usuario
*/
global class ESACHS_NotificacionCierreProspecto_sch implements Schedulable {

    List<Lead> leadsToSendPost = new List<Lead>();
    List<Id> leadsIdToSendPost = new List<Id>();

    //Constructor
    public ESACHS_NotificacionCierreProspecto_sch (List<Lead> ownerLeadLst, List<Id> ownerLeadIdLst){
        leadsToSendPost = ownerLeadLst;
        leadsIdToSendPost = ownerLeadIdLst;
    }
    
    /**
    * @name: execute() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Método execute del schedule
    */ 
    global void execute(SchedulableContext SC) {

        sendPostChatter(leadsToSendPost, leadsIdToSendPost);
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
        List<CronTrigger> triggerList = [ SELECT Id FROM CronTrigger WHERE Id = :jobIdToAbort];//CronJobDetail.Name LIKE 'ESACHS_NotificacionCierreProspecto%'];
        for (CronTrigger t : triggerList) {
            //then use the active job id and abort it
            System.abortJob(t.Id);
        }   
   
    }

    /**
    * @name: sendPostChatter() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Envia una notificación de advertencia mediante Chatter al propietario del prospecto si en un plazo de 5 días hábiles desde la creación del prospecto este no ha sido convertido.
    */ 

    public static void sendPostChatter(List<Lead> leadsLst, List<Id> leadIdLst ){
        
        //Lista con los eventos a publicar:
        List<ESACHS_EventNotificacionProspecto__e> eventNotificationLeadLst = new List<ESACHS_EventNotificacionProspecto__e>();
        
        //Mapa para comprobar el estado que tiene el lead actualmente (puede que en esos 5 días cambie):
        Map<Id,Lead> leadActualMap = new Map<Id,Lead>([SELECT Id, Status, OwnerId, Owner.Name, Owner.Type, ESACHS_TipoDeServicio__c, Company FROM Lead WHERE Id IN :leadIdLst]);
        
        List<Id> ownerIdLst = new List<Id>();
        //Recupero una Lista con las Id de los Owner de Leads, si son una cola:
        for(Lead leadTmp : leadsLst){
            Lead leadActual = leadActualMap.get(leadTmp.Id);
            if (leadActual.Status != ESACHS_Constantes.STATUS_CONVERTIDO && leadActual.Status != ESACHS_Constantes.STATUS_DESCARTADO ){
                if (leadActual.Owner.Type == ESACHS_Constantes.QUEUE){
                    System.debug('ESACHS: El owner Actual del Lead es una cola');
                    ownerIdLst.add(leadActual.OwnerId);
                }   
            }
        }

        //Recupero las colas:
        List<Id> queueIdLst = new List<Id>();
        List<Id> userQueueMemberIdLst = new List<Id>();
        //Recupero las Colas:
        List<Group> queueOwnerLeadLst = [SELECT Id FROM Group WHERE Type = :ESACHS_Constantes.QUEUE AND Id IN :ownerIdLst];
        System.debug ('Cola ESACHS: '+queueOwnerLeadLst);
        //Recupero las Ids de las colas:
        for (Group queueOwnerLead : queueOwnerLeadLst){
            queueIdLst.add(queueOwnerLead.Id);
        }
        //Mapa Id cola - Miembros de la cola:
        Map<Id, List<GroupMember>> queueGroupMembersMap = new Map<Id, List<GroupMember>>();
            
        //Recupero a los usuarios dentro de la cola:
        List<GroupMember> groupMemebersQueueLst = [SELECT UserOrGroupId, GroupId FROM GroupMember where GroupId IN :queueIdLst];
        
        //Monto el mapa Id cola y lista de miembros:
        for (GroupMember groupMemebersQueue : groupMemebersQueueLst ){
            userQueueMemberIdLst.add(groupMemebersQueue.UserOrGroupId);
            List<GroupMember> groupMemeberToAddLst = new List<GroupMember>();
            if (queueGroupMembersMap.containsKey(groupMemebersQueue.GroupId)){
                groupMemeberToAddLst = queueGroupMembersMap.get(groupMemebersQueue.GroupId);
            }
            groupMemeberToAddLst.add(groupMemebersQueue);
            queueGroupMembersMap.put(groupMemebersQueue.GroupId, groupMemeberToAddLst);
        }
        //Este mapa lo creo para poder recuperar el nombre del usuario al que se debe enviar la notificación:
         Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE Id IN :userQueueMemberIdLst]);
 
        //Necesito volver a hacer el bucle para que el mensaje se envie también a los owner que no sean colas:
        for(Lead leadTmp : leadsLst){
            Lead leadActual = leadActualMap.get(leadTmp.Id);
            if (leadActual.Status != ESACHS_Constantes.STATUS_CONVERTIDO && leadActual.Status != ESACHS_Constantes.STATUS_DESCARTADO ){
                System.debug('Owner Lead Actual: '+ leadActual.OwnerId);
                //Si el Owner es la cola entonces envío la notificación a todos los miembros:
                if (leadActual.Owner.Type == ESACHS_Constantes.QUEUE){
                    if (queueGroupMembersMap.containsKey(leadActual.OwnerId)){
                        //Para cada cola, recorro los miembros y recupero la información del usuario ya que el Id User = UserGroupId
                        for (GroupMember queueMemebers :queueGroupMembersMap.get(leadActual.OwnerId)){
                            // Recupero la informacion asociada a ese usuario:
                            User userInfo = userMap.get(queueMemebers.UserOrGroupId);
                            //Creo Platform Event para que se publique el post con el usuario "Automated Process" y salte la notificación
                            ESACHS_EventNotificacionProspecto__e eventNotificationLead = new ESACHS_EventNotificacionProspecto__e();
                            eventNotificationLead.ESACHS_PostParentId__c = userInfo.Id;
                            eventNotificationLead.ESACHS_PostBody__c = 'Estimado(a) '+ userInfo.Name + '. ' + 'El prospecto relacionado al proyecto '+ 
                            leadActual.ESACHS_TipoDeServicio__c + '-' + leadActual.Company +  ' será descartado en un plazo de 5 días hábiles si no se convierte a una oportunidad.' + 
                            ' Para gestionar el prospecto, haga clic aquí: ' + URL.getSalesforceBaseUrl().toExternalForm()+ '/'+leadTmp.Id;
                            eventNotificationLeadLst.add(eventNotificationLead);
                        }
                    }
                }
                else {
                    //Creo Platform Event para que se publique el post con el usuario "Automated Process" y salte la notificación
                    ESACHS_EventNotificacionProspecto__e eventNotificationLead = new ESACHS_EventNotificacionProspecto__e();
                    eventNotificationLead.ESACHS_PostParentId__c = leadActual.OwnerId;
                    eventNotificationLead.ESACHS_PostBody__c = 'Estimado(a) '+ leadActual.Owner.Name + '. ' + 'El prospecto relacionado al proyecto '+ 
                    leadActual.ESACHS_TipoDeServicio__c + '-' + leadActual.Company +  ' será descartado en un plazo de 5 días hábiles si no se convierte a una oportunidad.' + 
                    ' Para gestionar el prospecto, haga clic aquí: ' + URL.getSalesforceBaseUrl().toExternalForm()+ '/'+leadTmp.Id;
                    eventNotificationLeadLst.add(eventNotificationLead);
                }
            }
 
        }
        
        if (eventNotificationLeadLst.size() > 0){
            List<Database.SaveResult> resultLst = EventBus.publish(eventNotificationLeadLst);
            for (Database.SaveResult result : resultLst){
                if (result.isSuccess()) {
                System.debug('ESACHS Successfully published event Notificacion Prospecto');
                } else {
                    for(Database.Error err : result.getErrors()) {
                        System.debug('ESACHS Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage());
                    }
                }
            }
        }
        
    }
    
 }