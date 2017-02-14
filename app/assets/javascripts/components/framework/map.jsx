var Map = React.createClass({
    getInitialState() {
        return {
            api_key: null,
        }
    },
    componentDidMount() {
        $.ajax({
            url: Routes.static_map_data_path(),
            dataType: 'json',
            contentType: 'application/json',
            type: ACTION_GET,
            success: function (data) {
                // console.log("data " + JSON.stringify(data));
                const state = {
                    api_key: data['api_key'],
                };
                this.setState(state);
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                console.log("errors: " + JSON.stringify(err));
                this.setState({errors: json, captcha: ''});
            }.bind(this)
        });
    },
    handleClick(obj) {
        // console.log(obj.x, obj.y, obj.lat, obj.lng, obj.event);
      if (this.props.onClick) {
        this.props.onClick(obj.lat, obj.lng);
      }
    },
    renderMarker(key, location) {
        var lat = location.latitude;
        var lng = location.longitude;
        if (this.props.markerOverride) {
            return this.props.markerOverride(key, lat, lng);
        } else {
            return <PinMarker key={key} lat={lat} lng={lng} />
        }
    },
    render() {
        var markers = [];
        var latlng = [parseFloat(this.props.locations[0].latitude), parseFloat(this.props.locations[0].longitude)];
        // var latlng = [{lat: this.props.locations[0].latitude, lng: this.props.locations[0].longitude}];
        if (this.props.locations) {
            var len = this.props.locations.length;
            for(var i = 0; i < len; i++) {
                var location = this.props.locations[i];
                markers.push(this.renderMarker(i, location));
                // latlng[0] = [parseFloat(location.latitude),parseFloat(location.longitude)]
            }
        }
        // var bounds = {};
        // for (var i = 0; i < markers.length; i++) {
        //     bounds.extend(markers[i].getPosition());
        // }
        // const size = {
        //     height: 450,
        //     width: 100
        // };
        // const {center, zoom} = fitBounds(bounds, size);
        // console.log("center: " + center, + " zoom: " + zoom);
        var map = '';
        if (this.state.api_key) {
            map = <GoogleMap
                bootstrapURLKeys={{key: this.state.api_key}}
                //bootstrapURLKeys={{key: api_key}}
                //defaultCenter={latlng}
                center={latlng}
                //fitBounds={bounds}
                defaultZoom={14}
                options={this.props.options}
                onClick={this.handleClick}
            >
                {markers}
            </GoogleMap>
        }
        return (
            <div style={{height: "450px"}} className="locationmap">
                {map}
            </div>
        );
    },
});