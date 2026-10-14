// Separable Gaussian blur with prefiltered downsampling.
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 u_step;
uniform vec2 u_texel;
uniform float u_mode;
uniform float u_alpha_mode;

vec4 sample_source(vec2 uv) {
    vec4 value = texture2D(gm_BaseTexture, clamp(uv, u_texel * 0.5, vec2(1.0) - u_texel * 0.5));
    if (u_alpha_mode > 0.5 && u_alpha_mode < 1.5) value.rgb *= value.a;
    return value;
}

void main() {
    vec4 result = vec4(0.0);
    if (u_mode < 0.5) {
        result = (sample_source(v_vTexcoord + u_step) + sample_source(v_vTexcoord - u_step)
            + sample_source(v_vTexcoord + vec2(u_step.x, -u_step.y))
            + sample_source(v_vTexcoord + vec2(-u_step.x, u_step.y))) * 0.25;
    } else if (u_mode < 1.5) {
        float total = 0.0;
        for (int i = -6; i <= 6; i++) {
            float distance = float(i);
            float weight = exp(-0.125 * distance * distance);
            result += sample_source(v_vTexcoord + u_step * distance) * weight;
            total += weight;
        }
        result /= total;
    } else {
        result = sample_source(v_vTexcoord);
    }
    if (u_alpha_mode > 1.5) result.rgb = result.a > 0.00001 ? result.rgb / result.a : vec3(0.0);
    gl_FragColor = result * v_vColour;
}
