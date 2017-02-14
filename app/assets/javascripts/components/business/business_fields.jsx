var BusinessFields = React.createClass({
    getInitialState() {
        const existing = !isEmpty(this.props.instance);

        var id = '';
        var companyName = '';
        var phoneNumber = '';
        var website = '';
        var biography = '';
        var tags = [];
        if (existing) {
            var instance = this.props.instance;

            id = instance.id;
            companyName = instance.company_name;
            phoneNumber = instance.phone_number;
            website = instance.website;
            biography = instance.biography;
            tags = instance.tags;
        }
        return ({
            existing: existing,

            id: id,
            company_name: companyName,
            phone_number: phoneNumber,
            website: website,
            biography: biography,

            tags: tags,
        });
    },
    stateToObject(state) {
        return {
            id: state.id,
            company_name: state.company_name,
            phone_number: state.phone_number,
            website: state.website,
            biography: state.biography,
        }
    },
    handleChange(e) {
        e.preventDefault();
        var state = this.state;
        var name = e.target.name;
        var value = e.target.value;
        state[name] = value;
        this.props.handleChange('business', this.stateToObject(state));
        this.setState(state);
    },
    renderCompanyName() {
        const name = "company_name";
        const label = "Company Name";

        const min = 2;
        const max = 255;

        return <MyInput type="text" value={this.state.company_name} label={label} name={name}
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
    renderPhoneNumber() {
        const name = "phone_number";
        const label = "Phone Number";
        const placeholder = "(905) 555-1234";

        const min = 10;
        const max = 15;

        return <MyInput type="text" value={this.state.phone_number} label={label} name={name}
                           placeholder={placeholder}
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
    renderWebsite() {
        const name = "website";
        const label = "Website";
        const placeholder = "http://www.quotr.ca";

        return <MyInput type="text" value={this.state.website} label={label} name={name}
                       placeholder={placeholder}
                       onChange={this.handleChange}
                       validations="isUrl"
                       validationErrors={{
                            isUrl: 'You must enter a valid url such as http://quotr.ca',
                        }}
        />;
    },
    renderBiography() {
        const name = 'biography';
        const label = 'Biography';
        return <MyTextArea value={this.state.biography} label={label} name={name}
                                  onChange={this.handleChange}/>;
    },
    renderTags() {
        const label = 'Industry Tags';
       return <TagCloud tags={this.state.tags}
                        label={label}
                        allTags={this.props.allTags}
                        existing={this.state.existing}
                        tagUpdates={this.props.handleChange} />;
    },
    render() {
        const company_name = this.renderCompanyName();
        const phone_number = this.renderPhoneNumber();
        const website = this.renderWebsite();
        const biography = this.renderBiography();
        const tags = this.renderTags();
        return (
           <div>
                {company_name}
                {phone_number}
                {website}
                {biography}
                {tags}
            </div>
        );
    }
});