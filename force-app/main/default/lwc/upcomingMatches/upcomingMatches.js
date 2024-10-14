import { LightningElement, track, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getMatchesByTeam from '@salesforce/apex/UpcomingMatches.getMatchesByTeam';

const FIELDS = [
    'Team__c.Name',
    'Team__c.Team_Logo__c',
];

export default class UpcomingMatches extends LightningElement {
    @track recentMatches = [];
    @track upcomingMatches = [];
    @api recordId;
    teamRecord;
    teamName;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredTeam({ error, data }) {
        if (data) {
            this.teamRecord = data.fields;
            this.teamName = this.teamRecord.Name.value || null;

            // Log team name for debugging
            console.log("Team Name: " + this.teamName);

            if (this.teamName) {
                this.loadMatches();
            }
        } else if (error) {
            console.error('Error fetching team record:', error);
            this.teamRecord = undefined;
        }
    }
    
    loadMatches() {
        console.log("Loading matches for team: " + this.teamName);
        getMatchesByTeam({ teamName: this.teamName }) // No encoding
            .then(matches => {
                console.log("Fetched matches: " + JSON.stringify(matches));
                this.processMatches(matches);
            })
            .catch(error => {
                console.error('Error fetching matches:', error);
                // Optional: Handle error to show user-friendly message
            });
    }
    processMatches(matches) {
        const today = new Date().toISOString().split('T')[0]; // Current date in YYYY-MM-DD format
    
        matches.forEach(match => {
            const matchDateTime = match.Match_Date__c; // This is in DateTime format
            const matchDate = new Date(matchDateTime).toISOString().split('T')[0]; // Convert DateTime to Date
    
            if (matchDate < today) {
                this.upcomingMatches.push({
                    id: match.Id,
                    homeTeam: match.Home_Team__r.Name,
                    awayTeam: match.Away_Team__r.Name,
                    homeGoals: match.Home_Goals__c,
                    awayGoals: match.Away_Goals__c,
                    date: matchDate // Store as Date
                });
            } else {
                this.upcomingMatches.push({
                    id: match.Id,
                    homeTeam: match.Home_Team__r.Name,
                    awayTeam: match.Away_Team__r.Name,
                    date: matchDate // Store as Date
                });
            }
        });
    }
}
