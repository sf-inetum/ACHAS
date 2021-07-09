/**********************************************************************************
* @author       Francisco Rodriguez Navarro - francisco.rodriguezn@inetum.com
* @date         01/07/2021
* @group        Action
* @description  Class invocalbe to flow for approval process
* @Revision
**********************************************************************************/

public with sharing class ORG_ApprovalProcessAction {

    public static string comentario = 'Auto aprobado por el proceso automático de 48h.';
    /** 
    * @creation date: 01/07/2021
    * @author: Francisco Rodriguez Navarro - francisco.rodriguezn@inetum.com
    * @description: método que aprueba el proceso de aprobación pendiente
    * @param listRecordId list de Id record para aprobar
    * @return void 
    * @exception: N/A
    * @throws: N/A.
    */
    @InvocableMethod
    public static void approvalRequest(List<String> listRecordId){
        List<ProcessInstanceWorkitem> workItems = [
            SELECT Id, ProcessInstanceId 
            FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId in :listRecordId 
          ];
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem workItem : workItems){
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setWorkitemId(workItem.Id);
          //Valid values are: Approve, Reject, or Removed. 
          //Only system administrators can specify Removed.
          req.setAction('Approve');
          req.setComments(comentario);
          requests.add(req);
        }
        Approval.ProcessResult[] processResults = Approval.process(requests); 
    }    
}