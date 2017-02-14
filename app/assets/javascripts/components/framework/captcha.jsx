var Captcha = React.createClass({
    getInitialState() {
        return {
            captcha_key: '',
            loading: true,
        };
    },
    componentDidMount() {
        this.setState({loading: true});
        var url = Routes.static_captcha_key_path();
        this.serverRequest = $.get(url, function (result) {
            const site_key = result['site_key'];
            this.setState({captcha_key: site_key, loading: false});
        }.bind(this));
    },
    onChange(value) {
        this.props.onChange('captcha', value);
        // console.log("Captcha value:", value);
    },
    render() {
        var captcha = '';
        if (!this.state.loading) {
            captcha = <ReCAPTCHA
                name="captcha"
                sitekey={this.state.captcha_key}
                theme="dark"
                onChange={this.onChange}
            />
        }
        return (
            <div>
                {captcha}
            </div>
        );
    }
});