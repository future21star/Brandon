var Pictures = React.createClass({
    getInitialState () {
        return {
            instances: [],
        };
    },
    addPicture(instance) {
        var instances = this.state.instances.slice();
        instances.push(instance);
        this.setState({
            instances: instances
        });
        // in the event we are wrapped, we need to update the wrapper as well
        if (this.props.addPicture) {
            this.props.addPicture(instance);
        }
    },
    render() {
        instances = [];
        var len = this.state.instances.length;
        for (var i = 0; i < len; i++) {
            var instance = this.state.instances[i];
            instances.push(<img key={instance.generated_name} src={instance.thumbnail_url} alt="picture url"/>);
        }
        return (
            <div>
                <PictureUploader files={this.state.instances} addPicture={this.addPicture} />
            </div>
        );
    }
});