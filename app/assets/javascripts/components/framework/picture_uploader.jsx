var PictureUploader = React.createClass({
    getInitialState () {
        return {
            errors: {}
        };
    },
    onDrop: function(files) {
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var data = new FormData();
            data.append('file', file);
            $.ajax({
                url: Routes.pictures_path(),
                dataType: 'json',
                type: 'POST',
                // data: obj,
                data: data,
                processData: false, // Don't process the files
                contentType: false, // Set content type to false as jQuery will tell the server its a query string request
                // beforeSend: function (xhr, settings) {
                //     this.disableButton();
                //     this.setState({wasSubmitted: true});
                // }.bind(this),
                success: function (data) {
                    this.props.addPicture(data);
                    // console.log("data: " + JSON.stringify(data));
                    // data: {"id":19,"a_file_name":"3346-green-curves-1920x1080-abstract-wallpaper.jpg","a_content_type":"image/jpeg",
                    //     "a_file_size":618845,"a_updated_at":"2016-08-16T16:57:14.917Z","generated_name":"PH91SeiPooqek3t8nsJFIw.jpg",
                    //     "user_id":3,"created_at":"2016-08-10T04:32:36.000Z","updated_at":"2016-08-10T04:32:36.000Z"}
                    // onSuccessCallback(data);
                    // this.setState(this.getInitialState());
                }.bind(this),
                error: function (xhr, status, err) {
                    var json = xhr.responseJSON;
                    this.setState({errors: json});
                }.bind(this)
            });
        }
    },
    onOpenClick () {
        this.refs.dropzone.open();
    },
    render () {
        return (
            <div>
                <Dropzone onDrop={this.onDrop}>
                    <div>Try dropping some files here, or click to select files to upload.</div>
                </Dropzone>
                <button type="button" onClick={this.onOpenClick}>
                    Open Dropzone
                </button>
            </div>
        );
    }
});