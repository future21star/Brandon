var Estimate = React.createClass({
    changeToEditMode (e) {
        e.preventDefault();
        this.props.changeToEditMode(this.props.instance);
    },
    changeToDeleteMode (e) {
        e.preventDefault();
        this.props.changeToDeleteMode(this.props.instance);
    },
    render() {
        // console.log('sub render quantifiers: ' + this.props.quantifiers.length + " instance: " + JSON.stringify(this.props.instance)); //.id + " quantifier_id: " + this.props.instance.quantifier_id)
        var index = getIndex(this.props.instance.quantifier_id, this.props.quantifiers);
        // console.log("index: " + index + " josn: " + JSON.stringify(index))
        var duration = this.props.quantifiers[index].quantifier;
        return (
            <div>
                <div><label htmlFor={this.props.instance.summary}>Summary: {this.props.instance.summary}</label></div>
                <div><label htmlFor={this.props.instance.price}>Price: {this.props.instance.price}</label></div>
                <div><label htmlFor={this.props.instance.duration}>Duration: {this.props.instance.duration} {duration}</label></div>
                <div><label htmlFor={this.props.instance.description}>Description: {this.props.instance.description}</label></div>
                <a onClick={this.changeToEditMode}>Edit</a> <a onClick={this.changeToDeleteMode}>Delete</a>
            </div>
        );
    }
});