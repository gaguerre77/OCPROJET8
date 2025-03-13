trigger CreateTripOnOpportunityClose on Opportunity (after update) {
    // Liste pour stocker les nouveaux enregistrements Trip__c à insérer
    List<Trip__c> tripsToInsert = new List<Trip__c>();

    // Parcourir les opportunités mises à jour
    for (Opportunity opp : Trigger.new) {
        // Vérifier si l'opportunité est gagnée
        if (opp.IsWon && opp.IsWon != Trigger.oldMap.get(opp.Id).IsWon) {
            // Créer un nouvel enregistrement Trip__c
            Trip__c newTrip = new Trip__c(
                // Le champ Name sera automatiquement généré par Salesforce
                Status__c = 'Upcoming', // Statut par défaut
                Destination__c = opp.Destination__c, // Destination de l'opportunité
                Start_Date__c = opp.Start_Date__c, // Date de début de l'opportunité
                End_Date__c = opp.End_Date__c, // Date de fin de l'opportunité
                Number_of_Participants__c = opp.Number_of_Participants__c, // Nombre de participants
                Total_Cost__c = opp.Amount, // Coût total (montant de l'opportunité)
                Account__c = opp.AccountId, // Relation avec l'objet Account
                Opportunity__c = opp.Id // Relation avec l'objet Opportunity
            );

            // Vérifier la cohérence des dates avant d'ajouter le trip à la liste
            if (newTrip.End_Date__c > newTrip.Start_Date__c) {
                // Ajouter le nouvel enregistrement à la liste
                tripsToInsert.add(newTrip);
            } else {
                // Ajouter un message d'erreur sur l'opportunité
                opp.addError('Erreur : La date de fin du voyage doit être postérieure à la date de début. Veuillez corriger les dates de l\'opportunité.');
            }
        }
    }

    // Insérer les nouveaux enregistrements Trip__c dans la base de données
    if (!tripsToInsert.isEmpty()) {
        insert tripsToInsert;
    }
}
