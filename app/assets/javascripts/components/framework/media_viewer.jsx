//      IMAGES SCHEMA

// image {
//         original: `${PREFIX_URL}1.jpg`,
//         thumbnail: `${PREFIX_URL}1t.jpg`,
//         originalClass: 'featured-slide',
//         thumbnailClass: 'featured-thumb',
//         description: 'Custom class for slides & thumbnails'
//     }

// video {
//         thumbnail: `${PREFIX_URL}3v.jpg`,
//         original: `${PREFIX_URL}3v.jpg`,
//         embedUrl: 'https://www.youtube.com/embed/iNJdPyoqt8U?autoplay=1&showinfo=0',
//         description: 'Render custom slides within the gallery',
//         renderItem: this._renderVideo.bind(this)
//     }

var MediaViewer = React.createClass({
    getInitialState () {
        // convert our DTO format to the react components format
        var images = [];
        if (this.props.sources) {
            var loop = this.props.sources;
            for (var i=0; i < loop.length; i++) {
                var image = loop[i];
                images.push({
                    original: image.url,
                    thumbnail: image.thumbnail_url,
                });
            }
        }
        return {
            showIndex: true,
            slideOnThumbnailHover: true,
            showBullets: true,
            infinite: true,
            showThumbnails: true,
            showFullscreenButton: false,
            showGalleryFullscreenButton: false,
            showPlayButton: false,
            showGalleryPlayButton: false,
            showNav: true,
            slideInterval: 2,
            showVideo: {},

            images: images,
        }
    },
    componentDidUpdate(prevProps, prevState) {
        if (this.state.slideInterval !== prevState.slideInterval) {
            // refresh setInterval
            this._imageGallery.pause();
            this._imageGallery.play();
        }
    },
    _onImageClick(event) {
        // console.debug('clicked on image', event.target, 'at index', this._imageGallery.getCurrentIndex());
    },
    _onImageLoad(event) {
        // console.debug('loaded image', event.target.src);
    },
    _onSlide(index) {
        this._resetVideo();
        // console.debug('slid to index', index);
    },
    _onPause(index) {
        // console.debug('paused on index', index);
    },
    _onScreenChange(fullScreenElement) {
        // console.debug('isFullScreen?', !!fullScreenElement);
    },
    _onPlay(index) {
        // console.debug('playing from index', index);
    },
    _handleInputChange(state, event) {
        this.setState({[state]: event.target.value});
    },
    _handleCheckboxChange(state, event) {
        this.setState({[state]: event.target.checked});
    },
    _resetVideo() {
        this.setState({showVideo: {}});

        if (this.state.showPlayButton) {
            this.setState({showGalleryPlayButton: true});
        }

        if (this.state.showFullscreenButton) {
            this.setState({showGalleryFullscreenButton: true});
        }
    },
    _toggleShowVideo(url) {
        this.state.showVideo[url] = !Boolean(this.state.showVideo[url]);
        this.setState({
            showVideo: this.state.showVideo
        });

        if (this.state.showVideo[url]) {
            if (this.state.showPlayButton) {
                this.setState({showGalleryPlayButton: false});
            }

            if (this.state.showFullscreenButton) {
                this.setState({showGalleryFullscreenButton: false});
            }
        }
    },
    _renderVideo(item) {
        return (
            <div className='image-gallery-image'>
                {
                    this.state.showVideo[item.embedUrl] ?
                        <div className='video-wrapper'>
                            <a
                                className='close-video'
                                onClick={this._toggleShowVideo.bind(this, item.embedUrl)}
                            >
                            </a>
                            <iframe
                                width='560'
                                height='315'
                                src={item.embedUrl}
                                frameBorder='0'
                                allowFullScreen
                            >
                            </iframe>
                        </div>
                        :
                        <a onClick={this._toggleShowVideo.bind(this, item.embedUrl)}>
                            <div className='play-button'></div>
                            <img src={item.original}/>
                            {
                                item.description &&
                                <span
                                    className='image-gallery-description'
                                    style={{right: '0', left: 'initial'}}
                                >
                                    {item.description}
                                </span>
                            }
                        </a>
                }
            </div>
        );
    },
    render() {
        return (

            <section>
                <ImageGallery
                    ref={i => this._imageGallery = i}
                    items={this.state.images}
                    lazyLoad={false}
                    onClick={this._onImageClick}
                    onImageLoad={this._onImageLoad}
                    onSlide={this._onSlide}
                    onPause={this._onPause}
                    onScreenChange={this._onScreenChange}
                    onPlay={this._onPlay}
                    infinite={this.state.infinite}
                    showBullets={this.state.showBullets}
                    showFullscreenButton={this.state.showFullscreenButton && this.state.showGalleryFullscreenButton}
                    showPlayButton={this.state.showPlayButton && this.state.showGalleryPlayButton}
                    showThumbnails={this.state.showThumbnails}
                    showIndex={this.state.showIndex}
                    showNav={this.state.showNav}
                    slideInterval={parseInt(this.state.slideInterval)}
                    slideOnThumbnailHover={this.state.slideOnThumbnailHover}
                />
            </section>
        );
    }
});