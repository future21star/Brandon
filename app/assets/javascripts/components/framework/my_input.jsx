var MyInput = React.createClass({

    getInitialState() {
        return {
            required: this.props.required
        }
    },
    // Add the Formsy Mixin
    mixins: [Formsy.Mixin],
    // setValue() will set the value of the component, which in
    // turn will validate it and the rest of the form
    changeValue(event) {
        this.setValue(event.currentTarget[this.props.type === 'checkbox' ? 'checked' : 'value']);
        this.props.onChange(event);
    },
    render() {
        // An error message is returned ONLY if the component is invalid
        // or the server has returned an error message
        const errorMessage = this.getErrorMessage();
        const label_value = getFormLabel(this.isRequired(), this.props);
        const className = getClassNameBasedOnValidation(this.isValid(), this.showRequired(), this.props);
        const label = <label htmlFor={this.props.name}>{label_value}</label>;
        const placeholder = this.props.placeholder;
        return (
            <div className={className}>
                {label}
                <br/>
                <input
                    type={this.props.type || 'text'}
                    name={this.props.name}
                    placeholder={placeholder}
                    onChange={this.changeValue}
                    value={this.getValue()}
                    checked={this.props.type === 'checkbox' && this.getValue() ? 'checked' : null}
                    onBlur={this.props.onBlur}
                    autoFocus={this.props.focus}
                />
                <input type="hidden" data-pristine-marker value={this.isPristine()}/>
                <span className='validation-error'>{errorMessage}</span>
            </div>
        );
    }
});