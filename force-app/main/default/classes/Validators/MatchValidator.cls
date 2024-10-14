public with sharing class MatchValidator {
  
  public void validateMatchPlayed(List<Match__c> newMatches) {
    Set<Id> teamIds = new Set<Id>();
    String tournamentName = '';
    String teams_group = '';

    // Collect all teams involved in the matches being processed and capture tournament and group info
    for (Match__c match : newMatches) {
      if (match.Group__c != null && match.Tournament_Name__c != null) {
        // Only apply to group stage matches
        tournamentName = match.Tournament_Name__c;
        teams_group = match.Group__c;

        if (match.Home_Team__c != null) {
          teamIds.add(match.Home_Team__c);
        }
        if (match.Away_Team__c != null) {
          teamIds.add(match.Away_Team__c);
        }
      }
    }

    // Early exit if no teams are involved
    if (teamIds.isEmpty())
      return;

    List<Match__c> existingMatches = [
      SELECT Id, Home_Team__c, Away_Team__c
      FROM Match__c
      WHERE
        (Home_Team__c IN :teamIds
        OR Away_Team__c IN :teamIds)
        AND Tournament_Name__c = :tournamentName
        AND Group__c = :teams_group
    ];

    // Map to keep track of matches played by each team
    Map<Id, Integer> teamMatchesCount = new Map<Id, Integer>();

    // Initialize match counts for the teams involved
    for (Id teamId : teamIds) {
      teamMatchesCount.put(teamId, 0);
    }

    // Count existing matches for each team
    for (Match__c match : existingMatches) {
      if (teamMatchesCount.containsKey(match.Home_Team__c)) {
        teamMatchesCount.put(
          match.Home_Team__c,
          teamMatchesCount.get(match.Home_Team__c) + 1
        );
      }
      if (teamMatchesCount.containsKey(match.Away_Team__c)) {
        teamMatchesCount.put(
          match.Away_Team__c,
          teamMatchesCount.get(match.Away_Team__c) + 1
        );
      }
    }

    // Validate the matches being processed
    for (Match__c match : newMatches) {
      if (
        match.Home_Team__c != null &&
        teamMatchesCount.get(match.Home_Team__c) >= 3
      ) {
        match.addError(
          'The home team cannot play more than 3 matches in this group.'
        );
      }
      if (
        match.Away_Team__c != null &&
        teamMatchesCount.get(match.Away_Team__c) >= 3
      ) {
        match.addError(
          'The away team cannot play more than 3 matches in this group.'
        );
      }
    }
  }

  public void updateGroupResult(List<Match__c> newMatches) {
    Set<Id> teamIds = new Set<Id>();
    for (Match__c match : newMatches) {
      if (match.Home_Team__c != null) {
        teamIds.add(match.Home_Team__c);
      }
      if (match.Away_Team__c != null) {
        teamIds.add(match.Away_Team__c);
      }
    }

    // Step 2: Query for existing Team_Result__c records for those teams
    Map<Id, Group_Result__c> teamResultsMap = new Map<Id, Group_Result__c>(
      [
        SELECT
          Id,
          Team_Name__c,
          Goals_For__c,
          Goals_Against__c,
          Match_played__c,
          Points__c,
          Wins__c,
          Losses__c,
          Draws__c,
          Group__c
        FROM Group_Result__c
        WHERE Team_Name__c IN :teamIds
      ]
    );

    // Step 3: Create new Team_Result__c records for teams without an existing result
    List<Group_Result__c> newTeamResults = new List<Group_Result__c>();

    for (Id teamId : teamIds) {
      if (!teamResultsMap.containsKey(teamId)) {
        Group_Result__c newResult = new Group_Result__c(
          Team_Name__c = teamId,
          Goals_For__c = 0,
          Goals_Against__c = 0,
          Match_played__c = 0,
          Points__c = 0,
          Wins__c = 0,
          Losses__c = 0,
          Draws__c = 0
        );
        newTeamResults.add(newResult);
        teamResultsMap.put(teamId, newResult); // Add new results to the map
      }
    }
    // Insert new results if they don't already exist
    if (!newTeamResults.isEmpty()) {
      insert newTeamResults;
    }

    // Step 4: Update team results based on new matches
    for (Match__c match : newMatches) {
      if (match.Result__c != null && match.Result__c.contains('-')) {
        Group_Result__c homeTeamResult = teamResultsMap.get(match.Home_Team__c);
        Group_Result__c awayTeamResult = teamResultsMap.get(match.Away_Team__c);
        String[] scores = match.Result__c.replace(' ', '').split('-'); // Split the result string

        // Ensure the Group__c is updated for both teams
        homeTeamResult.Group__c = match.Group__c;
        awayTeamResult.Group__c = match.Group__c;

        homeTeamResult.Tournament_Name__c = match.Tournament_Name__c;
        awayTeamResult.Tournament_Name__c = match.Tournament_Name__c;

        // Update team stats
        updateTeamStats(
          homeTeamResult,
          awayTeamResult,
          Decimal.valueOf(scores[0]), // Home team goals
          Decimal.valueOf(scores[1]) // Away team goals
        );
      } else {
        // Handle missing or malformed Result__c
        System.debug(
          'Match Result__c is missing or incorrectly formatted for match: ' +
          match.Id
        );
      }
    }

    // Step 5: Perform a bulk update for existing results
    update teamResultsMap.values();
  }

  private void updateTeamStats(
    Group_Result__c homeTeamResult,
    Group_Result__c awayTeamResult,
    Decimal homeGoals,
    Decimal awayGoals
  ) {
    // Update home team stats
    homeTeamResult.Goals_For__c += homeGoals;
    homeTeamResult.Goals_Against__c += awayGoals;
    homeTeamResult.Match_Played__c += 1;

    // Update away team stats
    awayTeamResult.Goals_For__c += awayGoals;
    awayTeamResult.Goals_Against__c += homeGoals;
    awayTeamResult.Match_Played__c += 1;

    // Determine the outcome of the match and update Wins, Losses, Draws
    if (homeGoals > awayGoals) {
      // Home team wins
      homeTeamResult.Points__c += 3;
      homeTeamResult.Wins__c += 1;
      awayTeamResult.Losses__c += 1;
    } else if (homeGoals < awayGoals) {
      // Away team wins
      awayTeamResult.Points__c += 3;
      awayTeamResult.Wins__c += 1;
      homeTeamResult.Losses__c += 1;
    } else {
      // It's a draw
      homeTeamResult.Points__c += 1;
      awayTeamResult.Points__c += 1;
      homeTeamResult.Draws__c += 1;
      awayTeamResult.Draws__c += 1;
    }
  }

  public void updateTeamQualificationStatus() {
    // Step 1: Query all team results where teams have completed 3 matches in their group
    List<Group_Result__c> teamResults = [
      SELECT
        Id,
        Team_Name__c,
        Group__c,
        Points__c,
        Goals_For__c,
        Goals_Against__c,
        Match_played__c,
        Status__c
      FROM Group_Result__c
      WHERE Match_played__c = 3
      ORDER BY
        Group__c,
        Points__c DESC,
        Goal_Difference__c DESC,
        Goals_For__c DESC
    ];

    // Map to hold the top 2 teams per group
    Map<String, List<Group_Result__c>> qualifiedTeamsMap = new Map<String, List<Group_Result__c>>();
    Set<Id> qualifiedTeamIds = new Set<Id>(); // To keep track of qualified team IDs

    // Step 2: Iterate through the results to extract the top 2 teams from each group
    for (Group_Result__c result : teamResults) {
      if (!qualifiedTeamsMap.containsKey(result.Group__c)) {
        qualifiedTeamsMap.put(result.Group__c, new List<Group_Result__c>());
      }

      // Add the team result to the list for its group if we haven't already picked 2
      if (qualifiedTeamsMap.get(result.Group__c).size() < 2) {
        qualifiedTeamsMap.get(result.Group__c).add(result);
        qualifiedTeamIds.add(result.Id); // Mark as qualified
      }
    }

    // Step 3: Update the qualified teams' status
    List<Group_Result__c> updates = new List<Group_Result__c>();
    for (Group_Result__c result : teamResults) {
      if (qualifiedTeamIds.contains(result.Id)) {
        // Set status to "Qualified" for the top 2 teams
        result.Status__c = 'Qualified';
      } else {
        // Set status to "Eliminated" for the rest
        result.Status__c = 'Eliminated';
      }
      updates.add(result);
    }

    // Step 4: Perform bulk update
    if (!updates.isEmpty()) {
      update updates;
    }
  }

  public void groupStageConcurrentScheduler(List<Match__c> newMatches) {
    // Initialize a Set to collect unique Group__c IDs from the newMatches list
    Set<String> groupIds = new Set<String>();

    // Collect all Group__c IDs from the incoming matches
    for (Match__c match : newMatches) {
      if (match.Group__c != null) {
        groupIds.add(match.Group__c);
      }
    }

    // If no group IDs found, exit the method
    if (groupIds.isEmpty()) {
      return;
    }

    // Query all matches in the same group where Round_Number__c = 3 (final round)
    List<Match__c> finalRoundMatches = [
      SELECT Group__c, Match_Date__c
      FROM Match__c
      WHERE Group__c IN :groupIds AND Round_Number__c = '3'
    ];

    // Use a Map to store the match date for each group in the final round
    Map<String, Datetime> groupMatchDates = new Map<String, Datetime>();

    // Populate the map with group IDs and their respective match dates
    for (Match__c finalMatch : finalRoundMatches) {
      if (!groupMatchDates.containsKey(finalMatch.Group__c)) {
        groupMatchDates.put(finalMatch.Group__c, finalMatch.Match_Date__c);
      }
    }

    // Iterate through the new or updated matches
    for (Match__c match : newMatches) {
      // Only validate matches in the final round (Round_Number__c = 3) and with a valid group
      if (match.Group__c != null) {
        Datetime existingMatchDate = groupMatchDates.get(match.Group__c);

        // If there is an existing match date and it differs from the new match's date, add error
        if (
          existingMatchDate != null &&
          match.Match_Date__c != existingMatchDate
        ) {
          match.addError(
            'All final round matches in a group must start at the same time.'
          );
        }
      }
    }
  }
}
