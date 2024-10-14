trigger TeamTrigger on Team__c (before insert, before update) {
    // Filter the teams for validation:
    // - For insert, validate all teams.
    // - For update, validate only teams where the Group__c has changed.
    List<Team__c> teamsToValidate = new List<Team__c>();
    if (Trigger.isInsert) {
        // For insert, all new teams need validation
        teamsToValidate = Trigger.new;
    } else if (Trigger.isUpdate) {
        // For update, validate only teams where Group__c has changed
        for (Team__c team : Trigger.new) {
            Team__c oldTeam = Trigger.oldMap.get(team.Id);
            if (team.Group__c != oldTeam.Group__c) {
                teamsToValidate.add(team);
            }
        }
    }
    // Validate team count if there are teams to validate
    if (!teamsToValidate.isEmpty()) {
        TeamValidator.validateTeamCount(teamsToValidate);
    }
}
