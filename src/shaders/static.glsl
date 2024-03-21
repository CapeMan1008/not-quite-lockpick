uniform float time;

vec4 effect(vec4 color, sampler2D tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 oldcolor = Texel(tex, texture_coords) * color;
    return oldcolor;
}

//TODO: EVERYTHING