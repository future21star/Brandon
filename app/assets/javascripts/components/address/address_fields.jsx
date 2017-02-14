var AddressFields = React.createClass({
    getInitialState() {
        const existing = this.props.instance && this.props.instance.id != null;
        var country = this.props.countries[0].id;
        var provinces =countyToProvinceList(country, this.props.provinces)[0];
        var province = provinces.id;

        var id = '';
        var houseNumber = '';
        var streetName = '';
        var postalCode = '';
        var apartment = '';
        var city = '';
        if (existing) {
            var instance = this.props.instance;
            province = instance.province;
            country = instance.country;

            id = instance.id;
            houseNumber = instance.house_number;
            streetName = instance.street_name;
            postalCode = instance.postal_code;
            apartment = instance.apartment;
            city = instance.city;
        }
        return {
            provinces: provinces,

            id: id,
            house_number: houseNumber,
            street_name: streetName,
            postal_code: postalCode,
            apartment: apartment,
            city: city,
            country: country,
            province: province,
        }
    },
    stateToObject(state) {
        return {
            id: state.id,
            house_number: state.house_number,
            street_name: state.street_name,
            postal_code: state.postal_code,
            apartment: state.apartment,
            city: state.city,
            province_id: state.province,
        }
    },
    handleChange(e) {
        e.preventDefault();
        var state = this.state;
        var name = e.target.name;
        var value = e.target.value;
        state[name] = value;
        this.props.handleChange('address', this.stateToObject(state));
        this.setState(state);
    },
    render() {
        return (
            <div key={this.key}>
                <MyInput type="text" value={this.state.house_number} label='House number' name='house_number' onChange={this.handleChange}
                         required
                         validations={{
                             maxLength: 10
                         }}
                         validationErrors={{
                             maxLength: 'You can not enter more than 10 characters'
                         }}
                    />
                <MyInput type="text" value={this.state.apartment} label='Unit' name='apartment' onChange={this.handleChange}
                         validations={{
                             maxLength: 15
                         }}
                         validationErrors={{
                             maxLength: 'You can not enter more than 15 characters'
                         }}/>
                <MyInput type="text" value={this.state.street_name} label='Street' name='street_name' onChange={this.handleChange}
                         required
                         validations={{
                             maxLength: 255
                         }}
                         validationErrors={{
                             maxLength: 'You can not enter more than 255 characters'
                         }}
                />
                <MyInput type="text" value={this.state.city} label='City' name='city' onChange={this.handleChange}
                         required
                         validations={{
                             maxLength: 255
                         }}
                         validationErrors={{
                             maxLength: 'You can not enter more than 255 characters'
                         }}
                />
                <MyInput type="text" value={this.state.postal_code} label='Postal code' name='postal_code' onChange={this.handleChange}
                         required validations={eval(isPostalOrZip)} validationError="Must be a valid postal or zip code"/>
                <BasicSelect name="country" label="Country" selected={this.state.country} onChange={this.handleChange} instances={this.props.countries} />
                <ProvinceList name="province" selected={this.state.province} onChange={this.handleChange} instances={this.props.provinces}
                    country={this.state.country}/>
            </div>
        );
    }
});