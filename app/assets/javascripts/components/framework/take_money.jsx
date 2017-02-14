var TakeMoney = React.createClass({
    render(){
        return (
            <div>
                <StripeCheckout
                    token={this.props.onToken}
                    stripeKey={this.props.apiKey}
                    amount={this.props.amount}
                />
            </div>
        )
    }
});