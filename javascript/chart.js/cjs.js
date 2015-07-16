$(document).ready(function() {
    console.log("Testing Chart.js...");

    var data = {
        labels: ["July 1", "July 2", "July 3", "July 4", "July 5", "July 6"],
        datasets: [
            {
                label: "Strays",
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: [85, 75, 3, 58, 80, 2, 66, 79, 68]
            },
            {
                label: "House Cats",
                fillColor: "rgba(151,187,205,0.2)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(151,187,205,1)",
                data: [7, 86, 86, 33, 48, 80, 77, 33, 44]
            }
        ]
    };
    
    var ctx = $("#the-chart").get(0).getContext("2d");
    var chart = new Chart(ctx).Line(data, {
        responsive: true,
        multiTooltipTemplate: "<%=datasetLabel%> : <%= value %>"
    });


    var data2 = {
        labels: ["May 1", "May 2", "May 3", "May 4", "May 5", "May 6"],
        datasets: [
            {
                label: "Strays",
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: [85, 75, 3, 58, 80, 2, 66, 79, 68]
            },
            {
                label: "House Cats",
                fillColor: "rgba(151,187,205,0.2)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(151,187,205,1)",
                data: [7, 86, 86, 33, 48, 80, 77, 33, 44]
            }
        ]
    };
    
    var ctx2 = $("#the-other").get(0).getContext("2d");
    var chart = new Chart(ctx2).Line(data2, {
        responsive: true,
        multiTooltipTemplate: "<%=datasetLabel%> : <%= value %>"
    });
});
