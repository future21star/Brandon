var PurchasingForm = React.createClass({
    getInitialState() {
        return ({
            action: ACTION_CREATE,

            package_id: this.props.package.id,
            total: this.props.package.total * 100,

            promo_code: '',

            key: 0,
            errors: {}
        });
    },
    stateToObject(token) {
        var card = token['card'];
        return {
            package:  {
                id: this.state.package_id,
            },
            history: {
                email: card.email,
                brand: card.brand,
                last_4: card.last4,
                exp_month: card.exp_month,
                exp_year: card.exp_year,
            },
            token: token,
            promo_code: {
                code: this.state.promo_code,
                source: this.props.source
            },
        }
    },
    onToken(token){
        var obj = this.stateToObject(token);

        $.ajax({
            url: Routes.purchases_path,
            dataType: 'json',
            type: 'POST',
            data: obj,
            success: function (data) {
                window.location.href=(Routes.purchases_completed_path() + '?id=' + data.id);
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                // console.log("obj " + JSON.stringify(json));
                this.setState({errors: json, key: this.state.key++});
            }.bind(this)
        });
    },
    handleChange(e) {
        e.preventDefault();
        var name = e.target.name;
        var value = e.target.value;
        this.state[name] = value;
        // this is required for the drop down to re-render
        this.setState({key: this.state.key++});
    },
    renderPromoCode() {
        return <PromotionCode promoCode={this.state.promo_code} handleChange={this.handleChange} />
    },
    renderCheckout() {
        return  <TakeMoney onToken={this.onToken} apiKey={this.props.api_key} amount={this.state.total} />
    },

    render() {

        const take_money = this.renderCheckout();
        const promo_code = this.renderPromoCode();

        return (
            <Formsy.Form key={this.state.key} validationErrors={this.state.errors}>
                {promo_code}
                {take_money}
            </Formsy.Form>
        );
    }
});