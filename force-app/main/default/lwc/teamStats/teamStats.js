import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getTeamResults from '@salesforce/apex/TeamResultsController.getTeamResults';

// Fields to be retrieved from the Team__c object
const FIELDS = [
    'Team__c.Name',
    'Team__c.Team_Logo__c',
];

export default class TeamStats extends LightningElement {
    teams = [];
    @api recordId; // Salesforce provides this automatically when the component is placed on a record page
    teamRecord; // Holds the full team record
    img; // Holds the team logo URL
    name;
    error; // Error handling

    // Wire the getRecord method to fetch Team__c object fields
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredTeam({ error, data }) {
        if (data) {
            this.teamRecord = data.fields;
            this.img = this.teamRecord.Team_Logo__c.value || null;
            this.name = this.teamRecord.Name.value || null;
            this.error = undefined;

            // Assuming teamName and tournamentName are set elsewhere or passed in as parameters
            const teamName = this.name; // Example assignment
            getTeamResults({ teamName })
            .then(result => {
                // Assuming result is a JSON string, parse it into an object
                const parsedResult = JSON.parse(result); // Parse the JSON string

                // Log the parsed result
                console.log('Parsed Result:', parsedResult);

                // Access the first item in the results array
                const teamStats = parsedResult.results[0]; // Adjust the index if you have multiple teams

                // Now use teamStats to populate the teams array
                this.teams = [
                    { id: 3, text: 'Matches Played', value: teamStats.matchPlayed },
                    { id: 4, text: 'Goals', value: teamStats.goalFor },
                    { id: 5, text: 'Goals Conceded', value: teamStats.goalAgainst },
                    { id: 6, text: 'Goal Difference', value: teamStats.goalDifference },
                    { id: 8, text: 'Status', value: teamStats.Status },
                ];
            })
            .catch(error => {
                this.error = error;
                console.error('Error fetching team results:', error);
            });


            console.log('Team record fetched successfully:', this.teamRecord);
        } else if (error) {
            // Handle any errors
            this.error = error;
            console.error('Error fetching team record:', error);
            this.teamRecord = undefined;
        }
    }
}
