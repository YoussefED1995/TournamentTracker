import { LightningElement } from 'lwc';

export default class MyTournamentData extends LightningElement {
    groups = [
        {
            groupName: 'Group A',
            teams: [
                {
                    position: 1,
                    name: 'NED',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/NED',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 4,
                    points: 7
                },
                {
                    position: 2,
                    name: 'SEN',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/SEN',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 0,
                    losses: 1,
                    goalDifference: 1,
                    points: 6
                },
                {
                    position: 3,
                    name: 'ECU',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/ECU',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 1,
                    losses: 1,
                    goalDifference: 1,
                    points: 4
                },
                {
                    position: 4,
                    name: 'QAT',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/QAT',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -6,
                    points: 0
                }
            ]
        },
        {
            groupName: 'Group B',
            teams: [
                {
                    position: 1,
                    name: 'ENG',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/ENG',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 5,
                    points: 7
                },
                {
                    position: 2,
                    name: 'USA',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/USA',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 1,
                    losses: 1,
                    goalDifference: 0,
                    points: 4
                },
                {
                    position: 3,
                    name: 'IRN',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/IRN',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 0,
                    losses: 2,
                    goalDifference: -2,
                    points: 3
                },
                {
                    position: 4,
                    name: 'WAL',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/WAL',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -3,
                    points: 0
                }
            ]
        },
        {
            groupName: 'Group C',
            teams: [
                {
                    position: 1,
                    name: 'ARG',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/ARG',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 4,
                    points: 7
                },
                {
                    position: 2,
                    name: 'MEX',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/MEX',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 1,
                    losses: 1,
                    goalDifference: 0,
                    points: 4
                },
                {
                    position: 3,
                    name: 'POL',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/POL',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 0,
                    losses: 2,
                    goalDifference: -1,
                    points: 3
                },
                {
                    position: 4,
                    name: 'SAU',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/SAU',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -3,
                    points: 0
                }
            ]
        },
        {
            groupName: 'Group D',
            teams: [
                {
                    position: 1,
                    name: 'FRA',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/FRA',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 3,
                    points: 7
                },
                {
                    position: 2,
                    name: 'DEN',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/DEN',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 1,
                    losses: 1,
                    goalDifference: 0,
                    points: 4
                },
                {
                    position: 3,
                    name: 'TUN',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/TUN',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 0,
                    losses: 2,
                    goalDifference: -1,
                    points: 3
                },
                {
                    position: 4,
                    name: 'AUS',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/AUS',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -2,
                    points: 0
                }
            ]
        },
        {
            groupName: 'Group E',
            teams: [
                {
                    position: 1,
                    name: 'ESP',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/ESP',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 5,
                    points: 7
                },
                {
                    position: 2,
                    name: 'GER',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/GER',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 1,
                    losses: 1,
                    goalDifference: 0,
                    points: 4
                },
                {
                    position: 3,
                    name: 'JPN',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/JPN',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 0,
                    losses: 2,
                    goalDifference: -2,
                    points: 3
                },
                {
                    position: 4,
                    name: 'CRC',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/CRC',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -3,
                    points: 0
                }
            ]
        },
        {
            groupName: 'Group F',
            teams: [
                {
                    position: 1,
                    name: 'BRA',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/BRA',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 4,
                    points: 7
                },
                {
                    position: 2,
                    name: 'BEL',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/BEL',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 1,
                    losses: 1,
                    goalDifference: 0,
                    points: 4
                },
                {
                    position: 3,
                    name: 'CAN',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/CAN',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 0,
                    losses: 2,
                    goalDifference: -1,
                    points: 3
                },
                {
                    position: 4,
                    name: 'MAR',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/MAR',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -2,
                    points: 0
                }
            ]
        },
        {
            groupName: 'Group G',
            teams: [
                {
                    position: 1,
                    name: 'POR',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/POR',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 3,
                    points: 7
                },
                {
                    position: 2,
                    name: 'SUI',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/SUI',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 1,
                    losses: 1,
                    goalDifference: 0,
                    points: 4
                },
                {
                    position: 3,
                    name: 'KSA',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/KSA',
                    matchesPlayed: 3,
                    wins: 1,
                    draws: 0,
                    losses: 2,
                    goalDifference: -1,
                    points: 3
                },
                {
                    position: 4,
                    name: 'GHA',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/GHA',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -2,
                    points: 0
                }
            ]
        },
        {
            groupName: 'Group H',
            teams: [
                {
                    position: 1,
                    name: 'BEL',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/BEL',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 1,
                    losses: 0,
                    goalDifference: 6,
                    points: 7
                },
                {
                    position: 2,
                    name: 'ARG',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/ARG',
                    matchesPlayed: 3,
                    wins: 2,
                    draws: 0,
                    losses: 1,
                    goalDifference: 2,
                    points: 6
                },
                {
                    position: 3,
                    name: 'MAR',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/MAR',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 1,
                    losses: 2,
                    goalDifference: -3,
                    points: 1
                },
                {
                    position: 4,
                    name: 'TUN',
                    flag: 'https://api.fifa.com/api/v3/picture/flags-sq-1/TUN',
                    matchesPlayed: 3,
                    wins: 0,
                    draws: 0,
                    losses: 3,
                    goalDifference: -5,
                    points: 0
                }
            ]
        }
    ];
}
