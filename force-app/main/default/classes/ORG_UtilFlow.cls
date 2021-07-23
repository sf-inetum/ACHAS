/*
* @description: This class its the Util Flow Class to add funcionalities to Salesforce Flow
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
public class ORG_UtilFlow {

    /**
    * @name: returnObjectName() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Recupera el nombre del objeto.
    */ 
    @InvocableMethod(label='GetObjectName')
    public static List<String> returnObjectName(List<String> recordIdStrings){
        List<String> objectNames = new List<String>();

        if (recordIdStrings[0] != ''){
            Id recordId = Id.valueOf(recordIdStrings[0]);
            String objectName = recordId.getSobjectType().getDescribe().getName();
            objectNames.add(recordId.getSobjectType().getDescribe().getName());
        } else {
            objectNames.add('');
        }

        return objectNames;
    }
}