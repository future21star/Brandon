var EstimateForm = React.createClass({
    getInitialState() {
        return {
            action: ACTION_CREATE,
            id: '',
            summary: '',
            price: '',
            duration: '',
            description: '',
            quantifier_id: 1,
            project_id: '',
            quote_id: null,
            canSubmit: false,
            key: (this.state && this.state.key) ? this.state.key : 1,
            wasSubmitted: false,
            forceScroll: false,
            errors: {}
        }
    },
    resetForm() {
            this.setState({
                id: '',
                summary: '',
                price: '',
                duration: '',
                description: '',
                quantifier_id: 1,
            });
    },
    stateToInstance() {
        return {
            estimate: {
                id: this.state.id,
                summary: this.state.summary,
                price: this.state.price,
                duration: this.state.duration,
                description: this.state.description,
                quantifier_id: this.state.quantifier_id,
                quote_id: this.state.quote_id,
            },
            quote: {
                project_id: this.state.project_id,
            }
        }
    },
    componentDidUpdate() {
        if (this.state.forceScroll) {
            Scroller.scrollTo(ERRORS_NAME, SCROLL_OPTIONS);
            this.setState({forceScroll: false});
        }
    },
    enableButton() {
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
        this.state[name] = value;
        // this is required for the drop down to re-render
        this.setState({key: this.state.key++});
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
        var instance = this.stateToInstance();
        $.ajax({
            url: url,
            dataType: 'json',
            type: this.state.action,
            data: instance,
            beforeSend: function (xhr, settings) {
                this.disableButton();
                this.setState({wasSubmitted: true});
            }.bind(this),
            success: function (data) {
                onSuccessCallback(data);
                this.setState({quote_id: data["quote_id"]});
                this.resetForm();
            }.bind(this),
            error: function (xhr, status, err) {
                var state = onAjaxError(xhr);
                if (state != null) {
                    this.setState(state);
                }
            }.bind(this),
            complete: function (xhr, status) {
                this.enableButton();
            }.bind(this)
        });
    },
    handleCreate() {
        this.handleCRUD(this.props.url,  this.props.handleNewObject);
    },
    handleUpdate() {
        var url = this.props.url + this.props.instance.id;
        this.handleCRUD(url, this.props.handleEditObject);
    },
    handleDelete() {
        var url = this.props.url + this.props.instance.id;
        this.handleCRUD(url,  this.props.handleDeleteObject);
    },
    componentWillReceiveProps(nextProps) {
        if (nextProps.instance != null) {
            this.setState({
                action: nextProps.action,
                id: nextProps.instance.id,
                summary: nextProps.instance.summary,
                price: nextProps.instance.price,
                duration: nextProps.instance.duration,
                description: nextProps.instance.description,
                quantifier_id: nextProps.instance.quantifier_id,
                project_id: nextProps.instance.project_id
            });
        }
    },
    render() {
        const errors = renderErrors(this.state);
        var submit_text = this.state.action == ACTION_CREATE ? 'Save' : this.state.action == ACTION_UPDATE ? 'Update' : 'Delete';
        return (
            <Formsy.Form onSubmit={this.handleSubmit} key={this.state.key} onValid={this.enableButton} onInvalid={this.disableButton}
                         validationErrors={this.state.errors}>
                {errors}
                {/* TODO: Remove the below input in the future*/}
                <MyInput type="text" value={this.state.project_id} label='Project id' name='project_id' onChange={this.handleChange}
                         required />
                <MyInput type="text" value={this.state.summary} label='Summary' name='summary' onChange={this.handleChange} required
                         validations={{
                             minLength: 5,
                             maxLength: 150
                         }}
                         validationErrors={{
                             minLength: 'You must enter at least 5 characters',
                             maxLength: 'You can not enter more than 150 characters'
                         }}
                    />
                <MyInput type="text" value={this.state.price} label='Price' name='price' onChange={this.handleChange}
                         required validations={eval(isDollar)} validationError="Must be a valid dollar amount"/>
                <Quantifier name='quantifier_id' quantifiers={this.props.quantifiers} selected={this.state.quantifier_id}
                         value={this.state.duration} label="Duration" inputName="duration" timed onChange={this.handleChange} />
                <MyTextArea value={this.state.description} label='Description' name='description' onChange={this.handleChange}
                        validations={{minLength: 10}}
                        validationErrors={{minLength: 'You must enter at least 10 characters'}}
                        required />
                <button type="submit" onClick={this.handleSubmit}>{submit_text}</button>
            </Formsy.Form>
        );
    }
});