var ScrollBox = React.createClass({
    render() {
        return (
            <div className='scrollbox'>
                <span dangerouslySetInnerHTML={{__html: this.props.text}} />
            </div>
        );
    }
});