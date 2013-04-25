//= require highcharts
//= require highcharts/highcharts-more

$(function () {
    if ($('[data-chart]').length) {
        $('[data-chart]').each(function(){
            render_chart($(this));
        });
    }
});

function render_chart($dataChart) {
    $($dataChart.data('target')).highcharts({
        chart: {
            type: 'line',
            marginRight: 40,
            marginBottom: 75,
            backgroundColor: "rgba(0,0,0,0)"
        },
        title: {
            text: 'Daily Activity',
            x: 0,
            useHTML: true,
            style: {
                fontSize: '18px',
                fontWeight: 'bold',
                color: 'black'
            }
        },
        xAxis: {
            type: 'datetime'
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
        series: $dataChart.data('series')
    });
}
