uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uColorOffset;
uniform float uColorMultiplier;

uniform float opacity;

uniform float lightIntensity;
varying vec3 vecPos;
varying vec3 vecNormal;

varying float vElevation;
#include <fog_pars_fragment>

struct PointLight {
  vec3 color;
  vec3 position; // light position, in camera coordinates
  float distance; // used for attenuation purposes. Since
                  // we're writing our own shader, it can
                  // really be anything we want (as long as
                  // we assign it to our light in its
                  // "distance" field
};
 
uniform PointLight pointLights[NUM_POINT_LIGHTS];

void main(){
  // Pretty basic lambertian lighting...
  vec4 addedLights = vec4(0.0,
                          0.0,
                          0.0,
                          1.0);
  for(int l = 0; l < NUM_POINT_LIGHTS; l++) {
      vec3 lightDirection = normalize(vecPos
                            - pointLights[l].position);
      addedLights.rgb += clamp(dot(-lightDirection,
                               vecNormal), 0.0, 1.0)
                         * pointLights[l].color
                         * lightIntensity;
  }

  float mixStrength = (vElevation + uColorOffset) * uColorMultiplier;
  vec3 color = mix(uDepthColor, uSurfaceColor, mixStrength);

  gl_FragColor = vec4(color, opacity) * addedLights;
  #include <fog_fragment>
}