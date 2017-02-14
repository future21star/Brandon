PASSWORD_MIN = 8;

var PasswordFields = React.createClass({
    getInitialState() {
        return ({

        });
    },
    handleChange(e) {
        e.preventDefault();
        this.props.handleChange(e);
    },
    renderPassword() {
        const name = "password";
        const label = "Password";

        const min = PASSWORD_MIN;
        const max = 255;

        return <MyInput type="password" value={this.props.password} label={label} name={name}
                           onChange={this.handleChange} required={!this.props.existing}
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
    renderConfirmPassword() {
        const name = "confirm_password";
        const label = "Confirm Password";

        return <MyInput type="password" value={this.props.confirmPassword} label={label} name={name}
                            onChange={this.handleChange} required={!this.props.existing}
                            validations="equalsField:password"
                            validationErrors={{
                                equalsField: 'Passwords do not match',
                            }}
        />;
    },
    renderCurrentPassword() {
        var field = '';
        const name = "current_password";
        const label = "Current Password";

        if (this.props.existing) {
            const min = PASSWORD_MIN;
            field = <MyInput type="password" value={this.props.currentPassword} label={label} name={name}
                             onChange={this.handleChange} required
                             validations={{
                                 minLength: min,
                             }}
                             validationErrors={{
                                 minLength: 'You must enter at least ' + min + ' characters',
                             }}
            />;
        }
        return field;
    },
    render() {
        const password = this.renderPassword();
        const confirm_password = this.renderConfirmPassword();
        const current_password = this.renderCurrentPassword();
        return (
           <div>
                {password}
                {confirm_password}
                {current_password}
            </div>
        );
    }
});