
var Tag = React.createClass({
    getInitialState() {
      return {
          id: this.props.id
      }
    },
    remove() {
      this.props.remove(this.state.id);
    },
    render() {
        return (
            <span name={this.props.id} className="tags">
              {this.props.name}
              <a onClick={this.remove}><i className="fa fa-times"></i></a>
            </span>
        );
    }
});