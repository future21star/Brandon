var BasicSelect = React.createClass({
    mixins: [Formsy.Mixin],
  render() {
    var options = [];
    var len = this.props.instances.length;
    for (var i = 0; i < len; i++) {
        var instance = this.props.instances[i];
        options.push(<option value={instance.id} key={instance.id}
                         name={instance.name}>{instance.name}</option>);
    }
    var selected = (this.props.selected ? this.props.selected : '');
    return (
        <div className={this.props.hidden ? 'hidden' : ''}>
            <label htmlFor={this.props.name}>{this.props.label}</label>
            <br/>
            <select name={this.props.name} value={selected} onChange={this.props.onChange}>
              {options}
            </select>
        </div>
    );
  }
});