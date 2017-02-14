var ProvinceList = React.createClass({
    mixins: [Formsy.Mixin],
  render() {
    var provinces = countyToProvinceList(this.props.country, this.props.instances);

    var options = [];
    var len = provinces.length;
    for (var i = 0; i < len; i++) {
      var instance = provinces[i];
        options.push(<option value={instance.id} key={instance.id}
                             name={instance.name}>{instance.name}</option>);
    }
    var selected = (this.props.selected ? this.props.selected : '');
    return (
        <div>
            <label htmlFor={this.props.name}>Province</label>
            <br/>
            <select name="province" value={selected} onChange={this.props.onChange}>
              {options}
            </select>
        </div>
    );
  }
});