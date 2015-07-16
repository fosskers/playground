$(document).ready(function() {
    $('#the-chart').highcharts({
        chart: {
            type: 'areaspline' 
        },
        title: {
            text: 'Cat Sightings',
            x: -20 //center
        },
        subtitle: {
            text: 'Source: My Extensive Research',
            x: -20
        },
        xAxis: {
            categories: ['July 1','July 2','July 3','July 4','July 5','July 6','July 7']
        },
        yAxis: {
            title: {
                text: 'Sightings'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            shared: true,
            valueSuffix: ' Cats'
        },
        /*
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        */
        series: [{
            name: 'Strays',
            data: [85, 75, 3, 58, 80, 2, 66]
        },
        {
            name: 'House Cats',
            data: [7, 86, 86, 33, 48, 80, 77]
        }]
    });
});
