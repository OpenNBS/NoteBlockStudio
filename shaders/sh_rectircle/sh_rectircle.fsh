varying vec2 v_vPosition;
varying vec4 v_vColour;
uniform vec4 u_rect;
uniform vec2 u_shape; // corner radius, outline width

// Match the glass mask's fourth-power corner curve.
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

void main() {
    vec2 p = v_vPosition - u_rect.xy - u_rect.zw * 0.5;
    float distance = rectircle_distance(p, u_rect.zw * 0.5, u_shape.x);
    float coverage = 1.0 - smoothstep(-0.5, 0.5, distance);
    if (u_shape.y > 0.0) coverage -= 1.0 - smoothstep(-0.5, 0.5, distance + u_shape.y);
    if (coverage <= 0.0) discard;
    gl_FragColor = vec4(v_vColour.rgb, v_vColour.a * coverage);
}
