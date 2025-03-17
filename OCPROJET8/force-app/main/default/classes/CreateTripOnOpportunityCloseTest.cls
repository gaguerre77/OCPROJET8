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
public class CreateTripOnOpportunityCloseTest {

    @isTest
    static void testTripCreationOnOpportunityWin() {
        // Créez un compte pour l'opportunité
        Account account = new Account(Name = 'Test Account');
        insert account;

        // Créez une opportunité avec des dates valides
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = account.Id,
            CloseDate = Date.today(),
            StageName = 'Prospecting', // Initialement non gagnée
            Destination__c = 'Test Destination',
            Start_Date__c = Date.newInstance(2023, 12, 1),
            End_Date__c = Date.newInstance(2023, 12, 10),
            Number_of_Participants__c = 5,
            Amount = 1000
        );
        insert opp;

        // Mettez à jour l'opportunité comme gagnée
        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest();

        // Vérifiez qu'un voyage a été créé
        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(1, trips.size(), 'Un voyage devrait avoir été créé.');
    }

    @isTest
    static void testTripNotCreatedOnInvalidDates() {
        // Créez un compte pour l'opportunité
        Account account = new Account(Name = 'Test Account');
        insert account;

        // Créez une opportunité avec des dates invalides
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = account.Id,
            CloseDate = Date.today(),
            StageName = 'Prospecting', // Initialement non gagnée
            Destination__c = 'Test Destination',
            Start_Date__c = Date.newInstance(2023, 12, 10),
            End_Date__c = Date.newInstance(2023, 12, 1),
            Number_of_Participants__c = 5,
            Amount = 1000
        );
        insert opp;

        try {
            // Mettez à jour l'opportunité comme gagnée
            Test.startTest();
            opp.StageName = 'Closed Won';
            update opp;
            Test.stopTest();
            System.assert(false, 'Une erreur devrait avoir été levée pour les dates invalides.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Erreur : La date de fin du voyage doit être postérieure à la date de début.'), 'L\'erreur attendue n\'a pas été levée.');
        }
    }
}
