var Measurement = React.createClass({
    getInitialState() {
        const existing = !isEmpty(this.props.instance);
        const value = existing ? this.props.instance.value : '';
        const unit = existing ? this.props.instance.unit_quantifier_id : this.props.measurementUnits[0].id;
        const type = existing ? this.props.instance.classification_quantifier_id : this.props.measurementTypes[0].id;
        const id = existing ? this.props.instance.id : '';
        const saved = existing && '' !== id;
        return {
            index: this.props.index,
            id: id,
            value: value,
            unit_quantifier_id: unit,
            classification_quantifier_id: type,

            existing: existing,
            saved: saved,

        }
    },
    stateToObject(state) {
          return {
              value: state.value,
              id: state.id,
              unit_quantifier_id: state.unit_quantifier_id,
              classification_quantifier_id: state.classification_quantifier_id,
          }
    },
    handleChange(e) {
        e.preventDefault();
        var state = this.state;
        var name = e.target.name;
        var value = e.target.value;
        state[name] = value;
        this.props.handleChange(this.state.index, this.stateToObject(state));
        this.setState(state);
    },
    handleDelete(e) {
        e.preventDefault();
        this.props.handleDelete(this.state.id, this.state.saved);
    },
    renderValue() {
        const name = 'value';
        const label = 'Value';

        return <MyInput type="text" value={this.state.value} label={label} name={name}
                        onChange={this.handleChange}
                        required
                        validations={eval(isDecimal)} validationError="Must be a valid number"
            />;
    },
    renderMeasurementUnit() {
        return <BasicSelect name="unit_quantifier_id" selected={this.state.unit_quantifier_id} onChange={this.handleChange}
                            label="Unit" instances={this.props.measurementUnits}
        />
    },
    renderMeasurementType() {
        return <BasicSelect name="classification_quantifier_id" selected={this.state.classification_quantifier_id}
                            label="Quantifier" onChange={this.handleChange} instances={this.props.measurementTypes}
        />
    },
    render() {
        var fields = '';

        if (this.state.existing && !this.props.editing && this.state.saved) {
            var unit = getValueAtIndex(this.state.unit_quantifier_id, this.props.measurementUnits);
            var classification = getValueAtIndex(this.state.classification_quantifier_id, this.props.measurementTypes);
            fields = <div><label htmlFor='value'>{this.state.value}</label>
                <label htmlFor='unit_quantifier_id'>{unit}</label>
                <label htmlFor='classification_quantifier_id'>{classification}</label></div>
        } else {
            const value = this.renderValue();
            const measurementUnit = this.renderMeasurementUnit();
            const measurementType = this.renderMeasurementType();
            const deleteLink = this.state.existing ? <a onClick={this.handleDelete}>delete</a> : '';
            fields = eval([deleteLink,value, measurementUnit, measurementType]);
        }
        return (
            <div>
                {fields}
            </div>
        );
    }
});