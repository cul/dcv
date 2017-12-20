// Map Display Component

$(function() {
  if ($('#cul-map-display-component').length) {
 	 $('#cul-map-display-component').html('<h2 style="margin:.5em;color:#ccc;">Loading...</h2>');
    setTimeout(function(){ initCulMapDisplayComponent(); }, 100); //Better user experience if this is asynchronous.
  }
});

var map;
var marker;
var tiles;

function initCulMapDisplayComponent() {
	  if($('#cul-map-display-component.full-map-search').length > 0) {
		  $(window).on('resize', function(){
		    $('#cul-map-display-component.full-map-search').height($(window).height()-300);
		  });
	    $('#cul-map-display-component.full-map-search').height($(window).height()-300);
	  }

		tiles = L.tileLayer('https://stamen-tiles.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}.png', {
			maxZoom: 18,
			attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors.'
		});

    if ( DCV.centerLat && DCV.centerLong ) {
			var latlng = L.latLng(DCV.centerLat, DCV.centerLong);
		} else {
			var latlng = L.latLng('40.7400', '-73.9802');
		}

		map = L.map('cul-map-display-component', {center: latlng, zoom: 11, layers: [tiles]});


		var markers = L.markerClusterGroup({spiderfyOnMaxZoom: false});

		var allPoints = [];

		for (var i = 0; i < DCV.mapPlanes.length; i++) {
			var a = DCV.mapPlanes[i];

			var latAndLong = a['c'].split(',');
			var lat = latAndLong[0];
			var lng = latAndLong[1];
			var title = a['t'];
			var itemLink = '/durst/' + a['id'];
			var thumbnailUrl = a['b'] == 'y' ? DCV.bookIconUrl : DCV.mapImageThumbTemplate.replace('_document_id_', a['id']);

			var marker = L.marker(new L.LatLng(lat, lng), { title: title });
			allPoints.push([lat,lng]);
			if (!$('#cul-map-display-component').hasClass('no-popup')) {
				marker.bindPopup(
					'<a href="' + itemLink + '" class="thumbnail"><img src="' + thumbnailUrl + '" /></a>' + '<br />' + '<a href="' + itemLink + '">' + title + '</a>'
				);
			}
			markers.addLayer(marker);
		}

		if ( !DCV.centerLat && !DCV.centerLong && allPoints.length > 0) {
			map.fitBounds(allPoints);
		}

		markers.on('clusterclick', function (a) {

			var maxItemsToShow = 5;

			if (map.getZoom() == map.getMaxZoom()) {
					var allItemHtml = '';
					var childMarkers = a.layer.getAllChildMarkers();

					var viewAllUrl = DCV.mapCoordinateSearchUrl.replace('_lat_', childMarkers[0].getLatLng().lat).replace('_long_', childMarkers[0].getLatLng().lng);

					allItemHtml += '<h6>' + childMarkers.length + ' items found <a class="pull-right" href="' + viewAllUrl + '">View all &raquo &nbsp;</a></h6>';
					allItemHtml += '<div style="max-height:200px;max-width:200px;width:100%;overflow:auto;">'

					var numItemsToShow = childMarkers.length;
					if (childMarkers.length > maxItemsToShow) {
						numItemsToShow = maxItemsToShow;
					}

					for(var i = 0; i < numItemsToShow; i++) {
						var marker = childMarkers[i];
						allItemHtml += marker.getPopup().getContent() + '<hr />';
					}

					if (childMarkers.length > maxItemsToShow) {
						allItemHtml += '<a href="' + viewAllUrl + '">Click here to see the rest &raquo;</a><br />';
					}

					allItemHtml += '</div>';

					L.popup()
					.setLatLng(a.layer.getAllChildMarkers()[0].getLatLng())
					.setContent(allItemHtml)
					.openOn(map);
			}
		});

		map.on('popupopen', function(e) {
			var px = map.project(e.popup._latlng);
			px.y -= e.popup._container.clientHeight/2
			map.panTo(map.unproject(px),{animate: true});
		});

		map.addLayer(markers);

    // Collapse copyright and attribution info into clickable, expandable icon
    $('.leaflet-control-attribution').wrapInner('<span id="map-attrib-text" class="hidden"/>').append(
      '<div id="map-attrib-icon" class="pull-right text-danger"><i class="glyphicon glyphicon-copyright-mark"></i></div>'
    );
    $('body').on('click', '#map-attrib-icon', function() {
      $('#map-attrib-text').toggleClass('hidden');
    });
}
