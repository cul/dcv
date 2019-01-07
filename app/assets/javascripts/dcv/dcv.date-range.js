window.DCV = window.DCV || function(){};
/*********************
 * Date Range Slider *
 *********************/

DCV.DateRangeSlider = {};
DCV.DateRangeSlider.init = function() {
  //$("#sidebar-date-range-slider").slider({
  //  min: DCV.dateWidgetData['earliest_start_year'],
  //  max: DCV.dateWidgetData['latest_end_year'],
  //  step: 1,
  //  values: [DCV.dateWidgetData['earliest_start_year'], DCV.dateWidgetData['latest_end_year']],
  //  slide: function(event, ui) {
  //      for (var i = 0; i < ui.values.length; ++i) {
  //          $("#sidebar-date-range-selector input.sliderValue[data-index=" + i + "]").val(ui.values[i]);
  //      }
  //  }
  //});
  //$("#sidebar-date-range-selector input.sliderValue[data-index=0]").val(DCV.dateWidgetData['earliest_start_year']);
  //$("#sidebar-date-range-selector input.sliderValue[data-index=1]").val(DCV.dateWidgetData['latest_end_year']);
  //$("#sidebar-date-range-selector input.sliderValue").change(function() {
  //    var $this = $(this);
  //    $("#sidebar-date-range-slider").slider("values", $this.data("index"), $this.val());
  //});
  //$('#sidebar-date-range-selector').on('submit', function(){
  //  e.preventDefault();
  //  alert('submit');
  //  DCV.DateRangeSlider.filterBySelectedDateRange();
  //  return false;
  //});
  $('#sidebar-date-range-set-btn').on('click', function(){
    DCV.DateRangeSlider.filterBySelectedDateRange();
    return false;
  });
};
DCV.DateRangeSlider.filterBySelectedDateRange = function() {
  var newStartYearFilter = $("#sidebar-date-range-selector input.sliderValue[data-index=0]").val();
  var newEndYearFilter = $("#sidebar-date-range-selector input.sliderValue[data-index=1]").val();
  var redirecUrl = decodeURIComponent(DCV.newDateFilterTemplateUrl).replace('_start_year_', newStartYearFilter).replace('_end_year_', newEndYearFilter);
  window.location = redirecUrl;
};

/****************************
 * Date Range GraphSelector *
 ****************************/

DCV.DateRangeGraphSelector = {};
DCV.DateRangeGraphSelector.initialized = false;
DCV.DateRangeGraphSelector.lastClickEvent = null;

DCV.DateRangeGraphSelector.dateCache = null;

DCV.DateRangeGraphSelector.init = function() {
  if ($('#date-range-widget').length > 0 && DCV.dateWidgetData != null) {
    DCV.DateRangeGraphSelector.initialized = true;
    $('#date-range-widget').html('<canvas id="date-range-canvas" width="1000" height="150"></canvas>');
    var canvasJQueryElement = $('#date-range-canvas');
    canvasJQueryElement.attr('data-original-width', canvasJQueryElement[0].width).attr('data-original-height', canvasJQueryElement[0].height);
    DCV.DateRangeGraphSelector.resizeCanvas();
    $(window).on('resize', DCV.DateRangeGraphSelector.resizeCanvas);
    canvasJQueryElement.on('mousedown', function(e1){
      var e1ParentOffset = $(this).offset();
      var canvasXLocation = e1.pageX - e1ParentOffset.left;
      var canvasYLocation = e1.pageY - e1ParentOffset.top;

      $('#date-range-canvas').attr('data-begin-drag', 'true');
      $('#date-range-canvas').attr('data-drag-start-x', canvasXLocation);
      $("#date-range-canvas").on('mousemove.daterange', function(e2){
      if($('#date-range-canvas').attr('data-begin-drag') == 'true') {

          var e2ParentOffset = $(this).offset();
          var canvasXDragLocation = e2.pageX - e2ParentOffset.left;
          var canvasYDragLocation = e2.pageY - e2ParentOffset.top;

          $('#date-range-canvas').attr('data-drag-end-x', canvasXDragLocation);
          DCV.DateRangeGraphSelector.render();
        }
      });
      $(window).on('mouseup.daterange', function(e){
        if ($('#date-range-canvas').attr('data-begin-drag') == 'true') {
          $('#date-range-canvas').attr('data-begin-drag', 'false');
          $(window).off('.daterange'); //Remove .daterange listeners so that we're not constantly listening for mousemove and mouseup events
          //And redirect to the correct date range selection
          var newStartYearFilter = $('#date-range-canvas').attr('data-new-start-year-filter');
          var newEndYearFilter = $('#date-range-canvas').attr('data-new-end-year-filter');
          if (newStartYearFilter != 'NaN' && newStartYearFilter != 'NaN') {
            var redirectUrl = decodeURIComponent(DCV.newDateFilterTemplateUrl).replace('_start_year_', newStartYearFilter).replace('_end_year_', newEndYearFilter);
            DCV.DateRangeGraphSelector.clearSelectedRegionIndicator();
            window.location = redirectUrl;
          }
        }
      });
    });
  }
};

