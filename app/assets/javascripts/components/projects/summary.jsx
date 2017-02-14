var Summary = React.createClass({
    redirectToView (e) {
        e.preventDefault();
        this.props.redirectToView(this.props.instance);
    },
    render() {
        return (
            
            <div onClick={this.redirectToView} className="col-xs-12 col-sm-4 col-md-3">
                <h3 className="title" htmlFor={this.props.instance.title}>Title: {this.props.instance.title}</h3>
                <div className="project-box">
                  <div className="top_icons">
                      <span>
                          <i className="fa fa-eye"></i>
                      </span>
                       {(this.props.instance.mine==1)? <span ><i className="fa fa-user"></i></span> : ''}
                      {(this.props.instance.quoted)? <span ><i className="fa fa-calculator"></i></span> : ''}
                  </div>
                  <img src={this.props.instance.picture_url} alt="pictures url" className="img-responsive" />                
                  <input type="hidden" name="project_id" value={this.props.instance.project_id}/>
                </div>
            </div>
            
        );
    }
});


// <td><%= image_tag summary.picture.a.url(:thumb)%></td>
// -        <td><%= summary.project.summary %></td>
// -        <td><%= link_to 'Show', summary.project %></td>
// -        <td><%= link_to 'Edit', edit_project_path(summary.project) %></td>
// -        <td><%= link_to 'Destroy', summary.project, method: :delete, data: { confirm: 'Are you sure?' } %></td>
