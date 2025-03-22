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
private class AgentforceHomepageControllerTest {
    @isTest static void testGetAgentforceBannerUrl() {
        // Créer un document de test
        Document testDoc = new Document(
            Name = 'agentforceHomepageBanner1',
            Body = Blob.valueOf('Test Banner Content'),
            FolderId = UserInfo.getUserId() // Stocker dans le dossier personnel de l'utilisateur
        );
        insert testDoc;

        // Appeler la méthode et vérifier le résultat
        String bannerUrl = AgentforceHomepageController.getAgentforceBannerUrl(1);
        System.assertNotEquals(null, bannerUrl, 'L\'URL de la bannière ne devrait pas être nulle.');
        System.assert(bannerUrl.contains(testDoc.Id), 'L\'URL de la bannière devrait contenir l\'ID du document.');
    }

    @isTest static void testGetAgentforceBannerUrl_NotFound() {
        // Appeler la méthode avec un index qui ne correspond à aucun document
        String bannerUrl = AgentforceHomepageController.getAgentforceBannerUrl(999);
        System.assertEquals(null, bannerUrl, 'L\'URL de la bannière devrait être nulle si le document n\'est pas trouvé.');
    }
}