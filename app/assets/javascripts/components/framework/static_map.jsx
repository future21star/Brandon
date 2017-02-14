// We use this map where no dynamisism is required, this lookup does not count towards our usage
var StaticMap = React.createClass({
    render() {
        var url = this.props.maps_url.replace('{LAT}', this.props.latitude).replace('{LONG}', this.props.longitude);
        return (
            <div>
                <iframe width="600" height="450" frameBorder="0" style={{border:0}} src={url}>
                </iframe>
            </div>
        );
    }
});