DCV.DateRangeGraphSelector.clearSelectedRegionIndicator = function() {
  var newStartYearFilter = $('#date-range-canvas').removeAttr('data-drag-start-x');
  var newEndYearFilter = $('#date-range-canvas').removeAttr('data-drag-end-x');
  DCV.DateRangeGraphSelector.render();
};

DCV.DateRangeGraphSelector.resizeCanvas = function() {

  if ( ! DCV.DateRangeGraphSelector.initialized ) { return; }

  // Make sure that actual canvas dimensions are equal to the current size
  // so that we don't get anti-aliased rescaling.  This will look sharper.

  var c = document.getElementById('date-range-canvas');
  var aspectRatio = parseInt($(c).attr('data-original-width'))/parseInt($(c).attr('data-original-height'));
  var canvasWidth = $(c).width();
  var canvasHeight = canvasWidth/aspectRatio;
  $(c).height(canvasHeight);

  c.width = canvasWidth;
  c.height = canvasHeight;

  DCV.DateRangeGraphSelector.render();
};

DCV.DateRangeGraphSelector.render = function() {

  if ( ! DCV.DateRangeGraphSelector.initialized ) { return; }

  var c = document.getElementById('date-range-canvas');

  var ctx = c.getContext('2d');

  ctx.clearRect ( 0 , 0 , c.width , c.height ); //clear canvas

  var segmentColors = {
    low: [80, 80, 80],
    high: [110, 110, 110]
  };
  var textYOffset = c.height/7;
  var fontSize = c.height/9;
  var textXOffset = fontSize/6+1;

  ctx.lineWidth   = 1;
  ctx.strokeStyle = '#666666';
  ctx.fillStyle   = '#000';

  // DCV.dateWidgetData is declared in-page, generated server-side.
  var startOfRange = DCV.dateWidgetData['start_of_range'];

  var segments = DCV.dateWidgetData['segments'];
  var yearsPerSegment = DCV.dateWidgetData['years_per_segment'];
  var highestSegmentCountValue = DCV.dateWidgetData['highest_segment_count_value'];

  var numSegments = segments.length;

  var padding = c.width/14;
  var segmentWidth = (c.width-padding*2)/numSegments;

  //Draw bounding box
  for(var i = 0; i < numSegments; i++) {

    //Segment blocks
    var segment = segments[i];
    var proportionalHeight = (segment['count']/(highestSegmentCountValue));

    //Post-processing to move values toward the center, making it look better
    if (proportionalHeight > 0) {
      var centerWeighting = .1;
      proportionalHeight = proportionalHeight+(centerWeighting*(.5-proportionalHeight));
    }
    ctx.fillStyle = DCV.DateRangeGraphSelector.getColorFromRangeAndIntensity(segmentColors['low'], segmentColors['high'], proportionalHeight);
    ctx.fillRect(  padding+i*segmentWidth, c.height-1, segmentWidth, (-c.height+(fontSize*1.5))*proportionalHeight);

    //Segment dividing lines
    ctx.strokeStyle = '#222';
    ctx.beginPath();
    ctx.moveTo(padding+i*segmentWidth, 0);
    ctx.lineTo(padding+i*segmentWidth, c.height-1);
    ctx.stroke();

  }

  // Render text separately so that it's always on top of the bars

  var dateMarkersToRender = [0, .25, .50, .75]; // End is always marked
  var dateMarkerCounter = 0;

  for(var i = 0; i < numSegments; i++) {

    var segment = segments[i];
    if (i/numSegments >= dateMarkersToRender[dateMarkerCounter]) {

      dateMarkerCounter++;

      //Draw line
      //Time dividing lines
      ctx.strokeStyle = '#555';
      ctx.beginPath();
      ctx.moveTo(padding+i*segmentWidth, 0);
      ctx.lineTo(padding+i*segmentWidth, c.height-1);
      ctx.stroke();

      //Draw year

      //if (segment['start'].toString().substring(0, 1) == '-') {
      //  var textToRender = segment['start'].toString().substring(1) + ' BCE';
      //} else {
      //  var textToRender = segment['start'].toString() + ' CE';
      //}
      var textToRender = segment['start'].toString();

      ctx.fillStyle = "#000";
      ctx.font = fontSize + "px 'Helvetica Neue'";
      ctx.fillText(textToRender, textXOffset+padding+i*segmentWidth-1, textYOffset-1);
      ctx.fillText(textToRender, textXOffset+padding+i*segmentWidth+1, textYOffset+1);
      ctx.fillStyle = "#ddd";
      ctx.fillText(textToRender, textXOffset+padding+i*segmentWidth, textYOffset);

    }

    if (i == numSegments-1) {

      //Draw Line
      ctx.beginPath();
      ctx.moveTo(padding+(i+1)*segmentWidth, 0);
      ctx.lineTo(padding+(i+1)*segmentWidth, c.height-1);
      ctx.stroke();

      //if (segment['end'].toString().substring(0, 1) == '-') {
      //  var textToRender = segment['end'].toString().substring(1) + ' BCE';
      //} else {
      //  var textToRender = segment['end'].toString() + ' CE';
      //}
      var textToRender = segment['end'];
      ctx.fillText(textToRender, textXOffset+padding+(i+1)*segmentWidth, textYOffset);
    }
  }

  //Overlay with drag
  var overlayXStart = parseInt($('#date-range-canvas').attr('data-drag-start-x'));
  var overlayXEnd = parseInt($('#date-range-canvas').attr('data-drag-end-x'));

  //Ignore accidental clicks
  if (overlayXStart == overlayXEnd) {
    $('#date-range-canvas').attr('data-new-start-year-filter', 'NaN');
    $('#date-range-canvas').attr('data-new-end-year-filter', 'NaN');
  } else {

    if(overlayXStart < overlayXEnd) {
      var startOfPixelRange = overlayXStart;
      var endOfPixelRange = overlayXEnd;
    } else {
      var startOfPixelRange = overlayXEnd;
      var endOfPixelRange = overlayXStart;
    }

    //Apply padding corrections
    startOfPixelRange -= padding;
    endOfPixelRange -= padding;

    var fullPixelRange = segmentWidth*numSegments;

    var dateRangeInYears = numSegments*yearsPerSegment;
    var newStartYearFilter = Math.round((startOfPixelRange/fullPixelRange)*dateRangeInYears)+startOfRange;
    var newEndYearFilter = Math.round((endOfPixelRange/fullPixelRange)*dateRangeInYears)+startOfRange;

    $('#date-range-canvas').attr('data-new-start-year-filter', newStartYearFilter);
    $('#date-range-canvas').attr('data-new-end-year-filter', newEndYearFilter);

    ctx.globalAlpha=0.5;
    ctx.fillRect(  overlayXStart, 0, overlayXEnd-overlayXStart, c.height);
    ctx.globalAlpha=1.0;
  }

};

/**
 * @param: rgbStartArr -> [48, 48, 48]
 * @param: rgbEnd -> [96, 96, 96]
 * @param: intensity -> .3
 */
DCV.DateRangeGraphSelector.getColorFromRangeAndIntensity = function(rgbStartArr, rgbEndArr, intensity) {
  var r = (rgbStartArr[0] * (1.0-intensity)) + (rgbEndArr[0] * intensity);
  var g = (rgbStartArr[1] * (1.0-intensity)) + (rgbEndArr[1] * intensity);
  var b = (rgbStartArr[2] * (1.0-intensity)) + (rgbEndArr[2] * intensity);
  return 'rgb(' + parseInt(r) + ', ' + parseInt(g) + ', ' + parseInt(b) + ')';
  //return 'rgb(0, 0, 255)';
};
