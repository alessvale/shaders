//An audio reactive shader developed in KodeLife
//https://hexler.net/products/kodelife
//Notice: texture0 is a custom texture uploaded to KodeLife

#version 150

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec3 spectrum;

uniform sampler2D texture0;
uniform sampler2D prevFrame; //Previous frame passed directly by KodeLife

in VertexData
{
    vec4 v_position;
    vec3 v_normal;
    vec2 v_texcoord;
} inData;

out vec4 fragColor;

// Feedback helper function

vec3 feedback(vec2 offs)
{
    vec2 uv = gl_FragCoord.xy / resolution;
    offs.x *= resolution.x / resolution.y;
    return texture(prevFrame, fract(uv + offs)).rgb;
}

//Rotate a 2d-vector

vec2 rot(vec2 w, float theta){
   mat2 A = mat2(cos(theta), sin(theta), -sin(theta), cos(theta));
   return A*w;
}

void main(void)
{
    // Get centered coordinates
    vec2 uv = -1. + 2. * inData.v_texcoord;
    uv.y *= resolution.y/resolution.x;
    
    // Rotate the position vector
    uv = rot(uv, 1.5 * time  );
    
    vec2 coord = inData.v_texcoord;
    
    //Use the custom texture as a displaying field;
    float disp = texture2D(texture0, coord).a;
    
    //Animate the radius
    float rad = 0.1 + 0.1 * abs(sin(time * 0.8));
    
    //We affect differently the various channels
    float d = (uv.x * uv.x + uv.y * uv.y) ;
    d += spectrum.x * uv.x * uv.y; //spectrum is native to KodeLife, and provides audio reaction
    float r = smoothstep(0.01, rad, d * (1.0 - spectrum.x));
    
    d = ((uv.x + 0.006 * cos(time)) * uv.x + uv.y * uv.y) ;
    float g = smoothstep(0.01, rad, d * (1.0 - spectrum.y) + 0.0002 * sin(time*disp));
    
    d = ((uv.x + 0.001 * sin(disp * time)) * uv.x + uv.y * (uv.y- 0.001 * sin(time * disp))) ;
    float b = smoothstep(0.01, rad, d * (1.0 - spectrum.z) + 0.001 * sin(time * 0.97));
    
    vec3 col = 1.0 - vec3(r, g, b);
    
    //Create the ring
    col = col * (1- 2.0 * col);
    
    vec3 feed = feedback(vec2(spectrum.x * uv.x, spectrum.y * uv.y));
    
    fragColor = vec4(col, 1.0) + 0.97 * vec4(feed, 1.0);
    }
