var ProjectActions = React.createClass({
    changeToEditMode (e) {
        e.preventDefault();

    },
    redirectAway() {
        window.location.href = Routes.projects_path;
        //TODO Toaster
    },
    cancel (e) {
        e.preventDefault();

        $.ajax({
            url: Routes.cancel_project_path(this.props.id),
            type: 'PATCH',
            success: function (data) {
                // this.redirectAway();
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                this.setState({errors: json});
            }.bind(this)
        });
    },
    publish (e) {
        e.preventDefault();

        $.ajax({
            url: Routes.publish_project_path(this.props.id),
            type: 'PATCH',
            success: function (data) {
                // onSuccessCallback(data);
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                this.setState({errors: json});
            }.bind(this)
        });
    },
//     delete (e) {
//         e.preventDefault();
// //TODO Delete confirmation
//         $.ajax({
//             url: Routes.project_path(this.props.id),
//             type: ACTION_DELETE,
//             success: function (data) {
//                 this.redirectAway();
//             }.bind(this),
//             error: function (xhr, status, err) {
//                 var json = xhr.responseJSON;
//                 this.setState({errors: json});
//             }.bind(this)
//         });
//     },
    callback() {

    },
    render() {
        var state_rules = this.props.rules.state_rules;
        var publish = state_rules.may_publish ? <a onClick={this.publish}>Publish</a> : '';
        var cancel = state_rules.may_cancel? <a onClick={this.cancel}>Cancel</a> : '';
        // var del = rules.may_delete ? <a onClick={this.delete}>Delete</a> : '';
        return (
            <div>
                {publish}
                {cancel}
                {/*<a onClick={this.delete}>Delete</a>*/}
            </div>
        );
    }
});


//
// <% if @project.closed? or @project.accepted? %>
// <!--Partial needs to be here-->
// <% @quotes.each { |q|
//     estimates = q.estimates
//     estimates.each { |e| %>
//     <div class="field">
//     <% if e.accepted_at%>
//     <b>Accepted!</b><br>
//     <% end %>
//     <%= e.summary %><br>
//     <%= e.price %><br>
//     <%= e.duration%><br>
//     <% if @project.closed? %>
//     <%= link_to('Accept Quote', accept_quote_path(@project, e), :method => :patch ) %>
//           <% end %>
//         </div>
//     <% }
//   }%>
//
// <% end %>