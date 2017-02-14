var BusinessForm = React.createClass({
    getInitialState() {
        const existing = this.props.instance;
        return {
            existing: existing,
            business: {},
            communication: {},
            tags: [],
            can_submit: false,
            key: (this.state && this.state.key) ? this.state.key : 1,
            was_submitted: false,
            forceScroll: false,
            errors: {},
        }
    },
    stateToObject() {
        return {
            business: this.state.business,
            communication: this.state.communication,
            business_tags: this.state.tags,
        };
    },
    componentDidUpdate() {
        if (this.state.forceScroll) {
            Scroller.scrollTo(ERRORS_NAME, SCROLL_OPTIONS);
            this.setState({forceScroll: false});
        }
    },
    enableButton() {
        this.setState({
            can_submit: true
        });
    },
    disableButton() {
        if (!this.state.was_submitted) {
            this.setState({
                can_submit: false
            });
        }
    },
    handleChange(name, value) {
        var state = this.state;
        this.state[name] = value;
        this.setState(state);
    },
    handleCRUD(url, onSuccessCallback) {
        var obj = this.stateToObject();
        var action = this.state.existing ? ACTION_UPDATE : ACTION_CREATE;
        $.ajax({
            url: url,
            dataType: 'json',
            contentType: 'application/json',
            type: action,
            data: JSON.stringify(obj),
            beforeSend: function (xhr, settings) {
                this.disableButton();
                this.setState({was_submitted: true});
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
            }.bind(this),
            complete: function (xhr, status) {
                this.enableButton();
            }.bind(this)
        });
    },
    handleUpdate() {
        // TODO: handlers
        if (this.state.existing) {
            var url = Routes.business_path(this.state.business.id);
            this.handleCRUD(url, null);
        } else {
            var url = Routes.businesses_path();
            this.handleCRUD(url, this.onCreateSuccessfull);
        }
    },
    onCreateSuccessfull(data) {
        window.location.href = Routes.edit_user_registration_path({tab: TAB_BUSINESS});
    },
    renderCommunication() {
        return <CommunicationFields handleChange={this.handleChange} />
    },
    render() {
        const submitText = this.state.existing ? "Update" : "Create";
        var msg = '';
        var notifications = '';
        if (!this.state.existing) {
            msg = <p className="text-gold"><i className="fa fa-info-circle fa-fw"></i> We see your account is currently not a business account. You can upgrade your account for free right here.
            Register your business to generate quality leads.</p>;
            notifications = this.renderCommunication();
        }
        const errors = renderErrors(this.state);

        return (
            <Formsy.Form onSubmit={this.handleUpdate} key={this.state.key} onValid={this.enableButton} onInvalid={this.disableButton}
                         validationErrors={this.state.errors}>
                {errors}
                {msg}
                <BusinessFields allTags={this.props.allTags} instance={this.props.instance}
                                handleChange={this.handleChange}/>
                {notifications}
                <button type="submit" onClick={this.handleUpdate}>{submitText}</button>
            </Formsy.Form>
        );
    }
});