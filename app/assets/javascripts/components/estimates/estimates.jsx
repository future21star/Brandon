var Estimates = React.createClass({
    getInitialState() {
        return {
            instances: this.props.instances,
            instance: null,
            quantifiers: this.props.quantifiers,
            key: 1,
            action: ACTION_CREATE,
        }
    },
    addObject(instance) {
        var instances = React.addons.update(this.state.instances, {$push: [instance]});
        this.setState({instances: instances});
    },
    updateObject(instance) {
        var index = getIndex(instance.id, this.state.instances);
        this.state.instances[index] = instance;
        this.setState({instances: this.state.instances, instance: null, key: this.state.key++, action: ACTION_CREATE});
    },
    deleteObject(instance) {
        var index = this.state.instances.indexOf(instance);
        var instances = React.addons.update(this.state.instances, {$splice: [[index, 1]]});
        this.setState({instances: instances, action: ACTION_CREATE});
    },
    changeToEditMode(instance) {
        this.setState({instance: instance, action: ACTION_UPDATE});
    },
    changeToDeleteMode(instance) {
        this.setState({instance: instance, action: ACTION_DELETE});
    },
    render() {
        // console.log("fields: " + JSON.stringify(this.state));
        var instances = [];
        var len = this.state.instances.length;
        for (var i = 0; i < len; i++) {
            var instance = this.state.instances[i];
            instances.push(<Estimate summary_mode="false" key={instance.id} instance={instance}
                                     changeToDeleteMode={this.changeToDeleteMode} changeToEditMode={this.changeToEditMode}
                                     quantifiers={this.state.quantifiers}/>);
        }
        return (
            <div>
                <EstimateForm key={this.state.key} handleNewObject={this.addObject} handleEditObject={this.updateObject}
                              handleDeleteObject={this.deleteObject} quantifiers={this.state.quantifiers} instance={this.state.instance}
                              url="/estimates/" action={this.state.action} project_id={this.props.project_id} />
                {instances}
            </div>
        );
    }
});