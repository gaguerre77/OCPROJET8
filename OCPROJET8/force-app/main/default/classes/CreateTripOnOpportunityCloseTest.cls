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
private class CreateTripOnOpportunityCloseTest {
    @isTest static void testTrigger() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer une opportunité de test
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today(),
            StageName = 'Prospecting',
            AccountId = testAccount.Id,
            Destination__c = 'Test Destination',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(5),
            Number_of_Participants__c = 10,
            Amount = 5000
        );
        insert testOpp;

        // Mettre à jour l'opportunité pour la marquer comme gagnée
        testOpp.StageName = 'Closed Won';
        update testOpp;

        // Vérifier qu'un enregistrement Trip__c a été créé
        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Opportunity__c = :testOpp.Id];
        System.assertEquals(1, trips.size(), 'Un enregistrement Trip__c devrait être créé.');
    }
}
