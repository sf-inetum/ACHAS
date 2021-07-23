/*
* @description: This class its the main test of ORG_UtilFlow
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
@isTest
public class ORG_UtilFlow_test {

    /**
    * @name: initialData() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Simula la creación de Leads desde el formulario Centro Salud
    */ 
    @TestSetup
    static void initialData(){       
        List<Lead> newLeadTest = ESACHS_FactoriaDatosTest.createNewLeadCentroSalud(1);
        insert newLeadTest;
    }
    
    /**
    * @name: testReturnObjectName() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Recupera el nombre del objeto
    */ 
    @isTest
    public static void testReturnObjectName(){
        Lead leadTest = [SELECT Id, Name FROM Lead WHERE LastName LIKE 'Name Centro Salud%' LIMIT 1];
        List<String> idList = new List<String>();
        idList.add(leadTest.Id);

        test.startTest();
        List<String> results = ORG_UtilFlow.returnObjectName(idList);
        test.stopTest();

        System.assertEquals('Lead', results[0]);
    }
}