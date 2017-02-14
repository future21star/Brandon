
var PromotionCode = React.createClass({
    handleChange(e) {
        e.preventDefault();
        this.props.handleChange(e);
    },
    render() {
        const name = "promo_code";
        const label = "Promo Code";

        const max = 25;

        return <MyInput type="text" value={this.props.promoCode} label={label} name={name}
                        onChange={this.handleChange}
                        validations={{
                            maxLength: max
                        }}
                        validationErrors={{
                            maxLength: 'You can not enter more than ' + max + ' characters'
                        }}
                />
    },
});