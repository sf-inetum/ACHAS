/*
* @description: 
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@isTest
public with sharing class ESACHS_FactoriaDatosTest {

    // Constantes
    public static final Id recordypeIdVentasESACHS = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(ESACHS_Constantes.ESACHS_VENTAS_RT).getRecordTypeId();
    
    /**
    * @name: createNewLeadCentroSalud() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Simula la creación de Leads desde el formulario Centro Salud
    */ 
    public static List<Lead> createNewLeadCentroSalud (Integer num){
        List<Lead> leadLst = new List<Lead>();
        for (Integer i=0; i<num; i++){
            Lead newLead = new Lead ( 
                LastName = 'Name Centro Salud'+i, RecordTypeId = recordypeIdVentasESACHS, Company = 'Test Company+i',
                Email = i+'test@gmail.com',
                Confirmar_Email__c = i+'test@gmail.com',
                RUT_Empresa__c = '19301163-2',//string.ValueOf(i+ 0582503)+'-2',
                Phone = string.ValueOf(603457498 + i),
                LeadSource = 'Web',
                ESACHS_ProductosServiciosSolicitados__c =ESACHS_Constantes.PRODUCTOS_CENTRO_SALUD );
            leadLst.add(newLead);           
        }
        return leadLst;
    }

    /**
    * @name: createNewLeadVSClargo() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Simula la creación de Leads desde el formulario VSC: Caso Selección VSC Largo
    */ 
    public static List<Lead> createNewLeadVSClargo (Integer num){
        List<Lead> leadLst = new List<Lead>();
        for (Integer i=0; i<num; i++){
            Lead newLead = new Lead ( 
                LastName = 'Name VSC Largo'+i, RecordTypeId = recordypeIdVentasESACHS, Company = 'Test Company Centro Salud+i',
                Email = i+'test@gmail.com',
                Confirmar_Email__c = i+'test@gmail.com',
                RUT_Empresa__c = '7241113-7',//string.ValueOf(i+0382503)+'-2',
                Phone = string.ValueOf(633057498+i),
                LeadSource = 'Web',
                ESACHS_ProductosServiciosSolicitados__c =ESACHS_Constantes.PRODUCTOS_VSC_LARGO );
            leadLst.add(newLead);           
        }
        return leadLst;
    }

    /**
    * @name: createNewLeadVSClargo() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Simula la creación de Leads desde el formulario VSC: Caso Selección VSC Corto
    */ 
    public static List<Lead> createNewLeadVSCcorto (Integer num){
        List<Lead> leadLst = new List<Lead>();
        for (Integer i=0; i<num; i++){
            Lead newLead = new Lead ( 
                LastName = 'Name VSC Corto'+i, RecordTypeId = recordypeIdVentasESACHS, Company = 'Test Company VSC Largo+i',
                Email = i+'test@gmail.com',
                Confirmar_Email__c = i+'test@gmail.com',
                RUT_Empresa__c = '24945207-6',//string.ValueOf(i+0482503)+'-2',
                Phone = string.ValueOf(633450498+i),
                LeadSource = 'Web',
                ESACHS_ProductosServiciosSolicitados__c =ESACHS_Constantes.PRODUCTOS_VSC_CORTO );
            leadLst.add(newLead);            
        }
        return leadLst;
    }

    /**
    * @name: createUserAdmin() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Simula la creación de un usuario con perfil Administrador
    */ 
    public static User createUserAdmin (){
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator' OR Name = 'Administrador del sistema']; 
        User userAdmin = new User(Alias = 'standt', Email='adminUserTestESACHS@testorg.com', 
                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='adminUserTestESACHS@testorg.com',
                    Title = 'Developer Senior', CompanyName = 'ACHS', FirstName = 'Admin Test');
        insert userAdmin ;
        return userAdmin;
    }

   /**
    * @name: createQueue() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Simula la creación de Leads desde el formulario Centro Salud
    */ 
    public static Group createQueue (){
        //Creo la cola
        Group newQueue = new Group(Name='Test Group', Type='Queue');
        insert newQueue;

        //Asigno a la cola un miembro:
        User userAdmin = createUserAdmin();
        System.runAs(userAdmin)
        {
            GroupMember groupMember = new GroupMember();
            groupMember.GroupId = newQueue.Id;
            groupMember.UserOrGroupId = userAdmin.Id;
            insert groupMember;      
        }


        System.runAs(userAdmin)
        {
           QueuesObject testQueue = new QueueSObject(QueueID = newQueue.id, SObjectType = 'Lead');
            insert testQueue;
        }
        return newQueue;
        
    }
}