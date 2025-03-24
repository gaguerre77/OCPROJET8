public with sharing class OpportunityTripHandler {
    // Méthode pour gérer la création des enregistrements Trip__c
    public static void handleAfterUpdate(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap) {
        List<Trip__c> tripsToInsert = new List<Trip__c>();

        for (Opportunity opp : newOppList) {
            if (opp.IsWon && opp.IsWon != oldOppMap.get(opp.Id).IsWon) {
                Trip__c newTrip = new Trip__c(
                    Status__c = 'Upcoming',
                    Destination__c = opp.Destination__c,
                    Start_Date__c = opp.Start_Date__c,
                    End_Date__c = opp.End_Date__c,
                    Number_of_Participants__c = opp.Number_of_Participants__c,
                    Total_Cost__c = opp.Amount,
                    Account__c = opp.AccountId,
                    Opportunity__c = opp.Id
                );

                if (newTrip.End_Date__c > newTrip.Start_Date__c) {
                    tripsToInsert.add(newTrip);
                } else {
                    opp.addError('Erreur : La date de fin du voyage doit être postérieure à la date de début. Veuillez corriger les dates de l\'opportunité.');
                }
            }
        }

        if (!tripsToInsert.isEmpty()) {
            insert tripsToInsert;
        }
    }
}
