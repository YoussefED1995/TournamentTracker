import { LightningElement, track, wire, api } from 'lwc';
import getGroupResult from '@salesforce/apex/TeamResultsController.getTeamsByGroup';

export default class GroupTeamsCard extends LightningElement {
    @track groupData = [];  // Reactive variable to store groups
    tournamentName = 'Mock Tournament';  // Tournament name

    @track tournaments = [
        { id: 'tournament1', name: 'Tournament 1' },
        { id: 'tournament2', name: 'Tournament 2' },
        { id: 'tournament3', name: 'Tournament 3' },
    ];


    // Using @wire to call the Apex method and pass the tournament name
    @wire(getGroupResult, { tournamentName: '$tournamentName' })
    wiredGroupResult({ error, data }) {
        if (data) {
            this.groupData = data;
        } else if (error) {
            console.error('Error fetching group results:', error);
        }
    }



}
