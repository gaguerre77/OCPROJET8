public without sharing class CancelTripsBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Requête pour obtenir tous les voyages avec moins de 10 participants et qui ne sont pas déjà annulés
        String query = 'SELECT Id, Status__c, Number_of_Participants__c FROM Trip__c WHERE Number_of_Participants__c < 10 AND Status__c != \'Cancelled\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Trip__c> scope) {
        // Mettre à jour le statut des voyages à "Cancelled"
        for (Trip__c trip : scope) {
            trip.Status__c = 'Cancelled';
        }
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
        // Logique à exécuter après le traitement de tous les lots
        System.debug('Tous les voyages avec moins de 10 participants ont été annulés.');
    }
}

