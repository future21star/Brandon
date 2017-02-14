
var FeedbackForm = React.createClass({
    getInitialState() {
        return {
            name: '',
            email: '',
            content: '',
            captcha: '',

            can_submit: false,
            key: (this.state && this.state.key) ? this.state.key : 1,
            was_submitted: false,
            forceScroll: false,
            errors: {},
        }
    },
    stateToObject() {
        return this.state;
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
    handleSubmit(e) {
        e.preventDefault();
        var obj = this.stateToObject();
        $.ajax({
            url: Routes.feedbacks_path(),
            dataType: 'json',
            contentType: 'application/json',
            type: ACTION_CREATE,
            data: JSON.stringify(obj),
            beforeSend: function (xhr, settings) {
                this.disableButton();
                this.setState({was_submitted: true});
            }.bind(this),
            success: function (data) {
                window.location.href = Routes.feedback_completed_path();
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
    renderName() {
        const name = "name";
        const label = "Name";

        return <MyInput type="text" value={this.state.title} label={label} name={name}
                             onChange={this.handleChange} required
                             validations={{
                                 minLength: 5,
                                 maxLength: 255
                             }}
                             validationErrors={{
                                 minLength: 'You must enter at least 5 characters',
                                 maxLength: 'You can not enter more than 255 characters'
                             }}
            />;
    },
    renderEmail() {
        const name = "email";
        const label = "Email";
        const placeholder = "no-replay@quotr.ca";

        return <MyInput type="text" value={this.state.email}
                        label={label}
                        name={name}
                        placeholder={placeholder}
                        onChange={this.handleChange} required
                        validations="isEmail"
                        validationErrors={{
                            isEmail: 'You must enter a valid email address'
                        }}
        />;
    },
    renderContent() {
        const name = 'content';
        const label = 'Content';

        return <MyTextArea value={this.state.description} label={label} name={name}
                                      onChange={this.handleChange}
                                      validations={{minLength: 25}}
                                      validationErrors={{minLength: 'You must enter at least 25 characters'}}
                                      required/>;
    },
    renderCaptcha() {
        var field = '';

        if (!this.state.existing) {
            field = <Captcha onChange={this.handleRawChange}/>
        }

        return field;
    },
    render() {
        const name = this.renderName();
        const email = this.renderEmail();
        const content = this.renderContent();
        const captcha = this.renderCaptcha();
        const errors = renderErrors(this.state);
        return (
            <Formsy.Form onSubmit={this.handleSubmit} key={this.state.key} onValid={this.enableButton} onInvalid={this.disableButton}
                         validationErrors={this.state.errors}>
                {errors}
                {name}
                {email}
                {content}
                {captcha}
                <button type="submit" onClick={this.handleSubmit}>Submit</button>
            </Formsy.Form>
        );
    }
});