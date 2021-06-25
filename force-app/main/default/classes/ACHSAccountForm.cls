public with sharing class ACHSAccountForm {
    @AuraEnabled
    public static boolean getMDTpermission(string rtIdAcc, string inUserId) {
        boolean rBool = true;

        system.debug('-- ACHSAccountForm.getMDTpermission -- ENTRO --');

        id userId = userinfo.getUserid();
        if (inUserId != null) {
            userId = inUserId;
        }

        RecordType vRt;

        try {
            // Busqueda de perfil
            User vUser = [
                SELECT id, name, profileId, profile.name
                FROM user
                WHERE id = :userId
            ];
            system.debug(
                'ACHSAccountForm -- vUser:' +
                vUser +
                ', RecordTypeID:' +
                rtIdAcc
            );

            if (rtIdAcc == null) {
                // se busca el recordtype estandar por el perfil
                rtIdAcc = getRTdefault();
                system.debug(
                    'ACHSAccountForm -- default RecordTypeID:' + rtIdAcc
                );
            }

            //Busqueda Recordtype Name
            list<RecordType> lRt = [
                SELECT id, name, developername
                FROM recordtype
                WHERE id = :rtIdAcc
                LIMIT 1
            ];
            if (!lRt.isEmpty()) {
                vRt = lRt[0];
            }
            system.debug('ACHSAccountForm -- lRt:' + lRt + ', vRt:' + vRt);

            if (vUser.profile.name != null && vRt.name != null) {
                //Busqueda metadata
                Permiso_Objeto_RT__mdt[] vObj = [
                    SELECT
                        Id,
                        DeveloperName,
                        Label,
                        Perfil__c,
                        Objeto__c,
                        Record_Type_Name__c,
                        Crear__c,
                        Activo__c
                    FROM Permiso_Objeto_RT__mdt
                    WHERE
                        Perfil__c = :vUser.profile.name
                        AND Objeto__c = 'Account'
                        AND Record_Type_Name__c = :vRt.developername
                        AND Activo__c = TRUE
                    LIMIT 1
                ];

                system.debug('ACHSAccountForm -- Busqueda Metadata:' + vObj);

                if (vObj.size() > 0) {
                    if (vObj[0].crear__c == 'Denegar') {
                        //No puede Crear el Objeto
                        rBool = false;
                    } else {
                        rBool = true;
                    }
                }
            }
        } catch (Exception e) {
            System.debug(
                'Error:' +
                e.getMessage() +
                ' StackTrace[' +
                e.getStackTraceString() +
                '] Line:[' +
                e.getLineNumber() +
                ']'
            );
        }
        return rBool;
    }

    @AuraEnabled
    public static string getRTdefault() {
        //find all Account record types
        List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Account.RecordTypeInfos;
        Id defaultRecordTypeId;

        system.debug('infos:' + infos);
        //check each one
        for (Schema.RecordTypeInfo info : infos) {
            if (info.DefaultRecordTypeMapping) {
                defaultRecordTypeId = info.RecordTypeId;

                //here is the default Opportunity RecordType Id for the current user
                System.debug(
                    'ACHSAccountForm.getRTdefault default:' +
                    defaultRecordTypeId +
                    ', Name:' +
                    info.name
                );
            }
        }

        return defaultRecordTypeId;
    }
    @AuraEnabled
    public static List<RecordType> getRecordTypeAccount() {
        List<RecordType> lRt = new List<RecordType>();

        //find all Account record types
        List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Account.RecordTypeInfos;

        //check each one
        for (Schema.RecordTypeInfo info : infos) {
            lRt.add(new recordType(id = info.RecordTypeId, name = info.name));
        }

        return lRt;
    }
    @AuraEnabled
    public static List<Map<String, String>> getAccountRTs() {
        //Obtiene los Recordtype de Cuentas
        List<Schema.RecordTypeInfo> RT = Schema.SObjectType.Account.RecordTypeInfos;
        List<Map<String, String>> rtInfo = new List<Map<String, String>>();
        for (Schema.RecordTypeInfo rti : RT) {
            if (rti.isActive() && rti.isAvailable() && !rti.isMaster()) {
                // Solo los activos y los disponibles por el Perfil
                rtInfo.add(
                    new Map<String, String>{
                        'value' => rti.getRecordTypeId(),
                        'label' => rti.getName(),
                        'default' => String.valueOf(
                            rti.DefaultRecordTypeMapping
                        )
                    }
                );
            }
        }
        return rtInfo;
    }
}
