var UserFields = React.createClass({
    getInitialState() {
        const existing = !isEmpty(this.props.instance);

        var email = '';
        var firstName = '';
        var lastName = '';
        if (existing) {
            var instance = this.props.instance;

            email = instance.email;
            firstName = instance.first_name;
            lastName = instance.last_name;
        }
        return ({
            existing: existing,

            email: email,
            first_name: firstName,
            last_name: lastName,
            password: '',
            confirm_password: '',
            current_password: '',
        });
    },
    stateToObject(state){
        return {
            email: state.email,
            first_name: state.first_name,
            last_name: state.last_name,
            password: state.password,
            password_confirmation: state.password_confirmation,
            current_password: state.current_password,
        }
    },
    handleChange(e) {
        e.preventDefault();
        var state = this.state;
        var name = e.target.name;
        var value = e.target.value;
        state[name] = value;
        this.props.handleChange('user', this.stateToObject(state));
        this.setState(state);
    },
    renderFirstName() {
        const name = "first_name";
        const label = "First Name";

        const min = 1;
        const max = 255;

        return <MyInput type="text" value={this.state.first_name} label={label} name={name}
                           onChange={this.handleChange} required
                           validations={{
                               minLength: min,
                               maxLength: max
                           }}
                           validationErrors={{
                               minLength: 'You must enter at least ' + min + ' characters',
                               maxLength: 'You can not enter more than ' + max + ' characters'
                           }}
        />;
    },
    renderLastName() {
        const name = "last_name";
        const label = "Last Name";

        const min = 1;
        const max = 255;

        return <MyInput type="text" value={this.state.last_name} label={label} name={name}
                           onChange={this.handleChange} required
                           validations={{
                               minLength: min,
                               maxLength: max
                           }}
                           validationErrors={{
                               minLength: 'You must enter at least ' + min + ' characters',
                               maxLength: 'You can not enter more than ' + max + ' characters'
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
    renderPasswordFields() {
        return <PasswordFields password={this.state.password} handleChange={this.handleChange}
                               confirmPassword={this.state.confirm_password} existing={this.state.existing}
        />;
    },
    render() {
        const first_name = this.renderFirstName();
        const last_name = this.renderLastName()
        const email = this.renderEmail();
        const password = this.renderPasswordFields();
        return (
           <div>
                {first_name}
                {last_name}
                {email}
                {password}
            </div>
        );
    }
});