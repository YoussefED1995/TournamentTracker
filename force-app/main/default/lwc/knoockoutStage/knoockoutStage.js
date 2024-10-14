
import { LightningElement, track } from 'lwc';

export default class KnoockoutStage extends LightningElement {
    @track knockoutMatches = [
        {
            id: '1',
            round: 'Round of 16',
            date: 'Oct 21, 2024',
            homeTeam: 'Brazil',
            awayTeam: 'Argentina',
            homeTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/0/0f/Flag_of_Brazil.svg',
            awayTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/9/9a/Flag_of_Argentina.svg',
            matchLink: '/matches/brazil-vs-argentina'
        },
        {
            id: '2',
            round: 'Quarter-finals',
            date: 'Oct 25, 2024',
            homeTeam: 'France',
            awayTeam: 'Spain',
            homeTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg',
            awayTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/9/9a/Flag_of_Spain.svg',
            matchLink: '/matches/france-vs-spain'
        },
        {
            id: '3',
            round: 'Semi-finals',
            date: 'Oct 29, 2024',
            homeTeam: 'Germany',
            awayTeam: 'Italy',
            homeTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/b/bc/Flag_of_Germany.svg',
            awayTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/0/03/Flag_of_Italy.svg',
            matchLink: '/matches/germany-vs-italy'
        },
        {
            id: '4',
            round: 'Final',
            date: 'Nov 02, 2024',
            homeTeam: 'Portugal',
            awayTeam: 'Netherlands',
            homeTeamLogo: 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg',
            awayTeamLogo: 'https://upload.wikimedia.org/wikipedia/commons/2/20/Flag_of_the_Netherlands.svg',
            matchLink: '/matches/portugal-vs-netherlands'
        },
    ];
}
