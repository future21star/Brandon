var CommunicationFields = React.createClass({
    getInitialState() {
        return {
            opt_in: true,
        }
    },
    componentDidMount(){
        this.sendState(this.state);
    },
    stateToObject(state) {
        return {
            opt_in: state.opt_in
        }
    },
    sendState(state) {
        this.props.handleChange('communication', this.stateToObject(state));
    },
    handleChange(e) {
        var state = this.state;
        var name = e.target.name;
        state[name] = !state[name];
        this.sendState(state);
        this.setState(state);
    },
    render() {
        return (
            <div>
                <MyCheckbox type="checkbox"
                                value={this.state.opt_in}
                                name='opt_in'
                                label='Yes I would like to receive news letters, promotions or other electronic forms of communication'
                                onChange={this.handleChange}
                />
            </div>
        );
    }
});