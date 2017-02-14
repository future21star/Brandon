var TermsAndConditions = React.createClass({
    getInitialState() {
        return ({
            id: '',
            accepted: false,

            canSubmit: false,
            key: 0,
            loading: true,
            errors: {}
        });
    },
    componentDidMount() {
        this.setState({loading: true});
        var url = Routes.static_eula_path();
        this.serverRequest = $.get(url, function (result) {
            const instance = result['instance'];
            const eula = instance.eula;
            this.setState({eula: eula, id: instance.id, loading: false});
        }.bind(this));
    },
    stateToObject() {
        return {
            terms_and_conditions:  {
                id: this.state.id,
            },
        }
    },
    declineTerms(){
        $.ajax({
            url: Routes.destroy_user_session_path,
            dataType: 'json',
            type: 'DELETE',
            success: function (data) {
                window.location.href = Routes.new_user_session_path();
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                this.setState({errors: json, key: this.state.key++});
            }.bind(this),
        });
    },
    acceptTerms(){
        var obj = this.stateToObject();

        $.ajax({
            url: Routes.terms_and_conditions_accept_path(),
            dataType: 'json',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(obj),
            success: function (data) {
                window.location.href = Routes.user_landing_page_path();
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                // console.log("obj " + JSON.stringify(json));
                this.setState({errors: json, key: this.state.key++});
            }.bind(this),
            complete: function (xhr, status) {
                this.enableButton();
            }.bind(this)
        });
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
    handleChange() {
        this.setState({accepted: !this.state.accepted});
    },

    render() {
        const eula = this.state.loading ? '' : this.state.eula;
        return (
            <div className="container m-t-45 m-b-45">
                <Formsy.Form onSubmit={this.handleSubmit} key={this.state.key} onValid={this.enableButton} onInvalid={this.disableButton}
                             validationErrors={this.state.errors}>
                    <ScrollBox text={eula} />
                    <MyCheckbox
                             value={this.state.accepted}
                             name='accepted'
                             label='I have read and agree to the terms and conditions'
                             onChange={this.handleChange}
                             validations="isTrue"
                    />
                    <div className="terms-actions">
                        <button type="submit" className="pull-left btn btn-flat" onClick={this.declineTerms}>Back</button>
                        <button type="submit" className="pull-right btn btn-flat" onClick={this.acceptTerms} disabled={!this.state.canSubmit}>Continue</button>
                    </div>
                </Formsy.Form>
            </div>
        );
    }
});