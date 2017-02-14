styles = {
    item: {
    },

    highlightedItem: {
        background: 'hsl(200, 50%, 50%)',
    },

    menu: {
        border: 'solid 1px #ccc'
    }
    
};

var TagCloud = React.createClass({
    getInitialState() {
        var existing = this.props.existing;
        var tags = [];
        if (existing) {
            tags = this.props.tags;
        }
        var availableTags = this.props.allTags;
      return {
          existing: existing,
          tags: tags,
          availableTags: availableTags,
          value: '',
          sourceId: this.props.sourceId,
      }
    },
    addTag(id) {
        var index = getIndex(id, this.state.availableTags);
        if (this.state.existing) {
            var url = Routes.business_tag_create_path({tag: {id: id}});
            if (this.props.type == TAG_TYPE_PROJECT) {
                url = Routes.project_tag_create_path(this.state.sourceId, {tag: {id: id}});
            }
            this.handleCRUD(url, ACTION_CREATE, index, this.onSuccessfulAdd);
        } else {
           this.onSuccessfulAdd(this.state.availableTags[index], index);
        }
        this.setState({value: '' })
    },
    removeTag(id) {
        var index = getIndex(id, this.state.tags);
        if (this.state.existing) {
            var url = Routes.business_tag_destroy_path({tag: {id: id}});
            if (this.props.type == TAG_TYPE_PROJECT) {
                url = Routes.project_tag_destroy_path(this.state.sourceId, {tag: {id: id}});
            }
            this.handleCRUD(url, ACTION_DELETE, index, this.onSuccessfulDelete);
        } else {
            this.onSuccessfulDelete(this.state.tags[index], index);
        }
    },
    handleCRUD(url, action, index, onSuccessCallback) {
        $.ajax({
            url: url,
            dataType: 'json',
            contentType: 'application/json',
            type: action,
            success: function (data) {
                onSuccessCallback(data, index);
            }.bind(this),
            error: function (xhr, status, err) {
                var json = xhr.responseJSON;
                // TODO Where to send the errors?
            }.bind(this)
        });
    },
    onSuccessfulAdd(data, index) {
        var state = this.state;
        state.tags.push(data);
        state.availableTags.splice(index, 1);
        state.key += 1;
        this.setState(state);
        if (this.props.tagUpdates) {
            this.props.tagUpdates('tags', state.tags);
        }
    },
    onSuccessfulDelete(data, index) {
        var state = this.state;
        state.tags.splice(index, 1);
        state.availableTags.push(data);
        state.key += 1;
        this.setState(state);
    },
    renderTags() {
      var tags = [];

        if (!isEmpty(this.state.tags)) {
            var len = this.state.tags.length;
            for (var i = 0; i < len; i++) {
                var tag = this.state.tags[i];
                if (tag != null) {
                    tags.push(
                        <Tag key={tag.id} id={tag.id} name={tag.name} remove={this.removeTag}/>
                    );
                }
            }
        }

        return tags;
    },
    matchTagToTerm (tag, value) {
        return (
            tag.name.toLowerCase().indexOf(value.toLowerCase()) !== -1
        )
    },
    render() {
        const tags = this.renderTags();
        return (
            <div className="tags_list form-group ">
                <label>{this.props.label+ '*'}</label>
                <br/>
                <Autocomplete
                    value={this.state.value}
                    inputProps={{name: "tags", id: "tags-autocomplete"}}
                    items={this.state.availableTags}
                    getItemValue={(item) => item.id.toString()}
                    shouldItemRender={this.matchTagToTerm}
                    onChange={(event, value) => this.setState({ value })}
                    onSelect={value =>  this.addTag(value)}
                    renderItem={(item, isHighlighted) => (
                        <div className="choose_tags"
                            style={isHighlighted ? styles.highlightedItem : styles.item}
                            key={item.abbr}
                        >{item.name}</div>
                    )}
                />
                {tags}
            </div>
        );
    }
});