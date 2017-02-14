const WORKING_STATE_NAME = 'working_location';
const FIELD_NAME = "location_type";

var LocationType = React.createClass({
    getInitialState() {
        var canGeoLocate = navigator.geolocation;
        if (canGeoLocate) {
            navigator.geolocation.getCurrentPosition(this.receivedLocation, null, {maximumAge:60000, timeout:5000, enableHighAccuracy:true});
        }

      return {
        location_type: LOCATION_PRIMARY,
        primary_location: null,
        geo_located: null,
        new_location: null,
        saved_location: null,

        working_location: null,

        saved_locations: null,
        has_saved: false,
        key: (this.state && this.state.key) ? this.state.key : 1,
        loading: true,
      }
    },
    componentDidMount() {
        var url = Routes.locations_mine_path();
        this.serverRequest = $.get(url, function (result) {
            const instance = result["location"];
            const saved_locations = result['locations'];

            // we need to remove the id attribute because if the user selects new location, then only changes the name, it would update
            // the original instance instead of creating a new copy but under a different name
            var new_location = $.extend({}, instance);
            new_location['id'] = null;

            var state = this.state;
            state["primary_location"] = instance;
            state["working_location"] = instance;
            state["new_location"] = new_location;
            state["saved_locations"] = saved_locations;
            state["saved_location"] = saved_locations[0];
            state["has_saved"] =  !isEmpty(saved_locations);

            state["key"] = state.key+1;
            state['loading'] = false;
            state[FIELD_NAME] = LOCATION_PRIMARY;
            this.setState(state);
            this.props.onChange(this.props.name, this.stateToObject(state));
        }.bind(this));
    },

    componentWillUnmount() {
        this.serverRequest.abort();
    },
    stateToObject(state) {
        return state.working_location;
    },
    determineState(value) {
        var location = this.state.working_location;
        if (LOCATION_PRIMARY == value) {
            location = this.state.primary_location;
        } else if (LOCATION_CURRENT == value) {
            location = this.state.geo_located;
        } else if (LOCATION_NEW == value) {
            location = this.state.new_location;
        } else if (LOCATION_SAVED == value) {
            location = this.state.saved_location
        }
        return location;
    },
    handleRawChange(name, value, location=this.determineState(value)) {
        var state = this.state;
        state[name] = value;
        state.key = this.state.key + 1;
        state[WORKING_STATE_NAME] = location;
        this.setState(state);
        this.props.onChange("location", this.stateToObject(state));
    },
    handleChange(e) {
        var name = e.target.name;
        var value = e.target.value;
        this.handleRawChange(name, value);
    },
    handleSavedLocationChange(e) {
        var name = e.target.name;
        var value = e.target.value;
        var index = getIndex(value, this.state.saved_locations);
        var location = this.state.saved_locations[index];
        this.handleRawChange(name, value, location);
    },
    handleNewLocationName(e) {
        e.preventDefault();
        var value = e.target.value;
        var state = this.state;
        state[WORKING_STATE_NAME].name = value;
        this.setState(state);
    },
    handleOnClick(latitude, longitude) {
        var location = this.state.new_location;
        location.latitude = latitude;
        location.longitude = longitude;
        this.handleRawChange(FIELD_NAME, LOCATION_NEW, location);
    },
    receivedLocation(position) {
        this.setState({
            geo_located: {
                latitude: position.coords.latitude,
                longitude: position.coords.longitude
            }
        });
    },
    render() {
        var currentLocation = this.state.location_type == LOCATION_CURRENT;
        var newLocation = this.state.location_type == LOCATION_NEW;
        var savedLocation = this.state.location_type == LOCATION_SAVED;
        var onClick = null;
        var locationNameHidden = true;
        var savedLocationsHidden = !savedLocation;
        if (currentLocation || newLocation) {
            locationNameHidden = false;
        }
        if (newLocation) {
            onClick = this.handleOnClick;
        }
        var val = this.state[FIELD_NAME];
        var locations = [];
        var inputs = [];
        if (!this.state.loading) {
            locations = [{latitude: this.state.working_location.latitude, longitude: this.state.working_location.longitude}];
            inputs.push(<MyRadio key={inputs.length} name={FIELD_NAME} value={LOCATION_PRIMARY} onChange={this.handleChange} check={val}
                     text="Primary address" />
            );
            inputs.push(<MyRadio key={inputs.length} name={FIELD_NAME} value={LOCATION_NEW} onChange={this.handleChange} check={val}
                text="New location" />
            );
            inputs.push(<MyRadio key={inputs.length} name={FIELD_NAME} value={LOCATION_SAVED} onChange={this.handleChange} check={val}
                text="Saved location" hidden={!this.state.has_saved} />
            );
            inputs.push(<MyRadio key={inputs.length} name={FIELD_NAME} value={LOCATION_CURRENT} onChange={this.handleChange} check={val}
                text="Current location" />
            );
            inputs.push(<MyInput key={inputs.length} type="text" value={this.state.working_location.name} label="Locations name" name='name'
                onChange={this.handleNewLocationName} hidden={locationNameHidden}
                validations={{
                    maxLength: 255
                }}
                validationErrors={{
                    maxLength: 'You can not enter more than 255 characters'
                }}/>
            );
            inputs.push(<br key={inputs.length} />);
            inputs.push(<BasicSelect key={inputs.length} name="location_id" selected={this.state.working_location.id} onChange={this.handleSavedLocationChange}
                instances={this.state.saved_locations} hidden={savedLocationsHidden}
                label='Saved locations:'/>
            );
            inputs.push(
                <Map key={inputs.length} name="location" locations={locations} onClick={onClick}/>
            );
            
        }
        return (
            <div key={this.state.key}>
                {inputs}
            </div>
        );
    }
});