var PreferencesField = React.createClass({
    getInitialState() {
        var instance = this.props.instance;
        return {
            index: this.props.index,

            id: instance.id,
            email: instance.email,
            internal: instance.internal,
            name: instance.name,
        }
    },
    stateToObject(state) {
        return {
            id: state.id,
            email: state.email,
            internal: state.internal,
            name: state.name,
        }
    },
    handleChange(e) {
        var state = this.state;
        var name = e.target.name;
        state[name] = !state[name];
        this.props.handleChange(this.state.index, this.stateToObject(state));
        this.setState(state);
    },
    render() {
        
        return (
            <tbody>
                <tr className="preferences">
                    <td>
                        <span>{this.props.instance.name}</span>
                    </td>
                    <td>
                        <MyInput type="checkbox"
                             value={this.state.email}
                             name='email'
                             onChange={this.handleChange}
                        />
                    </td>
                    <td>
                        <MyInput type="checkbox"
                             value={this.state.internal}
                             name='internal'
                             onChange={this.handleChange}
                        />
                    </td>
                </tr>
            </tbody>
        );
        
    }
});