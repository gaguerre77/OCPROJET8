trigger ValidateTripDates on Trip__c (before insert, before update) {
    // Appeler la méthode du handler pour valider les dates
    ValidateTripDatesHandler.validateTripDates(Trigger.new);
}
