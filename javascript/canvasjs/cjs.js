$(document).ready(function() {
    var chart = new CanvasJS.Chart("the-chart", {
        title: {text: "Cat Sightings"},
        theme: "theme2",
        animationEnabled: true,
        toolTip: { shared: "true" },
        data: [
            {
                type: "spline",
                showInLegend: true,
                name: "Stray Cats",
                //markerSize: 1,
                dataPoints: [
                    {x: new Date(2015,7,1), y: 85},
                    {x: new Date(2015,7,2), y: 75},
                    {x: new Date(2015,7,3), y: 3},
                    {x: new Date(2015,7,4), y: 58},
                    {x: new Date(2015,7,5), y: 80},
                    {x: new Date(2015,7,6), y: 2},
                    {x: new Date(2015,7,7), y: 66},
                    {x: new Date(2015,7,8), y: 79},
                    {x: new Date(2015,7,9), y: 68}
                ]
            },
            {
                type: "spline",
                showInLegend: true,
                name: "House Cats",
                //markerSize: 1,
                dataPoints: [
                    {x: new Date(2015,7,1), y: 7},
                    {x: new Date(2015,7,2), y: 86},
                    {x: new Date(2015,7,3), y: 86},
                    {x: new Date(2015,7,4), y: 33},
                    {x: new Date(2015,7,5), y: 48},
                    {x: new Date(2015,7,6), y: 80},
                    {x: new Date(2015,7,7), y: 77},
                    {x: new Date(2015,7,8), y: 33},
                    {x: new Date(2015,7,9), y: 44}
                ]
            }
        ]
    });

    chart.render();
});
