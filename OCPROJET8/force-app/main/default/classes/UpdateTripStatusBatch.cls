public without sharing class UpdateTripStatusBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Requête pour obtenir tous les voyages dont le statut est différent de "Cancelled"
        String query = 'SELECT Id, Start_Date__c, End_Date__c, Status__c FROM Trip__c WHERE Status__c != \'Cancelled\'';
        return Database.getQueryLocator(query);
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

        // Mettre à jour les enregistrements avec le nouveau statut
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
        // Logique à exécuter après le traitement de tous les lots
    }
}
