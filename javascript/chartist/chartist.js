$(document).ready(function() {
    var data = {
        labels: ["July 1", "July 2", "July 3", "July 4", "July 5", "July 6"],
        series: [
            [85, 75, 3, 58, 80, 2, 66, 79, 68],
            [7, 86, 86, 33, 48, 80, 77, 33, 44]
        ]
    };

    var options = {
        low: 0,
        showArea: true
    };

    new Chartist.Line(".ct-chart", data, options);
});
