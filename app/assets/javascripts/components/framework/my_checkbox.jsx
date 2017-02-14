var MyCheckbox = React.createClass({

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
        this.setValue(event.currentTarget['checked']);
        this.props.onChange(event);
    },
    render() {
        // An error message is returned ONLY if the component is invalid
        // or the server has returned an error message
        const errorMessage = this.getErrorMessage();
        const className = getClassNameBasedOnValidation(this.isValid(), this.showRequired(), this.props);
        const label_value = getFormLabel(this.isRequired(), this.props);
        const input =
            <label>
                <input
                    type='checkbox'
                    name={this.props.name}
                    onChange={this.changeValue}
                    value={this.getValue()}
                    checked={this.getValue() ? 'checked' : null}/>
                    {label_value}
            </label>;
        return (
            <div className={className}>
                {input}
                <input type="hidden" data-pristine-marker value={this.isPristine()}/>
                <span className='validation-error'>{errorMessage}</span>
            </div>
        );
    }
});