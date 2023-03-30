mapboxgl.accessToken = 'pk.eyJ1IjoiYWxpY2pha290YXJiYSIsImEiOiJja2d1d3Fzb3Mxc2I5MzBsOGd4amZycDVyIn0.KPIYSMxgWGRZ3IBRHNamag';
    var map = new mapboxgl.Map({
    container: 'map', // container id
    style: 'mapbox://styles/alicjakotarba/ckguxoq3y2mbc19r1g8d4j854', // style URL
    center: [-0.104345,51.514756], // starting position [lng, lat]
    zoom: 11 // starting zoom
    });

const boroughs = './data/boroughs.geojson'
const geo17 = './data/geo17.geojson'
const geo18 = './data/geo18.geojson'
const geo19 = './data/geo19.geojson'
const geo20 = './data/geo20.geojson'
const geo21 = './data/geo21.geojson'

console.log(geo17)
var hoveredStateId = null;

map.on('load', function () {
    map.addSource('boroughs17', {
        'type': 'geojson',
        'data': geo17,
        'generateId': true
        });
    map.addSource('boroughs18', {
        'type': 'geojson',
        'data': geo18,
        'generateId': true
        });
    map.addSource('boroughs19', {
        'type': 'geojson',
        'data': geo19,
        'generateId': true
        });
    map.addSource('boroughs20', {
        'type': 'geojson',
        'data': geo20,
        'generateId': true
        });
    map.addSource('boroughs21', {
        'type': 'geojson',
        'data': geo21,
        'generateId': true
        });          
        
    // 2017
    map.addLayer({
        'id': 'boroughs17',
        'type': 'fill',
        'source': 'boroughs17',
        'layout': {
            // Make layer visible by default
          'visibility': 'visible'
        //   'visibility': 'none'
        },
        'paint': {
        'fill-color': 
        ["step",["get","AM peak (07:00-10:00)"],
        "#ffeda0",20,"#ffeda0",40,"#fed976",60,"#feb24c",80,
        "#fd8d3c",100,"#fc4e2a",120,"#e31a1c",140,
        "hsl(348, 100%, 37%)",1000,"#bd0026"],
        'fill-opacity': 0.5
        }
    });

    // 2018 
    map.addLayer({
        'id': 'boroughs18',
        'type': 'fill',
        'source': 'boroughs18',
        'layout': {
            // Make layer visible by default
        'visibility': 'none'
        },
        'paint': {
        'fill-color': 
        ["step",["get","AM peak (07:00-10:00)"],
        "#ffeda0",20,"#ffeda0",40,"#fed976",60,"#feb24c",80,
        "#fd8d3c",100,"#fc4e2a",120,"#e31a1c",140,
        "hsl(348, 100%, 37%)",1000,"#bd0026"],
        'fill-opacity': 0.5
        }
    });
  
    // 2019 
    map.addLayer({
        'id': 'boroughs19',
        'type': 'fill',
        'source': 'boroughs19',
        'layout': {
            // Make layer visible by default
        'visibility': 'none'
        },
        'paint': {
        'fill-color': 
        ["step",["get","AM peak (07:00-10:00)"],
        "#ffeda0",20,"#ffeda0",40,"#fed976",60,"#feb24c",80,
        "#fd8d3c",100,"#fc4e2a",120,"#e31a1c",140,
        "hsl(348, 100%, 37%)",1000,"#bd0026"],
        'fill-opacity': 0.5
        }
        });
    
    // 2020 AM PEAK
    map.addLayer({
        'id': 'boroughs20',
        'type': 'fill',
        'source': 'boroughs20',
        'layout': {
            // Make layer visible by default
        'visibility': 'none'
        },
        'paint': {
        'fill-color': 
        ["step",["get","AM peak (07:00-10:00)"],
        "#ffeda0",20,"#ffeda0",40,"#fed976",60,"#feb24c",80,
        "#fd8d3c",100,"#fc4e2a",120,"#e31a1c",140,
        "hsl(348, 100%, 37%)",1000,"#bd0026"],
        'fill-opacity': 0.5
        }
        });
   
    // 2021 
    map.addLayer({
        'id': 'boroughs21',
        'type': 'fill',
        'source': 'boroughs21',
        'layout': {
            // Make layer visible by default
        'visibility': 'none'
        },
        'paint': {
        'fill-color': 
        ["step",["get","AM peak (07:00-10:00)"],
        "#ffeda0",20,"#ffeda0",40,"#fed976",60,"#feb24c",80,
        "#fd8d3c",100,"#fc4e2a",120,"#e31a1c",140,
        "hsl(348, 100%, 37%)",1000,"#bd0026"],
        'fill-opacity': 0.5
        }
        });
    
    map.addLayer({
        'id': 'boroughsBorders',
        'type': 'line',
        'source': 'boroughs17',
        'layout': {},
        'paint': {
            'line-color': 'black',
            'line-width': 1
        }
        });

    //slider event listener - changes visibility by year
    document.getElementById('slider').addEventListener('input', function(e) {
        var year = parseInt(e.target.value);
        document.getElementById('year').textContent = year;

        switch(year) {
            case 2017:
                map.setLayoutProperty('boroughs17', 'visibility', 'visible');
                map.setLayoutProperty('boroughs18', 'visibility', 'none');
                map.setLayoutProperty('boroughs19', 'visibility', 'none');
                map.setLayoutProperty('boroughs20', 'visibility', 'none');
                map.setLayoutProperty('boroughs21', 'visibility', 'none');
                break;
            case 2018:
                map.setLayoutProperty('boroughs17', 'visibility', 'none');
                map.setLayoutProperty('boroughs18', 'visibility', 'visible');
                map.setLayoutProperty('boroughs19', 'visibility', 'none');
                map.setLayoutProperty('boroughs20', 'visibility', 'none');
                map.setLayoutProperty('boroughs21', 'visibility', 'none');
                break;
            case 2019:
                map.setLayoutProperty('boroughs17', 'visibility', 'none');
                map.setLayoutProperty('boroughs18', 'visibility', 'none');
                map.setLayoutProperty('boroughs19', 'visibility', 'visible');
                map.setLayoutProperty('boroughs20', 'visibility', 'none');
                map.setLayoutProperty('boroughs21', 'visibility', 'none');
                break;
            case 2020:
                map.setLayoutProperty('boroughs17', 'visibility', 'none');
                map.setLayoutProperty('boroughs18', 'visibility', 'none');
                map.setLayoutProperty('boroughs19', 'visibility', 'none');
                map.setLayoutProperty('boroughs20', 'visibility', 'visible');
                map.setLayoutProperty('boroughs21', 'visibility', 'none');
                break;
            case 2021:
                map.setLayoutProperty('boroughs17', 'visibility', 'none');
                map.setLayoutProperty('boroughs18', 'visibility', 'none');
                map.setLayoutProperty('boroughs19', 'visibility', 'none');
                map.setLayoutProperty('boroughs20', 'visibility', 'none');
                map.setLayoutProperty('boroughs21', 'visibility', 'visible');
                break;
        }
    });

    //radio button event listener
    document.getElementById('filters').addEventListener('change', function(e) {
        var time = e.target.value;
        var colorFilter;
        console.log(time);

        if (time == 'am') {
            colorFilter = ["step",["get","AM peak (07:00-10:00)"],
        "#ffeda0",20,"#ffeda0",40,"#fed976",60,"#feb24c",80,
        "#fd8d3c",100,"#fc4e2a",120,"#e31a1c",140,
        "hsl(348, 100%, 37%)",1000,"#bd0026"]
            map.setPaintProperty('boroughs17', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs18', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs19', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs20', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs21', 'fill-color', colorFilter);
        } else if (time == 'pm') {
            colorFilter = ["step",["get","PM peak (16:00-19:00)"],
        "#ffeda0",20,"#ffeda0",40,"#fed976",60,"#feb24c",80,
        "#fd8d3c",100,"#fc4e2a",120,"#e31a1c",140,
        "hsl(348, 100%, 37%)",1000,"#bd0026"]
            map.setPaintProperty('boroughs17', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs18', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs19', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs20', 'fill-color', colorFilter);
            map.setPaintProperty('boroughs21', 'fill-color', colorFilter);
        }
        console.log(colorFilter);

        
    });


    //legend
    var layers = ['20–40', '40–60', '60–80', '80–100', '100–120', '120–140', '140–1000', '1000+'];
    var colors = ["#ffeda0", "#fed976", "#feb24c", "#fd8d3c", "#fc4e2a", "#e31a1c", "hsl(348, 100%, 37%)", "#bd0026"]
    
    var i;
    for (i = 0; i < layers.length; i++) {
        var layer = layers[i];
        var color = colors[i];
        var item = document.createElement('div');
        var key = document.createElement('span');
        key.className = 'legend-key';
        key.style.backgroundColor = color;

        var value = document.createElement('span');
        value.innerHTML = layer;
        item.appendChild(key);
        item.appendChild(value);
        legend.appendChild(item);
    }

});


    //map.on('mousemove', 'boroughs17', function (e) {
      //  if (e.features.length > 0) {
        //if (hoveredStateId) {
        //map.setFeatureState(
        //{ source: 'boroughs17', id: hoveredStateId },
        //{ hover: false }
        //);
        //}
        //hoveredStateId = e.features[0].id;
        //map.setFeatureState(
        //{ source: 'boroughs17', id: hoveredStateId },
        //{ hover: true }
        //);
        //}
        //});
         
        // When the mouse leaves the state-fill layer, update the feature state of the
        // previously hovered feature.
        //map.on('mouseleave', 'boroughs17', function () {
        //if (hoveredStateId) {
        //map.setFeatureState(
        //{ source: 'boroughs17', id: hoveredStateId },
        //{ hover: false }
        //);
        //}
        //hoveredStateId = null;
//});

    
