Shader {
  id: shader1

  // https://github.com/mrdoob/three.js/blob/master/examples/webgl_buffergeometry_custom_attributes_particles.html#L25
  // https://github.com/mrdoob/three.js/blob/dev/src/renderers/shaders/ShaderLib/points_vert.glsl.js
  
  vertexOver: true
  vertex: "
     attribute float radiuses;
     void main()
     {
       if (radiuses > 0.0)
         gl_PointSize = radiuses*size;
     }
  "
  
  property var output: shader1

}
