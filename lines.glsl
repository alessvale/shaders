// A very simple music visualizers developed in KodeLife

#version 150

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec3 spec;


in VertexData
{
    vec4 v_position;
    vec3 v_normal;
    vec2 v_texcoord;
} inData;

out vec4 fragColor;

void main(void){   
    
    //Get coordinates with respect to the center of the screen
    
    vec2 uv = 2.0 * ( gl_FragCoord.xy / resolution.xy) - vec2(1.0, 1.0);
    float col = 0.0;
    
    for (int i = 0; i < 2; i++){
           uv.x += sin(time * 10.0 + uv.y * 100.0 * i * spec.y)*0.03  ;
           col += abs(0.5/(uv.x)) * spec.x ;
    }
    
   // col = (1.0 - col)*step(0.01, spec.x * 4.0); //Useful in livecoding situations to quickly invert the colors
   
    fragColor = vec4(col, col   , col, 1.0);
}
