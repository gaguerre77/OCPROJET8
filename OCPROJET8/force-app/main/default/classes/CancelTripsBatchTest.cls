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
public class CancelTripsBatchTest {

    @testSetup
    static void setup() {
        // Créez des données de test pour les voyages
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(Name = 'Trip 1', Status__c = 'Upcoming', Number_of_Participants__c = 5),
            new Trip__c(Name = 'Trip 2', Status__c = 'Upcoming', Number_of_Participants__c = 15),
            new Trip__c(Name = 'Trip 3', Status__c = 'Cancelled', Number_of_Participants__c = 8)
        };
        insert trips;
    }

    @isTest
    static void testCancelTripsBatch() {
        // Exécutez le job batch
        Test.startTest();
        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Vérifiez que les voyages avec moins de 10 participants sont annulés
        List<Trip__c> trips = [SELECT Id, Status__c, Number_of_Participants__c FROM Trip__c];
        for (Trip__c trip : trips) {
            if (trip.Number_of_Participants__c < 10 && trip.Status__c != 'Cancelled') {
                System.assert(false, 'Le voyage avec moins de 10 participants n\'a pas été annulé.');
            }
        }
    }
}
