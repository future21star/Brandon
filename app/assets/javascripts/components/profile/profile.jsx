var Profile = React.createClass({
    getInitialState() {
        var tab = this.props.tab ? this.props.tab : TAB_USER;
        return ({
            tab: tab,
            pictures: this.props.pictures,
        });
    },
    renderUser() {
        var field = '';
        if (this.state.tab == TAB_USER) {
            field = <UserForm
                instance={this.props.user}
            />
        }
        return field;
    },
    renderBusiness() {
        var field = '';
        if (this.state.tab == TAB_BUSINESS) {
            field = <BusinessForm
                instance={this.props.business}
                allTags={this.props.allTags}
            />
        }
        return field;
    },
    renderAddress() {
        var field = '';
        if (this.state.tab == TAB_ADDRESS) {
          field = <AddressForm
              countries={this.props.countries}
              provinces={this.props.provinces}
              instance={this.props.address}
              />
        }
        return field;
    },
    renderNotifications() {
        var field = '';
        if (this.state.tab == TAB_NOTIFICATIONS) {
          field = <PreferencesForm preferences={this.props.preferences} />
        }
        return field;
    },
    renderLocations() {
        var field = '';
        if (this.state.tab == TAB_LOCATIONS) {
          field = <LocationForm instances={this.props.locations} />
        }
        return field;
    },
    addPicture(instance) {
        var instances = this.state.pictures.slice();
        instances.push(instance);
        this.setState({
            instances: instances
        });
    },
    renderPictures() {
        var field = '';
        if (this.state.tab == TAB_PICTURES) {
          field = <div><MediaViewer sources={this.state.pictures} /><PictureUploader files={this.state.pictures} addPicture={this.addPicture} /></div>;

        }
        return field;
    },
    changeTab(tab) {
      this.setState({tab: tab});
    },
    render() {
        const user = this.renderUser();
        const address = this.renderAddress();
        const business = this.renderBusiness();
        const notifications = this.renderNotifications();
        const locations = this.renderLocations();
        const pictures = this.renderPictures();
        const business_name = this.props.business ? this.props.business.company_name : '';

        return (
          <div className="profile-wrapper">
          	<div className="profile-cover">
							<a href="#" className="upload-cover-img"><i className="fa fa-camera"></i> Upload image </a>
						</div>
						<div className="profile-container">
							<div className="container">
								<div className="profile-avatar">
									<img src={this.props.user.picture} alt="profile_picture" className="img-circle" />
									<span className="upload-avatar"><a href="#"><i className="fa fa-camera"></i></a></span>
								</div>
								<div className="user-details row">
									<div className="user col-xs-12 col-sm-3">
										<h3>{this.props.user.full_name}</h3>
										<h4>{business_name}</h4>
									</div>
									
									<ul className="list-unstyled col-xs-12 col-sm-9	">
										<li>
											<h3>26</h3>
											<h5>My Projects</h5>
										</li>
										<li>
											<h3>5</h3>
											<h5>My Bids</h5>
										</li>
										<li>
											<h3>19</h3>
											<h5>My Views</h5>
										</li>
									</ul>
							</div>
						</div>
						</div>  
            <div className="nav-wrapper">
                <div className="navtabs-custom navtabs-responsive">
                  <ul className="navtabs">
                    <li className="active"><a onClick={this.changeTab.bind(this, TAB_USER)}>User</a></li>
                    <li><a onClick={this.changeTab.bind(this, TAB_BUSINESS)}>Business</a></li>
                    <li><a onClick={this.changeTab.bind(this, TAB_ADDRESS)}>Address</a></li>
                    <li><a onClick={this.changeTab.bind(this, TAB_NOTIFICATIONS)}>Notifications</a></li>
                    <li><a onClick={this.changeTab.bind(this, TAB_LOCATIONS)}>Locations</a></li>
                    <li><a onClick={this.changeTab.bind(this, TAB_PICTURES)}>Pictures</a></li>
                  </ul>
                </div>
                <div className="container">
                  <div className="tab-content col-sm-offset-2 col-sm-8">
                    {user}
                    {business}
                    {address}                    
                    {notifications}
                    {locations}
                    {pictures}
                  </div>
                </div>
              </div>
          </div>            
        );
    }
});