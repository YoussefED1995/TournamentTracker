public with sharing class UpcomingMatches {
    @AuraEnabled(cacheable=true)
    public static List<Match__c> getMatchesByTeam(String teamName) {
        if (String.isEmpty(teamName)) {
            return new List<Match__c>();
        }

        // Get today's date
        Date today = Date.today();

        // Query for recent and upcoming matches for the specified team
        List<Match__c> matches = [
            SELECT Home_Team__r.Name, Away_Team__r.Name, Home_Goals__c, Away_Goals__c, Match_Date__c, Location__c
            FROM Match__c
            WHERE (Home_Team__r.Name = :teamName OR Away_Team__r.Name = :teamName)
            AND Match_Date__c >= :today
            ORDER BY Match_Date__c ASC
        ];

        return matches;
    }

}