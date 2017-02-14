
var ProjectForm = React.createClass({
    getInitialState() {
        const existing = this.props.instance.id != null;
        const action = existing ? ACTION_UPDATE : ACTION_CREATE;
        const location = existing ? this.props.instance.location : this.props.location;
        const measurement_groups = existing ? this.props.instance.measurement_groups : [{}];
        const tags = existing ? this.props.instance.tags: [];

        return ({
            action: action,
            existing: existing,

            id: this.props.instance.id,
            title: this.props.instance.title,
            summary: this.props.instance.summary,
            description: this.props.instance.description,
            additional_comments: this.props.instance.additional_comments,
            state: this.props.instance.state,

            measurement_groups: measurement_groups,

            tags: tags,
            pictures: this.props.instance.images ? this.props.instance.images : [],

            location: location,

            captcha: '',

            canSubmit: false,
            key: 0,
            wasSubmitted: false,
            forceScroll: false,

            // editing
            editing_field: null,

            errors: {}
        });
    },
    stateToObject() {
        var pictures = [];
        if (this.state.pictures) {
            var len = this.state.pictures.length;
            for (var i = 0; i < len; i++) {
                var instance = this.state.pictures[i];
                pictures[i] = {name: instance.generated_name}
            }
        }
        var measurement_groups = this.state.measurement_groups;
        return {
            project: {
                id: this.state.id,
                title: this.state.title,
                summary: this.state.summary,
                description: this.state.description,
                additional_comments: this.state.additional_comments,
            },
            project_tags: this.state.tags,
            location: this.state.location,
            pictures,
            measurement_groups,
            captcha: this.state.captcha,
        }
    },
    componentDidUpdate() {
        if (this.state.forceScroll) {
            Scroller.scrollTo(ERRORS_NAME, SCROLL_OPTIONS);
            this.setState({forceScroll: false});
        }
    },
    enableButton() {
        // TODO: This is being called when it shouldn't be on form load. Thus results in the submit button enabled on load
        this.setState({
            canSubmit: true
        });
    },
    disableButton() {
        if (!this.state.wasSubmitted) {
            this.setState({
                canSubmit: false
            });
        }
    },
    handleChange(e) {
        e.preventDefault();
        var name = e.target.name;
        var value = e.target.value;
        this.handleRawChange(name, value);
    },
    handleRawChange(name, value) {
        this.state[name] = value;
        // this is required for the drop down to re-render
        this.setState({key: this.state.key++});
    },
    handleMeasurementChange(group, measurement_group) {
        var state = this.state;
        state.measurement_groups[group] = measurement_group;
        // Do not trigger a re-render as our component is already up to date
        this.setState(state);
    },
    handleMeasurementRemove(id) {
        this.handleCRUDOverride(Routes.measurements_group_destroy_path(id), ACTION_DELETE, this.removeMeasuremnetGroup.bind(this, id));
    },
    addPicture(picture) {
        var pictures = this.state.pictures;
        pictures.push(picture);
        this.setState({pictures: pictures, key: this.state.key++});
    },
    report (e) {
        e.preventDefault();

        $.ajax({
            url: Routes.project_report_as_spam_path(this.state.id),
            type: 'POST',
            success: function (data) {
                // onSuccessCallback(data);
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                this.setState({errors: json, key: this.state.key++});
            }.bind(this)
        });
    },
    redirectToCreated(data) {
      window.location.href = Routes.project_path(data["id"]);
    },
    redirectOnDelete(data) {
      window.location.href = Routes.projects_path;
    },
    handleSubmit(e) {
        e.preventDefault();

        if (ACTION_CREATE == this.state.action) {
            this.handleCreate();
        } else if (ACTION_UPDATE == this.state.action) {
            this.handleUpdate();
        } else if (ACTION_DELETE == this.state.action) {
            this.handleDelete();
        } else {
            console.error("Failed to find action, this should never happen");
        }

    },
    handleCRUD(url, onSuccessCallback) {
        var action = this.state.action;
        this.handleCRUDOverride(url, action, onSuccessCallback);
    },
    handleCRUDOverride(url, action, onSuccessCallback) {
        var obj = this.stateToObject();

        $.ajax({
            url: url,
            dataType: 'json',
            contentType: 'application/json',
            type: action,
            data: JSON.stringify(obj),
            beforeSend: function (xhr, settings) {
                this.disableButton();
                this.setState({wasSubmitted: true});
            }.bind(this),
            success: function (data) {
                if (onSuccessCallback) {
                    onSuccessCallback(data);
                }
            }.bind(this),
            error: function (xhr, status, err) {
                var state = onAjaxError(xhr);
                if (state != null) {
                    this.setState(state);
                }
                grecaptcha.reset();
            }.bind(this),
            complete: function (xhr, status) {
                this.enableButton();
                // only use captcha on create
                if (!this.state.id) {
                    grecaptcha.reset();
                }
            }.bind(this)
        });
    },
    handleCreate() {
        // TODO: handlers
        var url = Routes.projects_path({format: 'json'});
        this.handleCRUD(url,  this.redirectToCreated);
    },
    handleUpdate(callback=null) {
        // TODO: handlers
        var url = Routes.project_path(this.state.id,{format: 'json'});
        this.handleCRUD(url, callback);
    },
    handleDelete() {
        // TODO: handlers
        var url =  Routes.project_path(this.state.id,{format: 'json'});
        this.handleCRUD(url,  this.redirectOnDelete);
    },
    setEditField(field) {
        this.setState({editing_field: field});
    },
    afterFieldUpdateSuccess() {
        this.setState({editing_field: null, key: this.state.key++});
    },
    onBlurUpdate(e) {
        e.preventDefault();
       this.handleUpdate(this.afterFieldUpdateSuccess);
    },
    areEditing(field) {
        return this.state.editing_field != null && this.state.editing_field == field;
    },
    addMeasurementGroup(e) {
        e.preventDefault();
        var state = this.state;
        var index = state.measurement_groups ? state.measurement_groups.length : 0;
        state.measurement_groups[index] = {};
        this.setState(state);
    },
    removeMeasuremnetGroup(id) {
        var state = this.state;
        var measurement_groups = this.state.measurement_groups;
        var index = getIndex(id, measurement_groups);
        measurement_groups.splice(index, 1);
        state.measurement_groups = measurement_groups;
        state.key += 1;
        this.setState(state);
    },
    renderTitle() {
        const name = "title";
        const label = "Title";

        var title = '';
        if (!this.state.existing || this.areEditing(name)) {
            var blur = this.areEditing(name) ? onBlur=this.onBlurUpdate : null;
            var focus = this.areEditing(name);
            title = <MyInput type="text" value={this.state.title} label={label} name={name}
                               onChange={this.handleChange} required
                               validations={{
                                   minLength: 5,
                                   maxLength: 100
                               }}
                               validationErrors={{
                                   minLength: 'You must enter at least 5 characters',
                                   maxLength: 'You can not enter more than 100 characters'
                               }}
                               onBlur={blur}
                               focus={focus}
            />;
        } else {
            var editable = this.props.rules.access_rules.is_project_owner ?
                <a onClick={this.setEditField.bind(this, name)}>edit</a> :
                '';
            title = <p><label htmlFor={name}>{this.state.title}</label>{editable}</p>;
        }

        return title;
    },
    renderSummary() {
        const name = "summary";
        const label = "Summary";

        var summary = '';
        if (!this.state.existing || this.areEditing(name)) {
            var blur = this.areEditing(name) ? onBlur=this.onBlurUpdate : null;
            var focus = this.areEditing(name);
            summary = <MyInput type="text" value={this.state.summary} label={label} name={name}
                               onChange={this.handleChange} required
                               validations={{
                                   minLength: 5,
                                   maxLength: 250
                               }}
                               validationErrors={{
                                   minLength: 'You must enter at least 5 characters',
                                   maxLength: 'You can not enter more than 250 characters'
                               }}
                               onBlur={blur}
                               focus={focus}
            />;
        } else {
            var editable = this.props.rules.access_rules.is_project_owner ?
                <a onClick={this.setEditField.bind(this, name)}>edit</a> :
                '';
            summary = <p><label htmlFor={name}>{this.state.summary}</label>{editable}</p>;
        }
        return summary;
    },
    renderMeasurementGroups() {
        var groups = [];

        if (this.state.measurement_groups) {
            var len = this.state.measurement_groups.length;
            for (var i = 0; i < len; i++) {
                groups.push(
                    <MeasurementGroup key={i} measurementUnits={this.props.measurement_units}
                                  measurementTypes={this.props.measurement_types} onChange={this.handleMeasurementChange}
                                  instance={this.state.measurement_groups[i]} group={i} rules={this.props.rules}
                                  handleRemove={this.handleMeasurementRemove} projectId={this.state.id}
                    />
                );
            }
        }

        return groups;
    },
    renderDescription() {
        const name = 'description';
        const label = 'Description';

        var description = '';
        if (!this.state.existing || this.areEditing(name)) {
            var blur = this.areEditing(name) ? onBlur = this.onBlurUpdate : null;
            description = <MyTextArea value={this.state.description} label={label} name={name}
                                      onChange={this.handleChange}
                                      validations={{minLength: 100}}
                                      validationErrors={{minLength: 'You must enter at least 100 characters'}}
                                      required
                                      onBlur={blur}
                                      focus={this.areEditing(name)}/>;
        } else {
            var editable = this.props.rules.access_rules.is_project_owner ?
                <a onClick={this.setEditField.bind(this, name)}>edit</a> :
                '';
            description = <p><label htmlFor={name}>{this.state.description}</label>{editable}</p>;
        }
        return description;
    },
    renderComments() {
        const name = 'additional_comments';
        const label = 'Additional Comments';

        var comments = '';
        if (!this.state.existing || this.areEditing(name)) {
            var blur = this.areEditing(name) ? onBlur = this.onBlurUpdate : null;
            comments =
                <MyTextArea value={this.state.additional_comments} label={label} name={name}
                            onChange={this.handleChange}
                            onBlur={blur}
                            focus={this.areEditing(name)}/>;
        } else {
            var editable = this.props.rules.access_rules.is_project_owner ?
                <a onClick={this.setEditField.bind(this, name)}>edit</a> :
                '';
            comments = <p><label htmlFor={name}>{this.state.additional_comments}</label>{editable}</p>;
        }
        return comments;
    },
    renderMarkerOverride(key, latitude, longitude) {
        return <DynamicCircleMarker key={key} lat={latitude} lng={longitude} />;
    },
    renderLocation() {
        var location = <LocationType onChange={this.handleRawChange}/>;

        if (this.state.existing) {
            var options = {maxZoom: 16};
            const locations = [{latitude: this.state.location.latitude, longitude: this.state.location.longitude}];

            location = <Map name="location"locations={locations}
                            markerOverride={this.renderMarkerOverride} options={options}/>;
        }
        return location;
    },
    renderTags() {
        return <TagCloud tags={this.state.tags} allTags={this.props.allTags} existing={this.state.existing}
                         onChange={this.handleChange} tagUpdates={this.handleRawChange} type={TAG_TYPE_PROJECT}
                         sourceId={this.state.id}
        />;
    },
    renderPictures() {
        const name = 'pictures';

        var pictures = <Pictures name={name} addPicture={this.addPicture} />;
        if (this.state.existing) {
            pictures = <MediaViewer sources={this.state.pictures} />;
        }
        return pictures;
    },
    renderActions() {
        var actions = '';
        if (this.props.rules && this.props.rules.access_rules.is_project_owner) {
            actions = <ProjectActions id={this.state.id} rules={this.props.rules}/>;
        }
        return actions;
    },
    renderCaptcha() {
        var field = '';

        if (!this.state.existing) {
            field = <Captcha onChange={this.handleRawChange}/>
        }

        return field;
    },
    render() {
        console.log("project obj " + JSON.stringify(this.state.location));
        var submit_text = "Save";
        if (this.state.action == ACTION_DELETE) {
            submit_text = "Delete";
        }

        const errors = renderErrors(this.state);
        const actions = this.renderActions();
        const title = this.renderTitle();
        const summary = this.renderSummary();
        const measurementGroups = this.renderMeasurementGroups();
        const location = this.renderLocation();
        const description = this.renderDescription();
        const comments = this.renderComments();
        const tags = this.renderTags();
        const pictures = this.renderPictures();
        const captcha = this.renderCaptcha();
        const quote = this.props.rules && this.props.rules.access_rules.can_quote ?
            <a onClick={Routes.new_estimate_path}>Quote</a> : null;
        const report =  this.props.rules && this.props.rules.access_rules.can_report ?  <a onClick={this.report}>Report as spam</a> : '';
        console.log("obj " + JSON.stringify(this.state));
        return (
            <Formsy.Form onSubmit={this.handleSubmit} key={this.state.key} onValid={this.enableButton} onInvalid={this.disableButton}
                         validationErrors={this.state.errors}>
                {errors}
                {actions}
                {report}
                {quote}
                <p><label htmlFor={'state'}>{this.state.state}</label></p>
                {title}
                {summary}
                {measurementGroups}
                <button type="submit" onClick={this.addMeasurementGroup}>Add Group</button>
                {location}
                {description}
                {comments}
                {tags}
                {pictures}
                {captcha}
                <button type="submit" onClick={this.handleSubmit}>{submit_text}</button>
            </Formsy.Form>
        );
    }
});
