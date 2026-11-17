// Continuous-corner glass: refraction, tint, highlights, and shadow.
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D u_blurred;
uniform vec2 u_size;
uniform vec2 u_texel;
uniform vec4 u_rect;
uniform vec4 u_shape;       // corner radius, edge softness, blur opacity, material alpha
uniform vec2 u_edge_refraction; // amount, width in render pixels
uniform vec4 u_refraction;  // inner amount/height, outer amount/height
uniform vec4 u_tint;
uniform vec4 u_color;       // saturation, brightness, adaptive tint, unused
uniform vec4 u_highlight;
uniform vec4 u_light;       // light direction xy, highlight width, angular spread
uniform vec4 u_shadow;
uniform vec4 u_shadow_shape; // offset xy, softness, rim opacity
uniform vec4 u_aberration;  // amount, height, rotation cos/sin
uniform float u_rim_width;

float rectircle_distance(vec2 p, vec2 half_size, float radius) {
    vec2 q = abs(p) - half_size + radius;
    vec2 corner = max(q, vec2(0.0));
    float extent = max(corner.x, corner.y);
    if (extent < 0.00001) return max(q.x, q.y) - radius;
    vec2 unit = corner / extent;
    vec2 squared = unit * unit;
    float norm = sqrt(sqrt(dot(squared, squared)));
    float gradient = length(squared * unit) / (norm * norm * norm);
    return (extent * norm - radius) / gradient;
}

vec2 rectircle_normal(vec2 p, vec2 half_size, float radius) {
    vec2 q = abs(p) - half_size + radius;
    vec2 corner = max(q, vec2(0.0));
    float extent = max(corner.x, corner.y);
    if (extent > 0.00001) {
        vec2 unit = corner / extent;
        return normalize(unit * unit * unit) * sign(p);
    }
    return q.x > q.y ? vec2(sign(p.x), 0.0) : vec2(0.0, sign(p.y));
}

vec2 bounded_uv(vec2 uv) {
    return clamp(uv, u_texel * 0.5, vec2(1.0) - u_texel * 0.5);
}

vec3 backdrop(vec2 uv, float amount) {
    vec2 coord = bounded_uv(uv);
    return mix(texture2D(gm_BaseTexture, coord).rgb, texture2D(u_blurred, coord).rgb, amount);
}

void main() {
    vec2 p = v_vTexcoord * u_size - u_rect.xy - u_rect.zw * 0.5;
    vec2 half_size = u_rect.zw * 0.5;
    float radius = min(u_shape.x, min(half_size.x, half_size.y));
    float distance = rectircle_distance(p, half_size, radius);
    float coverage = 1.0 - smoothstep(-u_shape.y * 0.5, u_shape.y * 0.5, distance);
    float depth = max(-distance, 0.0);
    vec2 normal = rectircle_normal(p, half_size, radius);

    float inner = 1.0 - smoothstep(0.0, u_refraction.y, depth);
    float outer = 1.0 - smoothstep(0.0, u_refraction.w, depth);
    float displacement = u_refraction.x * inner * inner + u_refraction.z * outer * outer;
    // The steep lip refracts a thin band of the backdrop at the very edge.
    float pixel_size = max(length(normal * u_size * u_texel), 0.00001);
    if (u_edge_refraction.y > 0.0) {
        float lip = 1.0 - smoothstep(0.0, u_edge_refraction.y * pixel_size, depth);
        displacement += u_edge_refraction.x * lip;
    }
    vec2 uv = v_vTexcoord - normal * displacement / u_size;
    vec2 dispersion_dir = vec2(normal.x * u_aberration.z - normal.y * u_aberration.w,
                               normal.x * u_aberration.w + normal.y * u_aberration.z);
    vec2 dispersion = dispersion_dir * u_aberration.x * exp(-depth / u_aberration.y) / u_size;
    float blur_amount = u_shape.z;
    vec3 glass = backdrop(uv, blur_amount);
    if (abs(u_aberration.x) > 0.0001) {
        glass.r = backdrop(uv + dispersion, blur_amount).r;
        glass.b = backdrop(uv - dispersion, blur_amount).b;
    }

    float luma = dot(glass, vec3(0.2126, 0.7152, 0.0722));
    glass = mix(vec3(luma), glass, u_color.x) + u_color.y;
    float tint_luma = dot(u_tint.rgb, vec3(0.2126, 0.7152, 0.0722));
    float tint_amount = clamp(u_tint.a + u_color.z * abs(luma - tint_luma), 0.0, 1.0);
    glass = mix(glass, u_tint.rgb, tint_amount);

    float direction = pow(max(dot(normal, u_light.xy), 0.0), mix(16.0, 1.0, u_light.w));
    float rim = exp(-depth / u_rim_width) * u_shadow_shape.w;
    glass *= 1.0 - rim;
    float highlight = exp(-depth * depth / (u_light.z * u_light.z)) * (0.16 + 0.84 * direction);
    glass += u_highlight.rgb * u_highlight.a * highlight;

    float shadow_distance = rectircle_distance(p - u_shadow_shape.xy, half_size, radius);
    float shadow_edge = max(shadow_distance, 0.0) / u_shadow_shape.z;
    float shadow_alpha = u_shadow.a * exp(-2.0 * shadow_edge * shadow_edge) * (1.0 - coverage);
    float opacity = u_shape.w * v_vColour.a;
    float glass_alpha = coverage * opacity;
    shadow_alpha *= opacity;
    float alpha = glass_alpha + shadow_alpha * (1.0 - glass_alpha);
    vec3 premultiplied = clamp(glass, 0.0, 1.0) * glass_alpha + u_shadow.rgb * shadow_alpha * (1.0 - glass_alpha);
    gl_FragColor = vec4(alpha > 0.00001 ? premultiplied / alpha : vec3(0.0), alpha);
}
