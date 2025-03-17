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
public class ValidateTripDatesTest {

    @isTest
    static void testValidDates() {
        // Créez un voyage avec des dates valides
        Trip__c validTrip = new Trip__c(
            Name = 'Valid Trip',
            Start_Date__c = Date.newInstance(2023, 12, 1),
            End_Date__c = Date.newInstance(2023, 12, 10)
        );

        // Insérez le voyage
        Test.startTest();
        insert validTrip;
        Test.stopTest();

        // Vérifiez que le voyage a été inséré sans erreur
        System.assertNotEquals(null, validTrip.Id, 'Le voyage avec des dates valides n\'a pas été inséré.');
    }

    @isTest
    static void testInvalidDates() {
        // Créez un voyage avec des dates invalides
        Trip__c invalidTrip = new Trip__c(
            Name = 'Invalid Trip',
            Start_Date__c = Date.newInstance(2023, 12, 10),
            End_Date__c = Date.newInstance(2023, 12, 1)
        );

        try {
            // Essayez d'insérer le voyage
            Test.startTest();
            insert invalidTrip;
            Test.stopTest();
            // Si l'insertion réussit, cela signifie que le déclencheur n'a pas fonctionné correctement
            System.assert(false, 'Le voyage avec des dates invalides a été inséré.');
        } catch (DmlException e) {
            // Vérifiez que l'erreur attendue a été levée
            System.assert(e.getMessage().contains('Erreur : La date de fin doit être postérieure à la date de début.'), 'L\'erreur attendue n\'a pas été levée.');
        }
    }
}
