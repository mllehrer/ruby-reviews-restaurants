$(document).ready(function() {
  initialize();
  infiniteScroll();
  respondEmail();

});

//maps
function initialize() {
  var mapCanvas = document.getElementById('map');
  var mapOptions = {
    zoom: 14,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  var map = new google.maps.Map(mapCanvas, mapOptions);
  $.get("/location", function(response) {
    var restaurantCount = response.length
    for (var i=0; i < restaurantCount; i++)
      makeMarker(response[i]);
  })

  var makeMarker = function(restaurant){
    var markerLoc = { lat: restaurant.latitude, lng: restaurant.longitude};
    var marker = new google.maps.Marker({
      position: markerLoc,
      map: map,
      title: restaurant.restaurant_name, visible:true
      });
  };


  // Try HTML5 geolocation.
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      map.setCenter(pos);
    }, function() {
      handleLocationError(true, infoWindow, map.getCenter());
    });
  } else {
    // Browser doesn't support Geolocation
    handleLocationError(false, infoWindow, map.getCenter());
  }
}
//end of initialize maps
function handleLocationError(browserHasGeolocation, infoWindow, pos) {
  infoWindow.setPosition(pos);
  infoWindow.setContent(browserHasGeolocation ?
    'Error: The Geolocation service failed.' :
    'Error: Your browser doesn\'t support geolocation.');
};
//end of map

//scroll
function infiniteScroll(){
    //location.href = 'index.html#start';
  var pages = new Array(); //key value array that maps the pages. Ex. 1=>page2.html, 2=>page3.html
  var current = 0; //the index of the starting page. 0 for index.html in this case
  var loaded = new Array(); //key value array to prevent loading a page more than once

  //get all the pages link inside the #pages div and fill an array
  $('#pages a').each(function(index) {
    pages[index] = $(this).attr('href');
    loaded[$(this).attr('href')] = 0; //initialize all the pages to be loaded to 0. It means that they are not yet been loaded.
  });

  //on scroll gets when bottom of the page is reached and calls the function do load more content
  $(window).scroll(function(e){
    //Not always the pos == h statement is verified, expecially on mobile devices, that's why a 300px of margin are assumed.
    if($(window).scrollTop() + $(window).height() >= $(document).height() - 300) {
      console.log("bottom of the page reached!");

      //in some broswer (es. chrome) if the scroll is fast, the bottom
      //reach events fires several times, this may cause the page loaging
      //more than once. To prevent such situation every time the bottom is
      //reached the number of time is added to that page in suach a way to call
      //the loadMoreContent page only when the page value in "loaded" array is
      //minor or equal to one
      loaded[pages[current+1]] = loaded[pages[current+1]] + 1;

      if(loaded[pages[current+1]] <= 1)
        loadMoreContent(current+1);
    }
  });

  //loads the next page and append it to the content with a fadeIn effect.
  //Before loading the content it shows and hides the loaden Overlay DIV
  function loadMoreContent(position) {
    //try to load more content only if the counter is minor than the number of total pages
    if(position < pages.length) {
      $('#loader').fadeIn('slow', function() {
        $.get(pages[position], function(data) {
          $('#loader').fadeOut('slow', function() {
            $('#review-container').append(data).fadeIn(999);
            current=position;
          });
        });
      });
    }
  }
}

//email form
var respondEmail = function(){
  $(document.body).on('submit', '#contact-form-id', function(e){
    console.log("hey")
    e.preventDefault();
    appendThanks(this)
  })
};

var appendThanks = function(){
  $.post("/contact", emailData)
  .done(function(thanksMessage){
    $("#contact-form").prepend(thanksMessage)
  })
};
