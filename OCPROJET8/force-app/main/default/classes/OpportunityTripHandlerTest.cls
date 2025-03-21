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
private class OpportunityTripHandlerTest {
    @isTest static void testHandleAfterUpdate() {
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
        List<Trip__c> trips = [SELECT Id, Status__c, Destination__c, Start_Date__c, End_Date__c,
                                Number_of_Participants__c, Total_Cost__c, Account__c, Opportunity__c
                                FROM Trip__c WHERE Opportunity__c = :testOpp.Id];
        System.assertEquals(1, trips.size(), 'Un enregistrement Trip__c devrait être créé.');

        // Vérifier les valeurs du Trip__c créé
        Trip__c createdTrip = trips[0];
        System.assertEquals('Upcoming', createdTrip.Status__c);
        System.assertEquals(testOpp.Destination__c, createdTrip.Destination__c);
        System.assertEquals(testOpp.Start_Date__c, createdTrip.Start_Date__c);
        System.assertEquals(testOpp.End_Date__c, createdTrip.End_Date__c);
        System.assertEquals(testOpp.Number_of_Participants__c, createdTrip.Number_of_Participants__c);
        System.assertEquals(testOpp.Amount, createdTrip.Total_Cost__c);
        System.assertEquals(testAccount.Id, createdTrip.Account__c);
        System.assertEquals(testOpp.Id, createdTrip.Opportunity__c);
    }

    @isTest static void testHandleAfterUpdate_InvalidDates() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer une opportunité de test avec des dates invalides
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today(),
            StageName = 'Prospecting',
            AccountId = testAccount.Id,
            Destination__c = 'Test Destination',
            Start_Date__c = Date.today().addDays(5),
            End_Date__c = Date.today(),
            Number_of_Participants__c = 10,
            Amount = 5000
        );
        insert testOpp;

        // Mettre à jour l'opportunité pour la marquer comme gagnée
        testOpp.StageName = 'Closed Won';

        try {
            update testOpp;
            System.assert(false, 'Une exception aurait dû être levée.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Erreur : La date de fin du voyage doit être postérieure à la date de début.'), 'Le message d\'erreur est incorrect.');
        }
    }
}
