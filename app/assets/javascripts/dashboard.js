//= require highcharts
//= require highcharts/highcharts-more

$(function () {
    if ($("#moderator_dashboard").length)
        render_chart($("#moderator_dashboard #graph"));
});

function render_chart($region) {
    $region.highcharts({
        chart: {
            type: 'line',
            marginRight: 40,
            marginBottom: 75
        },
        title: {
            text: 'Site Statistics',
            x: -20 //center
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b',
                day: '%b'
            }
        },
        yAxis: {
            title: {
                text: 'Total'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    Highcharts.dateFormat('%e. %b', this.x) +': '+ this.y +' m';
            }
        },
        series: [{

            name: 'Users',
            data: [
                [Date.UTC(2013,  1, 12), 6.9],
                [Date.UTC(2013,  1, 27), 7.0],
                [Date.UTC(2013,  2, 1) , 18.2],
                [Date.UTC(2013,  2, 2), 21.5],
                [Date.UTC(2013,  2, 5), 25.2],
                [Date.UTC(2013,  2, 8), 26.5],
                [Date.UTC(2013,  2, 14), 14.5],
                [Date.UTC(2013,  2, 17), 23.3],
                [Date.UTC(2013,  3, 1), 18.3],
                [Date.UTC(2013,  3, 5), 13.9],
                [Date.UTC(2013,  3, 9), 9.6]
            ]
        }]
    });
}