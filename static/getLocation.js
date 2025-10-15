// adapted from https://github.com/ColinFay/geoloc/blob/master/inst/js/geoloc.js
// Copyright (c) 2018 Colin Fay

function getLocation() {

  var lat_input = "identify_lat";
  var lon_input = "identify_lon";

  function sucess_pos(position) {
    Shiny.onInputChange(lat_input, position.coords.latitude);
    Shiny.onInputChange(lon_input, position.coords.longitude);
  }

  function error_pos(error) {
    switch(error.code){
      case error.PERMISSION_DENIED:
        Shiny.onInputChange(lat_input, "No se permitió acceder a su ubicación.");
        Shiny.onInputChange(lon_input, "No se permitió acceder a su ubicación.");
        break;
      case error.POSITION_UNAVAILABLE:
        Shiny.onInputChange(lat_input, "No fue posible determinar su ubicación, reintente.");
        Shiny.onInputChange(lon_input, "No fue posible determinar su ubicación, reintente.");
        break;
      case error.TIMEOUT:
        Shiny.onInputChange(lat_input, "Se agotó el tiempo máximo para determinar su ubicación.");
        Shiny.onInputChange(lon_input, "Se agotó el tiempo máximo para determinar su ubicación.");
        break;
    }
  }

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(sucess_pos, error_pos, {
      enableHighAccuracy:true,
      maximumAge:0,
      timeout:1000
    });
  } else {
    Shiny.onInputChange(id + "_lat", "El dispositivo no es capaz de determinar la ubicación.");
    Shiny.onInputChange(id + "_lon", "El dispositivo no es capaz de determinar la ubicación.");
  }
}

Shiny.addCustomMessageHandler("getLocation", function(message) { getLocation(); });
