trigger leadTrigger on Lead (before insert, before update, after insert, after update) {
    String idEliminar = null;
    
    if(Trigger.isBefore){
        verificadorRUT.obtencionRUTContacto(trigger.new);
        verificadorRUT.obtencionRUTEmpresa(trigger.new);
        verificadorRUT.obtencionRUTReferidor(trigger.new);
        comunasUtils.gettingComunas(trigger.new);
        leadTriggerHandler.companiaIgualContacto(trigger.new);
        Trigger.new[0].idProspecto__c = Trigger.new[0].id;
        
        if(trigger.isInsert){
            /*duplicateHandler.datosProspectoExistenEnCuenta(trigger.new);
            duplicateHandler.marcarDuplicados(trigger.new);*/
            leadTriggerHandler.validarCuentaParalizadaExistente(trigger.new);
            leadTriggerHandler.validarOportunidadVigenteExistente(trigger.new);
            leadTriggerHandler.leadCreadoDistintoRutReferidor(trigger.new);
            
        }
        
        
    }
    //Proyecto ESACHS 
    //@author: Nuria Durán Rodríguez (INETUM)
    if (Trigger.isInsert && Trigger.isAfter){
        ESACHS_HandlerLead.retrieveProductsServicesRequested(Trigger.new);
        ESACHS_HandlerLead.manageLeadAfterInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){         
        EliminarContactoConvertido.eliminarContacto(Trigger.new, Trigger.oldmap);
        
        //Proyecto ESACHS 
    	//@author: Nuria Durán Rodríguez (INETUM)
        ESACHS_HandlerLead.submitForApprovalAuto(Trigger.new, Trigger.oldmap);
        
        // --- Conversion de Prospectos -----
        leadTriggerHandler.leadConvertAccount(trigger.new);                
        
    }
    

}