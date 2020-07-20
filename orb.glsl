// An orb like structure based on Voronoi cells

//To be used in the shader editor "The Force"


//Helper functions

// Make a circle with given center (pos is given with respect to the center)

float circ(vec2 pos, vec2 cent){
    float r = 0.5;
    return  smoothstep(r - 0.1, r + 0.1, length(pos - cent)) ; 
}

// Rotate a vector 

vec2 rot(float theta, vec2 w){
    mat2 A = mat2(cos(theta), sin(theta), -sin(theta), cos(theta));
    return  w * A;
}


void main () {
    //Get center and normalized coordinates, respectively
    
    vec2 pos = uv();
    vec2 coord = uvN();
    
    float cir = circ(pos, vec2(0.0));
    
    
    // Scale, shift and rotate texture coordinates 
    
    coord -= vec2(0.5);
    coord += 0.1 * vec2(0.0, -0.2);
    coord *= vec2(0.5, 0.2);
    coord = rot(mod(time * 0.01, 1.0) * 2. * PI, coord);
    coord += vec2(0.5);
    
    //Backbuffer gives the previous frame
    
    vec4 prev = 1.0 - texture2D(backbuffer, coord);
    
    // voronoi gives a Voronoi tassellation 
    
    float c = voronoi(pos * 4.1  * sin(0.3 * time + pos.x * pos.x));
    
    float shape = min(1.0 - cir,  c) ;
    
    //Implement some additive blending
    
    shape += 2.4 * shape;
    
	  gl_FragColor = vec4(shape , shape * 0.6, shape  * 0.5 , 1.0 ) * 0.6 + 0.5 * prev;      
}
