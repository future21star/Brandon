var MyRadio = React.createClass({
   render() {
       return (
           <label className={this.props.hidden ? 'hidden' : 'radioButton'} >
                    <input type="radio" name={this.props.name} value={this.props.value} onChange={this.props.onChange}
                           checked={this.props.check == this.props.value}/>
                    {this.props.text}
            </label>
       );
   }
});