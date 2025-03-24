public without sharing class UpdateTripStatusBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all Trip__c records
        return Database.getQueryLocator([SELECT Id, Start_Date__c, End_Date__c, Status__c FROM Trip__c]);
    }

    public void execute(Database.BatchableContext BC, List<Trip__c> scope) {
        Date today = Date.today();

        for (Trip__c trip : scope) {
            if (today < trip.Start_Date__c) {
                trip.Status__c = 'Upcoming';
            } else if (today >= trip.Start_Date__c && today <= trip.End_Date__c) {
                trip.Status__c = 'Ongoing';
            } else if (today > trip.End_Date__c) {
                trip.Status__c = 'Ended';
            }
        }

        // Update the records with the new status
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
        // Logic to execute after all batches are processed
    }
}
