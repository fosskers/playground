var mymap = L.map('mapid').setView([49.205786, -122.905249], 13);

L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18
}).addTo(mymap);

var marker = L.marker([49.213086, -122.920385]).addTo(mymap);

/* Surround New West */
var newWest = {
  "features": [
    {
      "geometry": {
        "coordinates": [
          [
            [
              -122.95735359191893,
              49.19146457060401
            ],
            [
              -122.95735359191893,
              49.17502652733795
            ],
            [
              -122.94259071350098,
              49.1795713789234
            ],
            [
              -122.93598175048828,
              49.182601048138054
            ],
            [
              -122.9201889038086,
              49.194156971840606
            ],
            [
              -122.91435241699219,
              49.19219377707484
            ],
            [
              -122.91169166564941,
              49.19583964820061
            ],
            [
              -122.8955554962158,
              49.20599058111473
            ],
            [
              -122.88431167602539,
              49.21776529563745
            ],
            [
              -122.87658691406249,
              49.21995171955414
            ],
            [
              -122.87637233734131,
              49.229957579207735
            ],
            [
              -122.87499904632568,
              49.23119065415577
            ],
            [
              -122.89250850677492,
              49.23808409704783
            ],
            [
              -122.89495468139647,
              49.23805607686959
            ],
            [
              -122.89495468139647,
              49.23612264618164
            ],
            [
              -122.89568424224852,
              49.236150667456734
            ],
            [
              -122.89572715759276,
              49.235702325147614
            ],
            [
              -122.89783000946045,
              49.23519793518545
            ],
            [
              -122.9600143432617,
              49.20150423786907
            ],
            [
              -122.95104503631593,
              49.19443742187563
            ],
            [
              -122.95735359191893,
              49.19146457060401
            ]
          ]
        ],
        "type": "Polygon"
      },
      "properties": null,
      "type": "Feature"
    }
  ],
  "type": "FeatureCollection"
}

L.geoJson(newWest).addTo(mymap);

/* Add some popups */
marker.bindPopup("Welcome to New Westminster, the <b>Royal City</b>.");

/* Tell the user where they clicked */
var popup = L.popup();

function onMapClick(e) {
    popup.setLatLng(e.latlng)
        .setContent(e.latlng.toString())
        .openOn(mymap);
}

mymap.on('click', onMapClick);
