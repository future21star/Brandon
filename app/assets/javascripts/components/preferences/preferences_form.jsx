var PreferencesForm = React.createClass({
    getInitialState() {
        return {
            preferences: this.props.preferences,
            forceScroll: false,
        }
    },
    stateToObject() {
        return {
            user_preferences: this.state.preferences
        }
    },
    componentDidUpdate() {
        if (this.state.forceScroll) {
            Scroller.scrollTo(ERRORS_NAME, SCROLL_OPTIONS);
            this.setState({forceScroll: false});
        }
    },
    handlePreferenceChange(index, newState) {
        var state = this.state;
        state.preferences[index] = newState;
        this.setState(state);
        // this.props.onChange(state.preferences, this.stateToObject(state));
    },
    handleCRUD(url, onSuccessCallback) {
        var obj = this.stateToObject();
        $.ajax({
            url: url,
            dataType: 'json',
            contentType: 'application/json',
            type: ACTION_UPDATE,
            data: JSON.stringify(obj),
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
            }.bind(this)
        });
    },
    handleUpdate() {
        //TODO: What to do with success?
        var url = Routes.user_preferences_update_path();
        this.handleCRUD(url, null);
    },
    render() {
        const errors = renderErrors(this.state);
        var preferences = [];
        var len = this.props.preferences.length;
        for (var i = 0; i < len; i++) {
            preferences.push(
                eval([
                <PreferencesField key={i} index={i} instance={this.props.preferences[i]} handleChange={this.handlePreferenceChange}/>,
                ])
            );
        }

        return (
            <Formsy.Form onSubmit={this.handleUpdate}>
                {errors}
                <table>
                   <tbody> 
                        <tr>
                            <th /><th>Email</th><th>Internal</th>
                        </tr>
                    </tbody>
                    {preferences}
                </table>
                <button type="submit" onClick={this.handleUpdate}>Update</button>
            </Formsy.Form>
        );
    }
});