trigger CreateTripOnOpportunityClose on Opportunity (after update) {
    // Appel de la méthode statique de la classe OpportunityTripHandler
    OpportunityTripHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
}
