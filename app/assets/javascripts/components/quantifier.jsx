var Quantifier = React.createClass({
    mixins: [Formsy.Mixin],
  render() {
    var options = [];
    var type = this.props.timed ? 1 : this.props.distance ? 2 : null;
    var len = this.props.quantifiers.length;
    for (var i = 0; i < len; i++) {
      var quantifier = this.props.quantifiers[i];
        if (type == null || quantifier.category_id == type) {
            options.push(<option value={quantifier.id} key={quantifier.id}
                                 name={quantifier.quantifier}>{quantifier.quantifier}</option>);
        }
    }
    var selected = (this.props.selected ? this.props.selected : '');
    return (
        <div>
            <MyInput type="text" value={this.props.value} label={this.props.inputPlaceholder} name={this.props.inputName}
                     onChange={this.props.onChange} required validations={eval(isDecimal)}
                     validationError="Must be a positive number"
            />
            <select name={this.props.name} value={selected} onChange={this.props.onChange}>
              {options}
            </select>
        </div>
    );
  }
});