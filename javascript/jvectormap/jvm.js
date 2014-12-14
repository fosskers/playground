$(function() {
    /*
    var gdpData = {
        "CA": 52,
        "JP": 30,
        "DE": 60,
        "TR": 5,
        "TH": 4,
        "AE": 40
    };

    $('#world-map').vectorMap({
        map: "world_mill_en",
        series: {
            regions: [{
                values: gdpData,
                scale: ['#C8EEFF', '#0071A4'],
                normalizeFunction: 'polynomial'
            }]
        },
        onRegionTipShow: function(e,el,code) {
            el.html(el.html() + ' GDP - ' + gdpData[code] + ')');
        }
    });
    */

    // --- //

    var cities = [
        {latLng: [49.53,-97.08], name: "Winnipeg"},
        {latLng: [49.25,-123.1], name: "Vancouver"},
        {latLng: [43.42,-79.24], name: "Toronto"},
        {latLng: [45.42,-75.7], name:  "Ottawa"},
        {latLng: [45.3,-73.34], name:  "Montreal"},
        {latLng: [53.32,-113.30], name:  "Edmonton"},
        {latLng: [51.03,-114.04], name:  "Calgary"},
        {latLng: [52.08,-106.41], name:  "Saskatoon"},
        {latLng: [46.49,-71.13], name:  "Quebec City"},
        {latLng: [44.38,-63.34], name:  "Halifax"},
        {latLng: [60.43,-135.03], name:  "Whitehorse"},
        {latLng: [62.26,-114.23], name:  "Yellowknife"},
        {latLng: [63.44,-68.31], name:  "Iqaluit"},
        {latLng: [47.34,-52.42], name:  "St. John's"}
    ];

    /*
    var cityAreas = [
        464.08,
        2877,
        630.21,
        501.92,
        431.5
    ];
    */
    
    var map;

    map = new jvm.Map({
        container: $("#canada"),
        map: "ca_lcc_en",
        backgroundColor: "transparent",
        regionsSelectable: true,
        markersSelectable: true,
        markers: cities,
        markerStyle: {
            initial:  {fill: '#ECEC62', r: 7},
            selected: {fill: '#4DAC26'}
        },
        regionStyle: {
            initial:  {fill: '#8d8d8d'}
        },
        /*
        series: {
            markers: [{
                attribute: 'r',
                scale: [5,10],
                values: cityAreas
            }]
        },*/
        onRegionSelected: function() {
            if(window.localStorage) {
                window.localStorage.setItem(
                    'jvectormap-selected-regions',
                    JSON.stringify(map.getSelectedRegions())
                );
            }
        },
        onMarkerSelected: function() {
            if(window.localStorage) {
                window.localStorage.setItem(
                    'jvectormap-selected-markers',
                    JSON.stringify(map.getSelectedMarkers())
                );
            }
        }
    });

    map.setSelectedMarkers(JSON.parse(window.localStorage.getItem(
        'jvectormap-selected-markers') || '[]' 
    ));
});
