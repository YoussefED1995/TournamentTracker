global class TournamentDataGenerator implements Database.Batchable<SObject>, Database.Stateful {

    private static final Integer GROUP_SIZE = 4;
    private static final Integer TOTAL_TEAMS = 32;
    private static final Integer TOTAL_GROUPS = TOTAL_TEAMS / GROUP_SIZE;
    private static final String TOURNAMENT_NAME = 'Mock Tournament';
    
    private List<Team__c> randomTeams;
    private Id tournamentId;  // Store the Tournament__c Id

    public TournamentDataGenerator() {
        randomTeams = new List<Team__c>();
        generateRandomTeams();
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Fetch the Id of the tournament with name 'Mock Tournament'
        List<Tournament__c> tournaments = [SELECT Id FROM Tournament__c WHERE Name = :TOURNAMENT_NAME LIMIT 1];
        if (!tournaments.isEmpty()) {
            tournamentId = tournaments[0].Id; // Store the tournament Id
        } else {
            throw new AuraHandledException('Tournament not found: ' + TOURNAMENT_NAME);
        }
        return Database.getQueryLocator([SELECT Id, Name FROM Tournament__c WHERE Name = :TOURNAMENT_NAME]);
    }
 
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Match__c> matchesToInsert = new List<Match__c>();
        List<Group_Result__c> groupResultsToInsert = new List<Group_Result__c>();
    
        // Step 1: Generate Group Stage Matches
        for (Integer groupIndex = 0; groupIndex < TOTAL_GROUPS; groupIndex++) {
            List<Team__c> groupTeams = getTeamsForGroup(groupIndex); // Get teams for the current group
            
            for (Integer i = 0; i < GROUP_SIZE - 1; i++) {
                for (Integer j = i + 1; j < GROUP_SIZE; j++) {
                    Id homeTeamId = groupTeams[i].Id;
                    Id awayTeamId = groupTeams[j].Id;
                    Integer homeGoals;
                    Integer awayGoals;
    
                    // Generate homeGoals and awayGoals until they are not equal
                    do {
                        homeGoals = Math.round(Math.random() * 5);
                        awayGoals = Math.round(Math.random() * 5);
                    } while (homeGoals == awayGoals);
                    
                    // Create Match__c record with correct group name from picklist
                    Match__c match = new Match__c(
                        Home_Team__c = homeTeamId,
                        Away_Team__c = awayTeamId,
                        Group__c ='Group '+(groupIndex + 1),  // Use valid picklist values
                        Match_Date__c = DateTime.now().addDays(Math.round(Math.random() * 30)),
                        Round_Number__c = String.valueOf(i + 1), // Assign round number
                        Result__c = homeGoals + ' - ' + awayGoals,
                        Tournament_Name__c = tournamentId  // Use the fetched tournament Id
                    );
                    matchesToInsert.add(match);
                }
            }
        }
    
        if (!matchesToInsert.isEmpty()) {
            insert matchesToInsert;
        }
    
        // Step 2: Generate Knockout Stage Matches
        List<Team__c> qualifiedTeams = getQualifiedTeams();
        System.debug('Teams retrieved: ' + qualifiedTeams.size());
        List<Match__c> knockoutMatchesToInsert = new List<Match__c>();
    
        // Round configuration
        String[] rounds = new String[]{ 'Round of 16', 'Quarter-finals', 'Semi-finals', 'Final' };
        Integer totalTeams = 16; // Start with 16 teams
        
        // Loop through the rounds
        for (Integer roundIndex = 0; roundIndex < rounds.size(); roundIndex++) {
            Integer totalMatches = totalTeams / 2; // Matches for this round
        
            for (Integer matchIndex = 0; matchIndex < totalMatches; matchIndex++) {
                Id homeTeamId = qualifiedTeams[matchIndex * 2].Id;
                Id awayTeamId = qualifiedTeams[matchIndex * 2 + 1].Id;
                Integer homeGoals;
                Integer awayGoals;
    
                // Generate homeGoals and awayGoals until they are not equal
                do {
                    homeGoals = Math.round(Math.random() * 5);
                    awayGoals = Math.round(Math.random() * 5);
                } while (homeGoals == awayGoals);
                
                Match__c knockoutMatch = new Match__c(
                    Home_Team__c = homeTeamId,
                    Away_Team__c = awayTeamId,
                    Match_Date__c = DateTime.now().addDays(30 + (roundIndex * 7)), // Schedule in future
                    Round_Number__c = rounds[roundIndex],
                    Result__c = homeGoals + ' - ' + awayGoals,
                    Tournament_Name__c = tournamentId
                );
    
                knockoutMatchesToInsert.add(knockoutMatch);
            }
        
            // Insert matches for this round
            if (!knockoutMatchesToInsert.isEmpty()) {
                insert knockoutMatchesToInsert;
                knockoutMatchesToInsert.clear(); // Clear for next round
            }
        
            // Update qualified teams for the next round
            qualifiedTeams = getNextRoundTeams(knockoutMatchesToInsert, qualifiedTeams);
            totalTeams /= 2; // Halve the teams for the next round
        
            // Check for semi-finals to add third place match
            if (roundIndex == 2) { // Semi-finals
                // Assuming the last two teams in qualifiedTeams are the losing semi-finalists
                Id thirdPlaceHomeId = qualifiedTeams[2].Id; // 3rd place team
                Id thirdPlaceAwayId = qualifiedTeams[3].Id; // 4th place team
                
                Integer thirdPlaceHomeGoals;
                Integer thirdPlaceAwayGoals;
    
                // Generate homeGoals and awayGoals until they are not equal
                do {
                    thirdPlaceHomeGoals = Math.round(Math.random() * 5);
                    thirdPlaceAwayGoals = Math.round(Math.random() * 5);
                } while (thirdPlaceHomeGoals == thirdPlaceAwayGoals);
                
                Match__c thirdPlaceMatch = new Match__c(
                    Home_Team__c = thirdPlaceHomeId,
                    Away_Team__c = thirdPlaceAwayId,
                    Match_Date__c = DateTime.now().addDays(30 + (roundIndex * 7)), // Schedule in future
                    Round_Number__c = 'Third Place',
                    Result__c = thirdPlaceHomeGoals + ' - ' + thirdPlaceAwayGoals,
                    Tournament_Name__c = tournamentId
                );
    
                knockoutMatchesToInsert.add(thirdPlaceMatch);
            }
        }
        
        // Insert third place match after all rounds are complete
        if (!knockoutMatchesToInsert.isEmpty()) {
            insert knockoutMatchesToInsert;
        }        
    }
    
    
    private List<Team__c> getTeamsForGroup(Integer groupIndex) {
        List<Team__c> groupTeams = new List<Team__c>();
        for (Integer i = 0; i < GROUP_SIZE; i++) {
            groupTeams.add(randomTeams[groupIndex * GROUP_SIZE + i]);
        }
        return groupTeams;
    }

    private void generateRandomTeams() {
        // Generate 32 random teams and assign to Group 1 through Group 8
        for (Integer i = 1; i <= TOTAL_TEAMS; i++) {
            Integer groupNumber = (i - 1) / GROUP_SIZE + 1; // Calculate group number between 1 and 8
            randomTeams.add(new Team__c(
                Name = 'Team ' + i,
                Group__c = 'Group ' + groupNumber // Assign group number from 1 to 8
            ));
        }
        // Insert teams into the database
        insert randomTeams;
    }
    

    global void finish(Database.BatchableContext BC) {
        System.debug('Mock tournament data generation completed.');
    }
    private List<Team__c> getQualifiedTeams() {
        // Step 1: Query qualified teams based on the relationship
        List<Group_Result__c> groupResults = [
            SELECT Team_Name__c // Assuming Team__c is a lookup on Group_Result__c
            FROM Group_Result__c
            WHERE Status__c = 'Qualified'
        ];
    
        // Step 2: Collect Team Ids
        Set<Id> qualifiedTeamIds = new Set<Id>();
        for (Group_Result__c groupResult : groupResults) {
            if (groupResult.Team_Name__c != null) { // Ensure not null
                qualifiedTeamIds.add(groupResult.Team_Name__c);
            }
        }
    
        // Step 3: Query Team__c records matching the qualified team Ids
        List<Team__c> qualifiedTeams = [
            SELECT Id, Name
            FROM Team__c
            WHERE Id IN :qualifiedTeamIds
        ];
    
        return qualifiedTeams;
    }
    
    
    

    private List<Team__c> getNextRoundTeams(List<Match__c> knockoutResults, List<Team__c> allTeams) {
        Set<Id> knockedOutTeamIds = new Set<Id>();
        for (Match__c match : knockoutResults) {
            if (match.Home_Goals__c < match.Away_Goals__c) {
                knockedOutTeamIds.add(match.Home_Team__c);
            } else if (match.Home_Goals__c > match.Away_Goals__c) {
                knockedOutTeamIds.add(match.Away_Team__c);
            }
        }
        List<Team__c> nextRoundTeams = new List<Team__c>();
        for (Team__c team : allTeams) {
            if (!knockedOutTeamIds.contains(team.Id)) {
                nextRoundTeams.add(team);
            }
        }
        return nextRoundTeams;
    }
    
    private String getStageInfo(Integer round) {
        if (round == 0) {
            return 'Round of 16';
        } else if (round == 1) {
            return 'Quarter-final';
        } else if (round == 2) {
            return 'Semi-final';
        } else if (round == 3) {
            return 'Final';
        }
        return '';
    }
}
