public with sharing class MatchService {
    
    @AuraEnabled(cacheable=true)
    public static List<Match__c> getUpcomingMatches(String teamName) {
        DateTime now = DateTime.now();
        
        return [
            SELECT Away_Team__c, Home_Team__c, Group__c, Location__c, Match_Date__c, Result__c, Round_Number__c, Tournament_Name__c
            FROM Match__c
            WHERE (Away_Team__c = :teamName OR Home_Team__c = :teamName) 
            AND Match_Date__c >= :now
            ORDER BY Match_Date__c ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Match__c> getRecentMatches(String teamName) {
        DateTime now = DateTime.now().addDays(-30); // Adjust the range as needed
        
        return [
            SELECT Away_Team__c, Home_Team__c, Group__c, Location__c, Match_Date__c, Result__c, Round_Number__c, Tournament_Name__c
            FROM Match__c
            WHERE (Away_Team__c = :teamName OR Home_Team__c = :teamName) 
            AND Match_Date__c < :now
            ORDER BY Match_Date__c DESC
        ];
    }
}
