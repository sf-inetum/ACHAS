/*
* @description: Handler del trigger de Lead
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
public with sharing class ESACHS_HandlerLead {
    
    /**
    * @name: retrieveProductsServicesRequested() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Deserialize Products in JSON 
    */ 
    public static void retrieveProductsServicesRequested(List<Lead> newLeadLst){
        Map<Id,String> productosServiciosToLeadMap =  new Map<Id, String>();
        List<ProductServicesWrapper> productServicesSerializeLst = new List<ProductServicesWrapper>();
        Map<Id, List<ProductServicesWrapper>> productosServiciosToLeadParseMap =  new Map<Id, List<ProductServicesWrapper>>();

        //Lista de Solicitud Productos a insertar:
        List<ESACHS_SolicitudProductosLead__c> productValueLst = new List<ESACHS_SolicitudProductosLead__c>();

        //Recupero RT VENTA ESACHS:
        Id recordypeIdVentasESACHS = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(ESACHS_Constantes.ESACHS_VENTAS_RT).getRecordTypeId();
        
        //Solo recupero aquellos Lead que tienen el record Type de Ventas ESACHS, que vienen de formulario WEB y que además no tienen
        // el campo JSON vacío.
        for(Lead leadTmp : newLeadLst){
            if (leadTmp.RecordTypeId != null && leadTmp.RecordTypeId == recordypeIdVentasESACHS && 
            leadTmp.ESACHS_ProductosServiciosSolicitados__c != null && leadTmp.LeadSource == ESACHS_Constantes.LEAD_SOURCE_WEB){
                //Relleno mapa con Key: Id Lead y valor: String JSON (bulk)
                productosServiciosToLeadMap.put(leadTmp.Id, leadTmp.ESACHS_ProductosServiciosSolicitados__c);
            }

        }

        // Relleno mapa con Key: Id Lead y valor: Lista de objetos de tipo ProductServicesWrapper (ya el JSON deserializado, devuelve una lista de Objetos
        // wrapper con producto y valor rellenos)
        for (Id idLeadTmp : productosServiciosToLeadMap.keySet()){
            String jsonStringTmp = productosServiciosToLeadMap.get(idLeadTmp);
            System.debug ('serialize Json: '+jsonStringTmp);
            productServicesSerializeLst = (List<ProductServicesWrapper>)JSON.deserialize(jsonStringTmp, List<ProductServicesWrapper>.class);
            System.debug ('deserialize Json: '+productServicesSerializeLst);
            //Monto mapa con la lista serializada obj - producto, valor
            productosServiciosToLeadParseMap.put(idLeadTmp, productServicesSerializeLst);
        }
        

        // Recorro el Mapa con la lista de productos y valor asociada a cada lead y para cada elemento creo un registro nuevo de ESACHS_solicitudProductosLead__c
        for (Id idLeadTmp : productosServiciosToLeadParseMap.keySet()){
            List<ProductServicesWrapper> productServiceLst = productosServiciosToLeadParseMap.get(idLeadTmp);
            for (ProductServicesWrapper productServiceTmp : productServiceLst ){
                //Solo será necesario crear los registros para aquellos donde el usuario ingrese un valor:
                if (productServiceTmp.valor != '' && productServiceTmp.valor != 'false'){
                    ESACHS_SolicitudProductosLead__c solicitudProducto = new ESACHS_SolicitudProductosLead__c(/*Name = '',*/
                                                                                                            ESACHS_NombreProductoServicio__c = productServiceTmp.producto,
                                                                                                            ESACHS_ProductoServicioSolicitado__c = productServiceTmp.valor,
                                                                                                            ESACHS_Lead__c = idLeadTmp,
                                                                                                            ESACHS_TipoServicio__c = productServiceTmp.tipo);
                    productValueLst.add(solicitudProducto);
                }
            }
        }

        if (productValueLst.size() > 0){
            insert productValueLst;
        }

        //Lista de Leads a rellenar tipo de servicio
        List<Lead> leadsToUpdateLst = new List<Lead>();
        //Recorro el Mapa con la lista de productos y valor asociada a cada lead y para cada elemento verifico el "tipo" que viene relleno, para
        //rellenar el campo Tipo Servicio correctamente:
        for (Id idLeadTmp : productosServiciosToLeadParseMap.keySet()){
            Lead leadToUpdate = new Lead (Id = idLeadTmp);
            List<ProductServicesWrapper> productServiceLst = productosServiciosToLeadParseMap.get(idLeadTmp);
            Boolean alertVSClargo = false;
            Boolean alertVSCcorto = false;
            for (ProductServicesWrapper productServiceTmp : productServiceLst ){
                //Si el tipo de servicio es Centro Salud, no hace fakta seguir recorriendo el resto de productos (puesto que sabemos que viene del
                //formulario centro de salud y todos serán del mismo tipo)
                if (productServiceTmp.tipo == ESACHS_Constantes.CENTRO_SALUD){
                    leadToUpdate.ESACHS_TipoDeServicio__c = ESACHS_Constantes.CENTRO_SALUD;
                    break;
                }
                //Si el tipo es VSC largo y el valor no viene vacio o como unchecked, pongo la alerta de VSC largo a true
                else if(productServiceTmp.tipo == ESACHS_Constantes.VSC_LARGO && (productServiceTmp.valor != '' && productServiceTmp.valor != 'false' )){ 
                    alertVSClargo = true;
                }
                //Si el tipo es VSC corto y el valor no viene vacio o como unchecked, pongo la alerta de VSC corto a true
                else if (productServiceTmp.tipo == ESACHS_Constantes.VSC_CORTO && (productServiceTmp.valor != '' && productServiceTmp.valor != 'false')){
                    alertVSCcorto = true; 
                }              
            }

            //Con que uno de los productos sea del tipo VSC largo, updateo a Tipo de Servicio VSC largo
            if (alertVSClargo == true){
                leadToUpdate.ESACHS_TipoDeServicio__c = ESACHS_Constantes.VSC_LARGO;
            }
            //Si no hay productos VSC largo (todos los marcados son del tipo VSC corto) updateo a Tipo de Servicio VSC corto
            else if (alertVSCcorto == true){
                leadToUpdate.ESACHS_TipoDeServicio__c = ESACHS_Constantes.VSC_CORTO;
            }
            leadsToUpdateLst.add(leadToUpdate);
        }

        if (leadsToUpdateLst.size() > 0){
            update leadsToUpdateLst;
        } 

    }

    /**
    * @name: manageLeadAfterInsert() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Envía notificación a los 5 días si el prospecto no ha sido convertido, cambia el owner si pasan 5 días más (10 en total)
    */ 
    public static void manageLeadAfterInsert(List<Lead> newLeadLst){
        //Solo recupero aquellos Lead que tienen el record Type de Ventas ESACHS, que vienen de formulario WEB y que además no tienen
        // el campo JSON vacío.
        Id recordypeIdVentasESACHS = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(ESACHS_Constantes.ESACHS_VENTAS_RT).getRecordTypeId();
        List<Datetime> createdDateLeadLst = new List<Datetime>();
        List<Lead> ownerLeadLst = new List<Lead>();
        List<Id> ownerLeadIdLst = new List<Id>();
        for(Lead leadTmp : newLeadLst){
            if (leadTmp.RecordTypeId != null && leadTmp.RecordTypeId == recordypeIdVentasESACHS && 
            leadTmp.Status != ESACHS_Constantes.STATUS_CONVERTIDO){
                createdDateLeadLst.add(leadTmp.CreatedDate);
                ownerLeadLst.add(leadTmp);
                ownerLeadIdLst.add(leadTmp.Id);             
            }
        }

        if(ownerLeadLst.size() > 0){

            //Selecciono solo la primera fecha porque todos los registros dentro de la misma transacción tendrán la misma fecha de creación
            System.debug('createdDateLstInit: '+createdDateLeadLst[0]);
            String fireDateTime5 = createTargetDate(createdDateLeadLst[0], 5);
            String fireDateTime10 = createTargetDate(createdDateLeadLst[0], 10);
                
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //ESTO ES PARA PROBAR + 1 MINUTO
            /*
            String hour = String.valueOf(Datetime.now().hour());
            String min = String.valueOf(Datetime.now().minute() +1); 
            String ss = String.valueOf(Datetime.now().second());
            
            //parse to cron expression
            String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
            */
            //ESTO ES PARA PROBAR + 1 MINUTO
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////

            // Si en un plazo de 5 días hábiles desde la creación del prospecto este no ha sido convertido:
            ESACHS_NotificacionCierreProspecto_sch notificacionCierreSch = new ESACHS_NotificacionCierreProspecto_sch(ownerLeadLst, ownerLeadIdLst); 
            System.schedule('ESACHS_NotificacionCierreProspecto ' + String.valueOf(Datetime.now()),fireDateTime5 /*nextFireTime*/, notificacionCierreSch);
            
            //Si han transcurrido 10 días desde la creación de un prospecto tipo de registro "Ventas ESACHS" y este aún no es convertido
            // o descartado el sistema debe asignar automáticamente el prospecto al perfil "ESACHS - Gerencia" para que lo gestione o asigne 
            //a un nuevo usuario
            ESACHS_AsignAutoProspectoNoGestion_sch asignacionAutoSch = new ESACHS_AsignAutoProspectoNoGestion_sch(ownerLeadLst, ownerLeadIdLst); 
            System.schedule('ESACHS_AsignacionAutoProspectoNoGestion ' + String.valueOf(Datetime.now()), fireDateTime10 /*nextFireTime*/, asignacionAutoSch);
        }

    }

    /**
    * @name: submitForApprovalAuto() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Aprueba el proceso de aprobación pendiente a las 48 horas
    */ 
    public static void submitForApprovalAuto(List<Lead> leadLst, Map<Id,Lead> leadOldMap){
        List<Lead> leadToApproveLst = new List<Lead>();
        List<Id> leadToApproveIdLst = new List<Id>();
        List<Datetime> lastUpdateDateLst = new List<Datetime>();
        for (Lead leadTmp : leadLst){
            //Obtengo el valor del campo aprobación requerida antes del update:
            Lead oldLead = leadOldMap.get(leadTmp.Id);
            System.debug('Campo Aprobación requerida Old: '+oldLead.ESACHS_AprobacionRequerida__c);
            System.debug('Campo Aprobación requerida New: '+leadTmp.ESACHS_AprobacionRequerida__c);
            if( (oldLead.ESACHS_AprobacionRequerida__c != leadTmp.ESACHS_AprobacionRequerida__c) && leadTmp.ESACHS_AprobacionRequerida__c == true ){
                leadToApproveLst.add(leadTmp);
                leadToApproveIdLst.add(leadTmp.Id);
                lastUpdateDateLst.add(leadTmp.LastModifiedDate);
            }
        }
        if(leadToApproveLst.size() > 0){
            System.debug('lastUpdateDateLst: '+lastUpdateDateLst[0]);
            //A las 48 horas (2 días hábiles):
            String fireDateTime2 = createTargetDate(lastUpdateDateLst[0], 2);
                
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //ESTO ES PARA PROBAR + 1 MINUTO
            /* 
            String hour = String.valueOf(Datetime.now().hour());
            String min = String.valueOf(Datetime.now().minute() +1); 
            String ss = String.valueOf(Datetime.now().second());
            
            //parse to cron expression
            String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
           /*/
            //ESTO ES PARA PROBAR + 1 MINUTO
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////

            // Si en un plazo de 48 desde inicio etapa factibilidad no se actualiza se aprueba automáticamente el proceso
            ESACHS_AutoApproveLead_sch autoApproveLeadSch = new ESACHS_AutoApproveLead_sch(leadToApproveLst, leadToApproveIdLst); 
            System.schedule('ESACHS_AutoApproveLead ' + String.valueOf(Datetime.now()),fireDateTime2 /*nextFireTime*/, autoApproveLeadSch);
        }
    }

    // FUNCION AUXILIAR:
    /**
    * @name: createTargetDate() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Calculo de la fecha en la que se tienen que disparar los schedule teniendo en cuenta los días hábiles
    */ 
    public static String createTargetDate(Datetime dateInit, Integer daysToAdd){
        //Sumo los días hábiles a la fecha de creación:
        DateTime dateTarget = ORG_CalculateBusinessDays.add(dateInit, daysToAdd);
        
        String hour = String.valueOf(dateTarget.hour()); 
        String min = String.valueOf(dateTarget.minute() ); 
        String ss = String.valueOf(dateTarget.second());
        String day = String.valueOf(dateTarget.day());
        String month = String.valueOf(dateTarget.month());


        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + day + ' ' + month + ' ?';
        System.debug ('CRON: '+ nextFireTime);

        return nextFireTime;
    }


    // WRAPPER PARA TRATAR EL JSON RECIBIDO DEL WEB TO LEAD
    /*
    * @description: Wrapper class
    * @author: Nuria Durán Rodríguez (INETUM)
    * @version: 1.0 
    */
    public class ProductServicesWrapper
    {
        public String tipo {get;set;}
        public String producto {get;set;}
        public String valor {get;set;}
        
        ProductServicesWrapper() {
        	tipo = '';
            producto = '';
       		valor = '';
   		}
   }     
    
        
    
}