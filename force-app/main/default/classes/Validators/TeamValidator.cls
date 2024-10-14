public with sharing class TeamValidator {

    // Define the maximum number of teams allowed per group as a constant
    private static final Integer MAX_TEAMS_PER_GROUP = 4;

    /**
     * Validates the number of teams in each group.
     * Throws an error if any group exceeds the allowed team count.
     *
     * @param teams List of Team__c records to validate
     */
    public static void validateTeamCount(List<Team__c> teams) {
        // Extract unique group IDs from the incoming teams
        Set<String> groupIds = getUniqueGroupIds(teams);
        
        // Query the number of existing teams per group and store in a map
        Map<String, Integer> groupTeamCountMap = getTeamCountsPerGroup(groupIds);
        
        // Validate the team count for each group
        enforceGroupTeamLimits(teams, groupTeamCountMap);
    }

    /**
     * Extracts the unique group IDs from the list of teams being inserted/updated.
     *
     * @param teams List of Team__c records
     * @return Set of unique Group__c IDs
     */
    private static Set<String> getUniqueGroupIds(List<Team__c> teams) {
        Set<String> groupIds = new Set<String>();
        for (Team__c team : teams) {
            if (team.Group__c != null) {
                groupIds.add(team.Group__c);
            }
        }
        return groupIds;
    }

    /**
     * Queries and returns the number of teams in each group.
     *
     * @param groupIds Set of Group__c IDs
     * @return Map of Group__c ID to team count
     */
    private static Map<String, Integer> getTeamCountsPerGroup(Set<String> groupIds) {
        Map<String, Integer> groupTeamCountMap = new Map<String, Integer>();
        
        // Aggregate query to count teams per group
        for (AggregateResult result : [
            SELECT Group__c, COUNT(Id) teamCount
            FROM Team__c
            WHERE Group__c IN :groupIds
            GROUP BY Group__c
        ]) {
            groupTeamCountMap.put((String) result.get('Group__c'), (Integer) result.get('teamCount'));
        }
        
        return groupTeamCountMap;
    }

    /**
     * Checks if the number of teams in each group exceeds the allowed limit
     * and throws an error if the limit is exceeded.
     *
     * @param teams List of Team__c records being inserted/updated
     * @param groupTeamCountMap Map of group IDs to the current team count
     */
    private static void enforceGroupTeamLimits(List<Team__c> teams, Map<String, Integer> groupTeamCountMap) {
        for (Team__c team : teams) {
            Integer currentTeamCount = groupTeamCountMap.get(team.Group__c);
            
            // Check if the current team count exceeds the maximum allowed
            if (currentTeamCount != null && currentTeamCount >= MAX_TEAMS_PER_GROUP) {
                team.addError('Group can only have ' + MAX_TEAMS_PER_GROUP + ' teams.');
            }
        }
    }
}
