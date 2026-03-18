shader_type canvas_item;

// ===== WIND SETTINGS =====
uniform float start_y: hint_range(0, 1) = .5;
uniform float strength: hint_range(0, 1) = .05;
uniform float curve_scale: hint_range(0, 3) = .2;
uniform float speed : hint_range(0, 10) = 1;
uniform float wind_start: hint_range(-1.57, 1.57) = 0;

// ===== OUTLINE SETTINGS =====
uniform vec4 outline_color    : source_color = vec4(.06, .74, .23, 1.0);
uniform float outline_size    : hint_range(0.0, 16.0, 0.1) = 1.0;
uniform float alpha_threshold : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform int outline_samples   : hint_range(4, 8) = 4;
uniform vec4 shade_color      : source_color = vec4(1.0, 1.0, 1.0, 0.5); 

// ===== INTERNAL =====
varying vec4 v_color;

const vec2[8] DIRS = vec2[8](
    vec2(1.0, 0.0), vec2(0.0, 1.0),  vec2(-1.0, 0.0),  vec2(0.0, -1.0),
    vec2(1.0, 1.0), vec2(-1.0, 1.0), vec2(-1.0, -1.0), vec2(1.0, -1.0)
);

// ===== VERTEX =====
void vertex() {
    v_color = COLOR;
    float scale = (pow(2.0, curve_scale) * strength * 2.0);
    VERTEX *= 1.0 + scale;
}

// ===== FRAGMENT =====
void fragment() {
    float scale = (pow(2.0, curve_scale) * strength * 2.0);
    float total_scale = 1.0 + scale;

    // Convert to local UV space
    vec2 local_uv = (UV - REGION_RECT.xy) / REGION_RECT.zw;
    vec2 adjusted_local_uv = (local_uv - 0.5) * total_scale + 0.5;

    // ===== WIND DISTORTION =====
    vec2 wind_uv = adjusted_local_uv;

    float wind_strength = sin(TIME * speed + wind_start)
        * smoothstep(start_y , 1. + start_y , pow((1. - wind_uv.y), 0.5))
        * pow((1. - wind_uv.y + 1.), curve_scale)
        * strength;

    wind_uv.x += wind_strength;

    // Discard if outside texture
    if (wind_uv.x < 0.0 || wind_uv.x > 1.0 || wind_uv.y < 0.0 || wind_uv.y > 1.0) {
        discard;
    }

    // Convert back to texture space
    vec2 final_uv = wind_uv * REGION_RECT.zw + REGION_RECT.xy;

    // ===== SAMPLE TEXTURE =====
    vec4 tex = texture(TEXTURE, final_uv) * v_color;
    float alpha = tex.a;

    if (alpha <= 0.0 && outline_size <= 0.0) discard;

    bool solid = alpha > alpha_threshold;
    bool semi  = (alpha > 0.0) && !solid;

    vec4 out_color = tex;

    // Shade solid pixels
    if (solid && shade_color.a > 0.0) {
        out_color.rgb = mix(tex.rgb, shade_color.rgb, shade_color.a);
        out_color.a   = alpha;
    }

    bool found = false;

    // ===== OUTLINE (IMPORTANT: USE DISTORTED UV) =====
    if (!solid && outline_size > 0.0) {
        vec2 offset = TEXTURE_PIXEL_SIZE * outline_size;

        for (int i = 0; i < outline_samples; i++) {
            vec2 sample_uv = final_uv + DIRS[i] * offset;

            if (texture(TEXTURE, sample_uv).a > alpha_threshold) {
                found = true;
                break;
            }
        }
    }

    // ===== FINAL COLOR =====
    if      (solid) COLOR = out_color;
    else if (found) COLOR = outline_color;
    else if (semi)  COLOR = tex;
    else            discard;
}