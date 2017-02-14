var Location = React.createClass({
    getInitialState() {
        return {
            id: this.props.instance.id,
            name: this.props.instance.name,
            latitude: this.props.instance.latitude,
            longitude: this.props.instance.longitude,
            visible: this.props.instance.visible,
        }
    },
    stateToObject() {
          return {
              location: {
                  id: this.state.id,
                  name: this.state.name,
                  latitude: this.state.latitude,
                  longitude: this.state.longitude,
                  visible: this.state.visible,
              }
          }
    },
    handleChange(e) {
        e.preventDefault();
        var state = this.state;
        var name = e.target.name;
        var value = e.target.value;
        state[name] = value;
        this.setState(state);
    },
    handleVisibilityChange() {
        this.setState({visible: !this.state.visible});
    },
    updateLocation() {
        var obj = this.stateToObject();
        $.ajax({
            url: Routes.location_path(this.state.id),
            dataType: 'json',
            contentType: 'application/json',
            type: ACTION_UPDATE,
            data: JSON.stringify(obj),
            success: function (data) {
                // console.log("data " + JSON.stringify(data));
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                //TODO What to do with the errors??
                // console.log("errors: " + JSON.stringify(err));
            }.bind(this)
        });
    },
    renderName() {
        const name = 'name';
        const label = 'Name';

        return <MyInput type="text" value={this.state.name} label={label} name={name}
                        onChange={this.handleChange}
            />;
    },
    renderLatitude() {
        return <span>{this.state.latitude}</span>
    },
    renderLongitude() {
        return <span>{this.state.longitude}</span>
    },
    renderVisibility() {
        const name = 'visible';

        return <MyInput type="checkbox" value={this.state.visible} name={name}
                        onChange={this.handleVisibilityChange}
            />;
    },
    render() {
        const longitude = this.renderLongitude();
        const latitude = this.renderLatitude();
        const name = this.renderName();
        const visible = this.renderVisibility();

        return (
            <tbody>
	            <tr>
	                <td>{name}</td>
	                <td>{longitude}</td>
	                <td>{latitude}</td>
	                <td>{visible}</td>
	                <td><button type="submit" onClick={this.updateLocation} >Update</button></td>
	            </tr>
            </tbody>
        );
    }
});