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
public class TeamValidatorTest {

    @testSetup
    static void setupTestData() {
        // Create teams for Group 1 that do not exceed the limit
        List<Team__c> group1Teams = new List<Team__c>();
        for (Integer i = 0; i < 3; i++) {
            group1Teams.add(new Team__c(Name = 'Team ' + i, Group__c = 'Group 1'));
        }
        insert group1Teams;
        
        // Create teams for Group 2 that will reach the limit
        List<Team__c> group2Teams = new List<Team__c>();
        for (Integer i = 0; i < 4; i++) {
            group2Teams.add(new Team__c(Name = 'Team ' + i, Group__c = 'Group 2'));
        }
        insert group2Teams;
    }

    @isTest
    static void testTeamCountWithinLimit() {
        // Create new teams for Group 1 (within the limit)
        List<Team__c> teams = new List<Team__c>{
            new Team__c(Name = 'New Team 1', Group__c = 'Group 1')
        };
        
        // Test that no error is thrown
        Test.startTest();
        TeamValidator.validateTeamCount(teams);
        Test.stopTest();
    }

    @isTest
    static void testTeamCountExceedsLimit() {  
        try {
            List<Team__c> teams = new List<Team__c>{
                new Team__c(Name = 'Team 5', Group__c = 'Group 2')
            };
            insert teams;   
        } catch (Exception ex) {
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Group can only have 4 teams.') ? true : false;
            System.assertEquals(expectedExceptionThrown, true);
        }
          
      
    }

}
