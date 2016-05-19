var mymap = L.map('mapid').setView([49.205786, -122.905249], 13);

L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18
}).addTo(mymap);

var marker = L.marker([49.213086, -122.920385]).addTo(mymap);

var polygon = L.polygon([
    [49.201388, -122.959870],
    [49.194405, -122.951217],
    [49.191350, -122.957188],
    [49.175192, -122.957017],
    [49.181476, -122.938477],
    [49.219781, -122.878310],
    [49.230768, -122.874962],
    [49.237829, -122.892300]
]).addTo(mymap);

/* Add some popups */
marker.bindPopup("Welcome to New Westminster, the <b>Royal City</b>.");
