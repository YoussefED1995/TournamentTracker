trigger MatchTrigger on Match__c (before insert, before update) {

    List<Match__c> groupStageMatches = new List<Match__c>();
    List<Match__c> roundThreeMatches = new List<Match__c>();
    MatchValidator matchValidator = new MatchValidator();

    for (Match__c match : Trigger.new) {
        if (match.Group__c != null) {
            if (Trigger.isInsert) {
                groupStageMatches.add(match);
            } else if (Trigger.isUpdate) {
                Match__c oldMatch = Trigger.oldMap.get(match.Id);
                if (match.Group__c != oldMatch.Group__c ||
                         match.Home_Team__c != oldMatch.Home_Team__c ||
                            match.Away_Team__c != oldMatch.Away_Team__c) {
                    groupStageMatches.add(match);
                }
            }
            
            if (match.Round_Number__c == '3') { 
                roundThreeMatches.add(match);
            }

        }
    }

    if (!groupStageMatches.isEmpty()) {
        matchValidator.validateMatchPlayed(groupStageMatches);
        matchValidator.updateGroupResult(groupStageMatches);
    }

    if (!roundThreeMatches.isEmpty()) {
        MatchValidator.updateTeamQualificationStatus();
        MatchValidator.groupStageConcurrentScheduler(roundThreeMatches);
    }
}
