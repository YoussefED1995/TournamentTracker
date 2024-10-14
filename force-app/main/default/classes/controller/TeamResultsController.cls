public with sharing class TeamResultsController {

   /* @AuraEnabled
    public static string getGroupResult(String trournamentName){
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();

            // Set the endpoint URL
            request.setEndpoint('callout:SalesforceNamedCred/services/apexrest/teamresults?tournamentName=Mock%20Tournament');

            // Set the request method
            request.setMethod('GET');

            HttpResponse response = http.send(request);

            // Output the response
            System.debug('Response Status: ' + response.getStatus());
            System.debug('Response Body: ' + response.getBody());

            if (response.getStatusCode() == 200) {
                System.debug('Response: ' + response.getBody());
                return response.getBody();  // Return the response body
            }   
            else {
                System.debug('Error: ' + response.getStatus() + ' - ' + response.getBody());
                return null; 
            } 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled(cacheable=true)
    public static List<GroupWrapper> getTeamsByGroup(String tournamentName) {
        // Query group results filtered by the provided tournament name
        List<Group_Result__c> groupResults = [
            SELECT Team_Name__r.Name, Wins__c, Draws__c, Losses__c, Match_Played__c, Points__c, 
                   Tournament_Name__r.Name, Status__c, Group__c
            FROM Group_Result__c
            WHERE Tournament_Name__r.Name = :tournamentName
            ORDER BY Group__c, Team_Name__r.Name
        ];

        // Map to store teams by group
        Map<String, List<TeamWrapper>> teamsByGroup = new Map<String, List<TeamWrapper>>();

        // Process each team and group them by group name
        for (Group_Result__c result : groupResults) {
            if (!teamsByGroup.containsKey(result.Group__c)) {
                teamsByGroup.put(result.Group__c, new List<TeamWrapper>());
            }
            teamsByGroup.get(result.Group__c).add(new TeamWrapper(
                result.Team_Name__r.Name, 
                result.Points__c, 
                result.Wins__c, 
                result.Draws__c, 
                result.Losses__c, 
                result.Match_Played__c, 
                result.Status__c,
                result.Status__c == 'Qualified'
            ));
        }

        // Convert map to list of GroupWrappers
        List<GroupWrapper> groupList = new List<GroupWrapper>();
        for (String groupName : teamsByGroup.keySet()) {
            groupList.add(new GroupWrapper(groupName, teamsByGroup.get(groupName)));
        }

        return groupList;
    }

    // Wrapper classes
    public class GroupWrapper {
        @AuraEnabled
        public String groupName;
        @AuraEnabled
        public List<TeamWrapper> teams;

        public GroupWrapper(String groupName, List<TeamWrapper> teams) {
            this.groupName = groupName;
            this.teams = teams;
        }
    }

    public class TeamWrapper {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Decimal points;  
        @AuraEnabled
        public Decimal wins;    
        @AuraEnabled
        public Decimal draws;   
        @AuraEnabled
        public Decimal losses;  
        @AuraEnabled
        public Decimal matchPlayed;  
        @AuraEnabled
        public String status;
        public Boolean isQualified;
    
        public TeamWrapper(String name, Decimal points, Decimal wins, Decimal draws, Decimal losses, Decimal matchPlayed, String status, Boolean isQualified) {
            this.name = name;
            this.points = points;
            this.wins = wins;
            this.draws = draws;
            this.losses = losses;
            this.matchPlayed = matchPlayed;
            this.status = status;
            this.isQualified = isQualified;
        }
    }
       
}
