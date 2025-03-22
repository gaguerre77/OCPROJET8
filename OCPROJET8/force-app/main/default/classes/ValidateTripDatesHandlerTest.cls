/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ValidateTripDatesHandlerTest {
    @isTest static void testValidateTripDates() {
        // Créer une liste d'enregistrements Trip__c avec des dates invalides
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addDays(-1)
            )
        };

        // Appeler la méthode du handler directement
        Test.startTest();
        ValidateTripDatesHandler.validateTripDates(trips);
        Test.stopTest();

        // Vérifier que l'erreur a été ajoutée à l'enregistrement
        System.assert(trips[0].hasErrors(), 'L\'enregistrement devrait avoir une erreur pour des dates invalides.');

        // Créer une liste d'enregistrements Trip__c avec des dates valides
        List<Trip__c> validTrips = new List<Trip__c>{
            new Trip__c(
                Start_Date__c = Date.today(),
                End_Date__c = Date.today().addDays(1)
            )
        };

        // Appeler la méthode du handler directement
        ValidateTripDatesHandler.validateTripDates(validTrips);

        // Vérifier qu'aucune erreur n'a été ajoutée
        System.assert(!validTrips[0].hasErrors(), 'Aucune erreur ne devrait être présente pour des dates valides.');
    }
}
