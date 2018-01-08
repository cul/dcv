// Map Display Component

$(function() {
  if ($('#cul-map-display-component').length) {
 	 $('#cul-map-display-component').html('<h2 class="loading-text" style="margin:.5em;color:#ccc;">Loading...</h2>');
    setTimeout(function(){
      //Better user experience if this is asynchronous.
      initCulMapDisplayComponent($('#cul-map-display-component').attr('data-subsite-key'));
      $('#cul-map-display-component .loading-text').html(''); //clear loading message
    }, 100);
  }
});

var map;
var marker;
var tiles;

function initCulMapDisplayComponent(subsiteKey) {
	  if($('#cul-map-display-component.full-map-search').length > 0) {
		  $(window).on('resize', function(){
		    $('#cul-map-display-component.full-map-search').height($(window).height()-300);
		  });
	    $('#cul-map-display-component.full-map-search').height($(window).height()-300);
	  }

		tiles = L.tileLayer('https://stamen-tiles.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}.png', {
			maxZoom: 13,
			attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors.'
		});

    //Get map center coordinate
    if (typeof(DCV.defaultCenterLat) !== 'undefined' && typeof(DCV.defaultCenterLong) !== 'undefined' &&
      DCV.defaultCenterLat != null && DCV.defaultCenterLong != null) {
      //If centerLat and centerLong are set, use those points for the center.
			var defaultCenterLatLong = L.latLng(DCV.defaultCenterLat, DCV.defaultCenterLong);
		} else if(DCV.mapPlanes.length > 0) {
      //Use first point in mapPlanes data
      var firstMapPlaneCoordinateLatAndLong = DCV.mapPlanes[0]['c'].split(',');
			var defaultCenterLatLong = L.latLng(firstMapPlaneCoordinateLatAndLong[0], firstMapPlaneCoordinateLatAndLong[1]);
		} else {
      // Fall back to Columbia University coordinates (Why not? It looks better on a map than the middle of the Atlantic Ocean.)
      var defaultCenterLatLong = L.latLng(40.8075, -73.9626);
    }

    //Get map default zoom level
    if ( typeof(DCV.mapDefaultZoomLevel) !== 'undefined') {
      //If centerLat and centerLong are set, use those points for the center.
			var defaultZoomLevel = DCV.mapDefaultZoomLevel;
		} else {
      var defaultZoomLevel = 11;
    }

		map = L.map('cul-map-display-component', {
      center: defaultCenterLatLong,
      zoom: defaultZoomLevel,
      layers: [tiles]
    });

		var markers = L.markerClusterGroup({spiderfyOnMaxZoom: false});

		var allPoints = [];

		for (var i = 0; i < DCV.mapPlanes.length; i++) {
			var a = DCV.mapPlanes[i];

			var latAndLong = a['c'].split(',');
			var lat = latAndLong[0];
			var lng = latAndLong[1];
			var title = a['t'];
			var itemLink = '/' + subsiteKey + '/' + a['id'];
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

    // Assuming that we're not forcing the map to use the default certer lat/long
    // as our focus, and assuming that we have at least one point on the map, set
    // the map bounds so that all plotted points are visible.
		if (!DCV.forceUseDefaultCenter && allPoints.length > 0) {
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
