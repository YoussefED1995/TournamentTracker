@RestResource(urlMapping='/teamresults/*')
global with sharing class TeamResultWebService {

    @HttpGet
    global static TeamResultResponse getTeamResults() {
        RestRequest req = RestContext.request;
        String tournamentName = req.params.get('tournamentName');

        if (String.isBlank(tournamentName)) {
            RestContext.response.statusCode = 400;
            return new TeamResultResponse('Missing tournament name', null);
        }

        try {
            List<Group_Result__c> teamResults = [
                SELECT Team_Name__r.Name, Wins__c, Draws__c, Losses__c, Match_Played__c, Points__c, 
                       Tournament_Name__r.Name, Status__c
                FROM Group_Result__c
                WHERE Tournament_Name__r.Name = :tournamentName
            ];

            if (teamResults.isEmpty()) {
                return new TeamResultResponse('No results found for the specified team and tournament', null);
            }

            List<TeamResultData> teamResultDataList = new List<TeamResultData>();
            for (Group_Result__c result : teamResults) {
                TeamResultData resultData = new TeamResultData(
                    result.Team_Name__r.Name,
                    result.Wins__c,
                    result.Draws__c,
                    result.Losses__c,
                    result.Match_Played__c,
                    result.Points__c,
                    result.Tournament_Name__r.Name
                );
                teamResultDataList.add(resultData);
            }

            return new TeamResultResponse('Success', teamResultDataList);

        } catch (Exception ex) {
            RestContext.response.statusCode = 500;
            return new TeamResultResponse('Error: ' + ex.getMessage(), null);
        }
    }

    global class TeamResultResponse {
        public String message;
        public List<TeamResultData> results;

        public TeamResultResponse(String message, List<TeamResultData> results) {
            this.message = message;
            this.results = results;
        }
    }

    global class TeamResultData {
        public String teamName;
        public Decimal wins;
        public Decimal draws;
        public Decimal losses;
        public Decimal matchPlayed;
        public Decimal points;
        public String tournamentName;

        public TeamResultData(String teamName, Decimal wins, Decimal draws, Decimal losses, 
        Decimal matchPlayed, Decimal points, String tournamentName) {
            this.teamName = teamName;
            this.wins = wins;
            this.draws = draws;
            this.losses = losses;
            this.matchPlayed = matchPlayed;
            this.points = points;
            this.tournamentName = tournamentName;
        }
    }
}
