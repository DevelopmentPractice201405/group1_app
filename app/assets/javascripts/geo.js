$(function() {
    function get_address() {
        navigator.geolocation.watchPosition(
            function(position) {
                var lat = position.coords.latitude;
                var lng = position.coords.longitude;

                var url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + lng + "&sensor=true";

                console.log(url);
                $.getJSON(
                    url,
                    function(data, status) {
                        console.log(data);
                        if(data['status'] == "OK") {
                            console.log("test");
                            address = data['results'][2]['formatted_address'];
                            console.log(address);
                            $('#micropost_locate').val(address);
                        } 
                    }
                );
            }
        );
    }
    get_address();
});
