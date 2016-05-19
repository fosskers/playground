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
              -122.96016454696655,
              49.20192484983896
            ],
            [
              -122.95022964477538,
              49.194717870320645
            ],
            [
              -122.95743942260741,
              49.191184103714676
            ],
            [
              -122.95726776123047,
              49.17508263916105
            ],
            [
              -122.93675422668457,
              49.18293766660195
            ],
            [
              -122.93306350708006,
              49.18585493070746
            ],
            [
              -122.92551040649414,
              49.189669555036446
            ],
            [
              -122.9201889038086,
              49.19443742187563
            ],
            [
              -122.89572715759276,
              49.20638311678337
            ],
            [
              -122.88044929504393,
              49.21972747539876
            ],
            [
              -122.88293838500977,
              49.23149891808389
            ],
            [
              -122.894868850708,
              49.2366550476901
            ],
            [
              -122.95872688293456,
              49.202681942369786
            ],
            [
              -122.96016454696655,
              49.20192484983896
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
