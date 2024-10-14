import { LightningElement, track } from 'lwc';

export default class TeamGroupMatches extends LightningElement {
    @track tournamentCount = 0;
    @track teamCount = 0;
    @track matchCount = 0;

    @track groups = [
        {
            groupName: 'Group A',
            teams: [
                {
                    id: '1',
                    teamName: 'Team A',
                    MP: 3,
                    W: 2,
                    D: 1,
                    L: 0,
                    GF: 5,
                    GA: 2,
                    GD: 3,
                    Pts: 7
                },
                {
                    id: '2',
                    teamName: 'Team B',
                    MP: 3,
                    W: 1,
                    D: 1,
                    L: 1,
                    GF: 3,
                    GA: 4,
                    GD: -1,
                    Pts: 4
                },
                {
                    id: '3',
                    teamName: 'Team C',
                    MP: 3,
                    W: 0,
                    D: 0,
                    L: 3,
                    GF: 1,
                    GA: 8,
                    GD: -7,
                    Pts: 0
                },
                {
                    id: '4',
                    teamName: 'Team D',
                    MP: 3,
                    W: 2,
                    D: 0,
                    L: 1,
                    GF: 6,
                    GA: 3,
                    GD: 3,
                    Pts: 6
                }
            ]
        },
        {
            groupName: 'Group B',
            teams: [
                {
                    id: '5',
                    teamName: 'Team E',
                    MP: 3,
                    W: 2,
                    D: 1,
                    L: 0,
                    GF: 4,
                    GA: 1,
                    GD: 3,
                    Pts: 7
                },
                {
                    id: '6',
                    teamName: 'Team F',
                    MP: 3,
                    W: 1,
                    D: 0,
                    L: 2,
                    GF: 2,
                    GA: 4,
                    GD: -2,
                    Pts: 3
                },
                {
                    id: '7',
                    teamName: 'Team G',
                    MP: 3,
                    W: 0,
                    D: 1,
                    L: 2,
                    GF: 1,
                    GA: 5,
                    GD: -4,
                    Pts: 1
                },
                {
                    id: '8',
                    teamName: 'Team H',
                    MP: 3,
                    W: 1,
                    D: 1,
                    L: 1,
                    GF: 3,
                    GA: 3,
                    GD: 0,
                    Pts: 4
                }
            ]
        }
    ];

    connectedCallback() {
        this.updateCounts();
    }

    updateCounts() {
        // Count the number of tournaments, teams, and matches
        this.tournamentCount = 1; // Set this to the number of tournaments you have
        this.teamCount = this.groups.reduce((count, group) => count + group.teams.length, 0);
        this.matchCount = this.calculateMatchCount();
    }

    calculateMatchCount() {
        // Calculate the total number of matches played in all groups
        return this.groups.reduce((count, group) => {
            return count + group.teams.reduce((teamCount, team) => teamCount + team.MP, 0);
        }, 0);
    }
}