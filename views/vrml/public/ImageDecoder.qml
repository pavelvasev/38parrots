Image {
  id: dec
  visible: false
  
  property var output: []
  
  onLoaded: output = parse()
  
  function parse() {
  
    var tempCanvas = document.createElement('canvas');
    
    var image = this.domElement;
    
    var width = tempCanvas.width = image.width;
    var height = tempCanvas.height = image.height;
    var tempCtx = tempCanvas.getContext('2d');

    /* Draw the image to the canvas - image is the main image on the page */
    tempCtx.drawImage(image, 0, 0, width, height);

    /* Get the data */
    var imageData = tempCtx.getImageData(0, 0, width, height).data;
    
    var res = [];
    var offset=0;
    for (var y=0; y<height; y++) {
      for (var x=0; x<width; x++, offset += 4) {
        res.push( imageData[ offset ] );
      }
    }
    
    var canvas = document.getElementById("xy");
    var ctx = canvas.getContext('2d');      
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    var xyData = ctx.getImageData(0, 0, canvas.width, canvas.height);           
      var canvasData = xyData.data
      
      /* help line up with arbitrarily scaled backgound chart */
      var scale = 452; 
      var xoffset = 43
      var yoffset = -90;                
      
      for (i=0; i < imageData.length; i+=4){
        /* Maybe helpful to cull dark colors which are often at the edge of the gamut */
        //if ((imageData[i] + imageData[i+1] + imageData[i+2]) < 280 ) continue; 
        XYZ = toXYZ([imageData[i], imageData[i+1], imageData[i+2], imageData[i+3]]);
        
        x = (XYZ[0]/(XYZ[0] + XYZ[1] +XYZ[2]))*scale;
        y = (XYZ[1]/(XYZ[0] + XYZ[1] +XYZ[2]))*scale;

        /* the canvas is upside down. The origin is in the top left. This should flip the y values */
        y = canvas.height - y;

        /* remember x and y are floats. We need to index the canvas buffer with integers */
        pixelIndex = (Math.round(x) + Math.round(y) * xyData.width) * 4; // that's the red pixel; green = + 1 blue = +2 alpha = +4
        
        canvasData[pixelIndex] = imageData[i];
        canvasData[pixelIndex+1] = imageData[i+1];
        canvasData[pixelIndex+2] = imageData[i+2];
        canvasData[pixelIndex+3] = 255;
        
      };    
  }
}