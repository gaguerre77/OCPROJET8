public class ValidateTripDatesHandler {
    // Méthode pour valider les dates des enregistrements Trip__c
    public static void validateTripDates(List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            if (trip.End_Date__c <= trip.Start_Date__c) {
                trip.addError('Erreur : La date de fin doit être postérieure à la date de début. Veuillez corriger les dates et réessayer.');
            }
        }
    }
}
