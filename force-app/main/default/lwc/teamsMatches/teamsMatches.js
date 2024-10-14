import { LightningElement, track } from 'lwc';

export default class TeamsMatches extends LightningElement {
    @track selectedSeason = '6950';
    @track selectedStage = '4';
    @track selectedTable = '';

    seasonOptions = [
        { label: '2034', value: '26686' },
        { label: '2030', value: '26629' },
        { label: '2026', value: '15888' },
        { label: '2022', value: '6950', selected: true },
        { label: '2018', value: '6949' },
        // ... Add other seasons
    ];

    stageOptions = [
        { label: 'المجموعات', value: '1' },
        { label: 'دور ال 16', value: '2' },
        { label: 'ربع النهائي', value: '3' },
        { label: 'نصف النهائي', value: '4', selected: true },
        { label: 'المركز الثالث', value: '5' },
        { label: 'النهائي', value: '6' },
    ];

    tableOptions = [
        { label: 'جداول', value: '' },
        { label: 'منتدى: كووورة FIFA', value: 'forum=159' },
        { label: 'تاريخ', value: 'g=229&champs=true' },
        { label: 'هدافون', value: 'c=6950&scorers=true' },
        { label: 'أخبار', value: 'n=0&obj=6950' },
    ];

    @track matches = [
        {
            id: '1',
            matchId: '2000043',
            date: 'الثلاثاء 13 ديسمبر 2022',
            dateLink: '/?region=-1&area=0&dd=13&mm=12&yy=2022',
            time: '19:59',
            team1: 'الأرجنتين',
            team1Link: '/?team=338',
            score1: '3',
            score2: '0',
            team2: 'كرواتيا',
            team2Link: '/?team=203',
            stadium: 'استاد لوسيل',
            matchNumber: 'المباراة رقم 61',
            scoreLink: '?region=-12&team=338&team2=203',
        },
        {
            id: '2',
            matchId: '2000044',
            date: 'الأربعاء 14 ديسمبر 2022',
            dateLink: '/?region=-1&area=0&dd=14&mm=12&yy=2022',
            time: '19:59',
            team1: 'فرنسا',
            team1Link: '/?team=168',
            score1: '2',
            score2: '0',
            team2: 'المغرب',
            team2Link: '/?team=361',
            stadium: 'استاد البيت',
            matchNumber: 'المباراة رقم 62',
            scoreLink: '?region=-12&team=168&team2=361',
        },
    ];

    handleSeasonChange(event) {
        this.selectedSeason = event.target.value;
    }

    handleStageChange(event) {
        this.selectedStage = event.target.value;
    }

    handleTableChange(event) {
        this.selectedTable = event.target.value;
    }

    handleMatchDetails(event) {
        const matchId = event.target.dataset.matchId;
        // Handle match details logic here
        console.log('Match ID:', matchId);
    }
}
