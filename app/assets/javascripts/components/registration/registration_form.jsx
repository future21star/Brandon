
var RegistrationForm = React.createClass({
    getInitialState() {
        const existing = this.props.instance && this.props.instance.id != null;
        const action = existing ? ACTION_UPDATE : ACTION_CREATE;

        return ({
            action: action,
            // existing: existing,

            user: {},
            address: {},
            business: {},

            tags: '',
            promo_code: '',
            communication: {},

            captcha: '',

            canSubmit: false,
            key: 0,
            wasSubmitted: false,
            forceScroll: false,

            // // editing
            // editing_field: null,

            errors: {}
        });
    },
    stateToObject() {
        return {
            creating: {
                business: this.props.business_signup,
            },
            user: this.state.user,
            address: this.state.address,
            business: this.state.business,
            business_tags: this.state.tags,
            promo_code: {
                code: this.state.promo_code,
                source: this.props.source
            },
            communication: this.state.communication,
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
    redirectToCreated(data) {
      window.location.href = Routes.registration_completed_path({id: data["id"]})
    },
    handleSubmit(e) {
        e.preventDefault();

        if (ACTION_CREATE == this.state.action) {
            this.handleCreate();
        } else if (ACTION_UPDATE == this.state.action) {
            this.handleUpdate();
        } else {
            console.error("Failed to find action, this should never happen");
        }

    },
    handleCRUD(url, onSuccessCallback) {
        var obj = this.stateToObject();

        $.ajax({
            url: url,
            dataType: 'json',
            contentType: 'application/json',
            type: this.state.action,
            data: JSON.stringify(obj),
            beforeSend: function (xhr, settings) {
                this.disableButton();
                this.setState({wasSubmitted: true});
            }.bind(this),
            success: function (data) {
                onSuccessCallback(data);
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
                // server errors need to reset captcha
                grecaptcha.reset();
            }.bind(this)
        });
    },
    handleCreate() {
        var url = Routes.user_registration_path;
        this.handleCRUD(url,  this.redirectToCreated);
    },
    handleUpdate(callback=null) {
        // TODO: handlers
        var url = Routes.project_path(this.state.id);
        this.handleCRUD(url, callback);
    },
    renderBusinessFields() {
        var fields = '';

        if (this.props.business_signup) {
            fields = <BusinessFields allTags={this.props.allTags}  handleChange={this.handleRawChange} />
        }
        return fields;
    },
    renderPromoCode() {
        var fields = '';

        if (this.props.business_signup) {
            fields = <PromotionCode promoCode={this.state.promo_code} handleChange={this.handleChange}/>
        }
        return fields;
    },
    renderUserFields() {
        return   <UserFields handleChange={this.handleRawChange} />
    },
    renderAddressFields() {
        return <AddressFields countries={this.props.countries} provinces={this.props.provinces}
                              handleChange={this.handleRawChange}
        />
    },
    renderCaptcha() {
        return <Captcha onChange={this.handleRawChange}/>
    },
    renderCommunication() {
        return <CommunicationFields handleChange={this.handleRawChange} />
    },
    render() {
        var submit_text = "Sign up";
        // console.log("obj " + JSON.stringify(this.state.errors));

        const errors = renderErrors(this.state);
        const user_fields = this.renderUserFields();
        const address_fields = this.renderAddressFields();
        const business_fields = this.renderBusinessFields();
        const promo_code = this.renderPromoCode();
        const communication = this.renderCommunication();
        const captcha = this.renderCaptcha();

        return (
            <Formsy.Form onSubmit={this.handleSubmit} key={this.state.key} onValid={this.enableButton} onInvalid={this.disableButton}
                         validationErrors={this.state.errors}>
                {errors}
                {user_fields}
                {address_fields}
                {business_fields}
                {promo_code}
                {communication}
                {captcha}
                <button type="submit" onClick={this.handleSubmit}>{submit_text}</button>
            </Formsy.Form>
        );
    }
});