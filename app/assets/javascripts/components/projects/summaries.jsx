var Summaries = React.createClass({
    getInitialState() {
        return {
            instances: [],
            instance: null,
            key: 1,
            loading: true,

            lat: 43.5064879161298,
            lng: -80.5397493904494,
            tags: [1],

            page: 1,
        }
    },
    redirectToView(instance) {
        window.location = Routes.project_path(instance.project_id);
    },
    loadMore() {
        this.setState({loading: true});
        var url = Routes.summaries_search_path(this.state.lat, this.state.lng)
            + "?tags=" + this.state.tags + "&page=" + this.state.page;
        this.serverRequest = $.get(url, function (result) {
            this.addInstances(result);
        }.bind(this));
    },
    addInstances(results) {
        var instances = [];
        var len = results.length;
        for (var i = 0; i < len; i++) {
            var instance = results[i];
            instances.push(<Summary key={instance.id}  instance={instance}
                                    redirectToView={this.redirectToView}/>);
        }
        if (instances.length > 0) {
            var combined = React.addons.update(this.state.instances, {$push: instances});
            this.setState({instances: combined, key: this.state.key+1,
                page: this.state.page+1, loading: false});
        }
    },
    componentDidMount: function() {
       this.loadMore()
    },

    componentWillUnmount: function() {
        this.serverRequest.abort();
    },
    render() {
        waypoint = null;
        if (!this.state.loading) {
            waypoint =  <Waypoint onEnter={this.loadMore} threshold={2.0}/>
        }
        return (
            <div className='project_listing container'>
                <div className="clearfix">
                <div className="legends">
                    <ul className="list-inline">
                        <li ><i className="fa fa-eye"></i> Viewed by user</li>
                        <li ><i className="fa fa-user"></i> My Project</li>   
                        <li ><i className="fa fa-calculator"></i> Got a Quote</li>
                    </ul>
                    </div>
                    <div className="pull-right"><a className="btn btn-gold btn-flat" href={Routes.new_project_path}>Create a project</a></div>
                </div>
               <div className="row projects">
                    {this.state.instances}
                    {waypoint}
                </div>
            </div>
        );
    }
});