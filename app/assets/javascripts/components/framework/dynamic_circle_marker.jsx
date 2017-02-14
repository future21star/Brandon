var DynamicCircleMarker = React.createClass({
   render() {
       brackets = [[1,3],[4,7],[5,10],[11,14],[15,20]];
       factors =[15,18,21, 24,0];
       const zoom = (this.props.$geoService.transform_._zoom).clamp(1, 20);
       factor = 1;
       for (var i = 0; i < factors.length; i++) {
           var min = brackets[i][0];
           var max = brackets[i][1];
           if (zoom >= min && zoom <= max) {
               factor = factors[i];
               break;
           }
       }
       const K_WIDTH = zoom*factor;
       const K_HEIGHT = zoom*factor;
       const OPACITY = zoom <= 14 ? .2 : 0;


       const marker_style = {
           // initially any map object has left top corner at lat lng coordinates
           // it's on you to set object origin to 0,0 coordinates
           position: 'absolute',
           width: K_WIDTH,
           height: K_HEIGHT,
           left: -K_WIDTH / 2,
           top: -K_HEIGHT / 2,

           border: '5px solid #f44336',
           opacity: OPACITY,
           borderRadius: K_HEIGHT,
           backgroundColor: 'white',
           textAlign: 'center',
           color: '#3f51b5',
           fontSize: 16,
           fontWeight: 'bold',
           padding: 4
       };

       // console.log("marker style: " + JSON.stringify(marker_style));

       return (
           <div style={marker_style} />
       );
   }
});