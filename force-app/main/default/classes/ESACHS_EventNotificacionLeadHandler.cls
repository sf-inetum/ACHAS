/*
* @description:  
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
public with sharing class ESACHS_EventNotificacionLeadHandler {

    /**
    * @name: postChatter() method
    * @author: Nuria Durán Rodríguez (INETUM)
    * @description: Crea una notificación de chatter a través de los campos que reciba del Platform Event
    */
    public static void postChatter(List<ESACHS_EventNotificacionProspecto__e> eventNotificationLeadLst){
        List<FeedItem> feedItemPostLst = new List<FeedItem>();
        for (ESACHS_EventNotificacionProspecto__e eventNotifLeadTmp :eventNotificationLeadLst ){
            FeedItem post = new FeedItem();
            post.ParentId = eventNotifLeadTmp.ESACHS_PostParentId__c;
            post.Body = eventNotifLeadTmp.ESACHS_PostBody__c;
            feedItemPostLst.add(post);
        }

        if (feedItemPostLst.size() > 0){
            insert feedItemPostLst;
        }
    } 
}