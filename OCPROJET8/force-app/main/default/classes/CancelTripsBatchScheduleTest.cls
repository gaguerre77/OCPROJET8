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
@IsTest
private class CancelTripsBatchScheduleTest {

    @IsTest
    static void testScheduleBatch() {
        // Create test Trip__c records with different participant counts
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(Number_of_Participants__c = 5, Status__c = 'Upcoming'),
            new Trip__c(Number_of_Participants__c = 15, Status__c = 'Ongoing'),
            new Trip__c(Number_of_Participants__c = 8, Status__c = 'Ended')
        };
        insert trips;

        // Start the test context
        Test.startTest();

        // Call the scheduleBatch method to execute the batch
        CancelTripsBatchSchedule.scheduleBatch();

        // Stop the test context
        Test.stopTest();

        // Query the trips again to check for updates, including Number_of_Participants__c
        trips = [SELECT Id, Status__c, Number_of_Participants__c FROM Trip__c];

        // Verify that the trips with less than 10 participants are cancelled
        for (Trip__c trip : trips) {
            if (trip.Number_of_Participants__c < 10) {
                System.assertEquals('Cancelled', trip.Status__c);
            } else {
                System.assertNotEquals('Cancelled', trip.Status__c);
            }
        }
    }
}
