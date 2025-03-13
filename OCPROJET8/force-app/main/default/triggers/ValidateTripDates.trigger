trigger ValidateTripDates on Trip__c (before insert, before update) {
    // Parcourir les enregistrements Trip__c à insérer ou mettre à jour
    for (Trip__c trip : Trigger.new) {
        // Vérifier si la date de fin est postérieure à la date de début
        if (trip.End_Date__c <= trip.Start_Date__c) {
            // Ajouter un message d'erreur personnalisé pour l'utilisateur
            trip.addError('Erreur : La date de fin doit être postérieure à la date de début. Veuillez corriger les dates et réessayer.');
        }
    }
}
