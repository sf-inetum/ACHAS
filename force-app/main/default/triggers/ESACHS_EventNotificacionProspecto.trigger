/*
* @description:  
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
trigger ESACHS_EventNotificacionProspecto on ESACHS_EventNotificacionProspecto__e (after insert) {
    system.debug('ESACHS Entro en evento Notificación Prospecto');
    if (Trigger.isInsert && Trigger.isAfter) {
        ESACHS_EventNotificacionLeadHandler.postChatter(Trigger.new);
    } 
}