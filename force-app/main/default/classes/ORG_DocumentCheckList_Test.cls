/*
* @description: Clase Test para ORG_DocumentCheckList
* @author: Antonio Rubio (INETUM)
* @version: 1.0 
*/
@isTest
public with sharing class ORG_DocumentCheckList_Test {
    
    /**
    * @name: testSetup() method
    * @author: Antonio Rubio (INETUM)
    * @description: Método para la creación del juego de datos del test.
    */
    @TestSetup
    static void testSetup(){
        Task tarea = new Task(Subject = 'test');
        insert tarea;
    }

    /**
    * @name: getDocumentListTest() method
    * @author: Antonio Rubio (INETUM)
    * @description: Consultamos el número de documentos adjuntos a un registro.
    */
    @isTest
    static void getDocumentListTest (){
        Task tarea = [Select id from Task Limit 1];
        Id idTarea = tarea.Id;
        Test.startTest();
        List<ContentVersion> documentos = ORG_DocumentCheckList.getDocumentList(idTarea);
        Test.stopTest();
        system.assertEquals(0, documentos.size());
    }
    /**
    * @name: getDocumentListSinOBjectTest() method
    * @author: Antonio Rubio (INETUM)
    * @description: Consultamos el número de documentos adjuntos a un registro.
    */
    @isTest
    static void getDocumentListSinOBjectTest (){
        Task tarea = [Select id from Task Limit 1];
        Id idTarea = tarea.Id;
        Test.startTest();
        List<ContentVersion> documentos = ORG_DocumentCheckList.getDocumentList(null);
        Test.stopTest();
        system.assertEquals(null, documentos);
    }
}