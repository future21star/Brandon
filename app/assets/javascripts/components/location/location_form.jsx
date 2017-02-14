var LocationForm = React.createClass({
    getInitialState() {
      return {
          locations: this.props.instances,
      }
    },
    renderLocations() {
        var locations = [];
        if (this.state.locations) {
            for (var i=0; i < this.state.locations.length; i++) {
                var location = this.state.locations[i];
                locations.push(
                        <Location key={location.id} index={i} instance={location}/>
                    );
            }
        }
        return locations;
    },
    render() {
        const locations = this.renderLocations();

        return (
            <Formsy.Form onSubmit={this.handleUpdate}>
                <Map name="location" locations={this.props.instances}/>
                <table>
                    <tbody>
                        <tr>
                            <th>Name</th><th>Latitude</th><th>Longitude</th><th>Visible?</th>
                        </tr>
                    </tbody>
                    {locations}
                </table>
            </Formsy.Form>
        );
    }
});