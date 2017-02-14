
var MeasurementGroup = React.createClass({
    getInitialState() {
        return this.reloadState(this.props.instance, this.props.group);
    },
    reloadState(instance, group, key=0) {
        const projectId = this.props.projectId;
        const projectSaved = projectId ? true : false;
        const existing  = !isEmpty(instance);
        var measurements = [];
        measurements[0] = {};
        var name = '';
        var id = null;
        var editing = false;
        var group = group;
        if (projectSaved && existing) {
            measurements = instance.measurements_attributes;
            name = instance.name;
            id = instance.id;

        } else if (projectSaved) {
            editing = true;
        }
        // console.log("loaded " + JSON.stringify(measurements));
        return {
            key: key,

            project_id: projectId,
            id: id,
            group: group,
            name: name,
            measurements: measurements,

            project_saved: projectSaved,
            existing: false,
            editing: editing,
        }
    },
    stateToObject(state) {
        return {
            id: state.id,
            project_id: state.project_id,
            group_id: state.group,
            order: state.group,
            name: state.name,
            measurements_attributes: state.measurements,
        }
    },
    handleChange(e) {
        e.preventDefault();
        var name = e.target.name;
        var value = e.target.value;
        this.state[name] = value;
        this.props.onChange(this.state.group, this.stateToObject(this.state));
    },
    onSuccessfulDelete(index) {
        var state = this.state;
        state.measurements.splice(index, 1);
        state.key += 1;
        this.setState(state);
    },
    handleMeasurementChange(index, newState) {
        var state = this.state;
        state.measurements[index] = newState;
        this.setState(state);
        this.props.onChange(state.group, this.stateToObject(state));
    },
    handleAddNewMeasurement(e) {
        e.preventDefault();
        var state = this.state;
        var index = state.measurements ? state.measurements.length : 0;
        state.key += 1;
        state.measurements[index] = {};
        this.setState(state);
    },
    handleMeasurementDelete(id, saved) {
        var index = getIndex(id, this.state.measurements);
        if (!saved) {
            this.onSuccessfulDelete(index);
        } else {
            $.ajax({
                url: Routes.measurements_destroy_path(id),
                dataType: 'json',
                contentType: 'application/json',
                type: ACTION_DELETE,
                success: function (data) {
                    this.onSuccessfulDelete(index);
                    // console.log("data " + JSON.stringify(data));
                }.bind(this),
                error: function (xhr, status, err) {
                    var json = xhr.responseJSON;
                    console.log("errors: " + JSON.stringify(err));
                    this.setState({errors: json, captcha: ''});
                }.bind(this)
            });
        }
    },
    handleEditToggle() {
        this.setState({editing: !this.state.editing, key: this.state.key++});
    },
    handleSave(e) {
        e.preventDefault();
        var action = ACTION_CREATE;
        var url = Routes.measurements_group_create_path();

        if (this.state.project_id && this.state.id) {
            action = ACTION_UPDATE;
            url = Routes.measurements_group_update_path(this.state.id);
        }
        var obj = this.stateToObject(this.state);

        $.ajax({
            url: url,
            dataType: 'json',
            contentType: 'application/json',
            type: action,
            data: JSON.stringify(obj),
            success: function (data) {
                // console.log("data " + JSON.stringify(data));
                this.handleEditToggle();
                this.setState(this.reloadState(data, this.state.group, this.state.key + 1));
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                console.log("errors: " + JSON.stringify(err));
                this.setState({errors: json, captcha: ''});
            }.bind(this)
        });
    },
    handleDelete(e) {
        e.preventDefault();
        this.props.handleRemove(this.state.id);
    },
    renderMeasurements() {
        var measurements = [];
        if (this.state.measurements) {
            for (var i=0; i < this.state.measurements.length; i++) {
                var measurement = this.state.measurements[i];
                measurements.push(
                    <Measurement key={this.state.key + ':' + i} index={i} instance={measurement}
                                measurementUnits={this.props.measurementUnits} measurementTypes={this.props.measurementTypes}
                                 handleChange={this.handleMeasurementChange} editing={this.state.editing}
                                 handleDelete={this.handleMeasurementDelete}
                    />);
            }
        }
        return measurements;
    },
    renderName() {
        const name = 'name';
        const label = 'Name';

        const min = 3;
        const max = 100;


        var field = '';
        if (!this.state.project_saved || this.state.editing) {
        field = <MyInput type="text" value={this.state.name} label={label} name={name}
                         onChange={this.handleChange}
                         required
                         validations={{
                             minLength: min,
                             maxLength: max
                         }}
                         validationErrors={{
                             minLength: 'You must enter at least ' + min + ' characters',
                             maxLength: 'You can not enter more than ' + max + ' characters'
                         }}
        />;
        } else {
            field = <label htmlFor={name}>{this.state.name}</label>;
        }
        return field;
    },
    renderActions() {
        var actions = '';
        if (this.state.project_saved && this.props.rules.access_rules.is_project_owner) {
            if (this.state.editing) {
                actions = eval([<button type="submit" onClick={this.handleSave} >Save Group</button>,
                    <button type="submit" onClick={this.handleAddNewMeasurement} >Add Measurement</button>]);
            } else {
                actions = eval([<a onClick={this.handleEditToggle}>edit</a>,<a onClick={this.handleDelete}>delete</a>]);
            }
        } else if (!this.state.project_id) {
            actions = eval(<button type="submit" onClick={this.handleAddNewMeasurement} >Add Measurement</button>);
        }
        return actions;
    },
    render() {
        // console.log("state " + JSON.stringify(this.state));
        const name = this.renderName();
        const actions = this.renderActions();
        const measurements = this.renderMeasurements();

        return (
            <div className="container">
                {actions}
                {name}
                {measurements}
            </div>
        );
    }
});