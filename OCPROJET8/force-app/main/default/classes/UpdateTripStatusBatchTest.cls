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
private class UpdateTripStatusBatchTest {

    @IsTest
    static void testUpdateTripStatusBatch() {
        // Create test Trip__c records with different date ranges
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(Start_Date__c = Date.today().addDays(1), End_Date__c = Date.today().addDays(2), Status__c = 'Upcoming'),
            new Trip__c(Start_Date__c = Date.today().addDays(-1), End_Date__c = Date.today().addDays(1), Status__c = 'Ongoing'),
            new Trip__c(Start_Date__c = Date.today().addDays(-3), End_Date__c = Date.today().addDays(-1), Status__c = 'Ended')
        };
        insert trips;

        // Execute the batch
        Test.startTest();
        UpdateTripStatusBatch batch = new UpdateTripStatusBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify the statuses are updated correctly
        trips = [SELECT Id, Status__c FROM Trip__c];
        System.assertEquals('Upcoming', trips[0].Status__c);
        System.assertEquals('Ongoing', trips[1].Status__c);
        System.assertEquals('Ended', trips[2].Status__c);
    }
}
