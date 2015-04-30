public with sharing class oppRelatedList {
// Private reference to the record loaded by the standard controller... (the contact
    // being viewed)
    // 
    // 
    // 
    public Paginate paginater {get;set;}
    public List<OpportunityContactRole> genericList{get;set;}
    public List<List<OpportunityContactRole>> fullGenericList{get;set;}
    private Contact currentRecord;
 
    public oppRelatedList(ApexPages.StandardController controller){
        //Get the data we need to paginate
        this.currentRecord = (Contact)controller.getRecord();
        List<OpportunityContactRole> resultsList = populateData();
         
        //Set the page size
        Integer pageSize = 7;
         
        //Create a new instance of Paginate passing in the overall size of
        //the list of data and the page size you want
        this.paginater = new Paginate(resultsList.size(), pageSize);
 
        //These lists hold the data
        this.fullGenericList = new List<List<OpportunityContactRole>>();
        this.genericList = new List<OpportunityContactRole>();
         
        //Break out the full list into a list of lists
        if(resultsList.size() > 0){
            List<OpportunityContactRole> tempCC = new List<OpportunityContactRole>();        
            Integer i = 0;
            for(OpportunityContactRole cc : resultsList){
                tempCC.add(cc);
                i++;
                if(i == pageSize){
                    this.fullGenericList.add(tempCC);
                    tempCC = new List<OpportunityContactRole>();
                    i = 0;
                }
            }
            if(!tempCC.isEmpty()){
                this.fullGenericList.add(tempCC);
            }
             
            //Gets the correct list of data to show on the page
            this.genericList = this.fullGenericList.get(this.paginater.index);
        }
    }
 
    public PageReference previousPage(){
        this.paginater.decrement();
        return changeData();
    }
     
    public PageReference nextPage(){
        this.paginater.increment();
        return changeData();
    }
 
    public PageReference updatePage(){
        this.paginater.updateNumbers();
        return changeData();
    }
     
    public PageReference changeData(){
        this.genericList = this.fullGenericList.get(this.paginater.index);
        return null;
    }
     
    public List<OpportunityContactRole> populateData(){ 	
        List<OpportunityContactRole> ocr = [select OpportunityId, Opportunity.Name, Opportunity.StageName, Opportunity.CampaignId, 
               Opportunity.Amount, Opportunity.AccountId, Opportunity.CloseDate,
               Opportunity.npe01__Amount_Outstanding__c, Role, isPrimary 
               from OpportunityContactRole where ContactId = :currentRecord.Id 
              ORDER BY Opportunity.CreatedDate DESC];
        
        return ocr;
    }
     
    
    

    // NEW CODE
    // Standard Set Controllers are system-provided components for dealing with sets of
    // records easily. They're known as Standard List Controllers in the Visualforce
    // documentation as they can be utilised directly by Visualforce pages through the
    // use of the recordSetVar parameter in <apex:page> tags
    
    
    
    
}