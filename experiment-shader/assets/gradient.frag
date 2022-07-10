#version 310 es

precision highp float;
precision highp int;

layout(location = 0) uniform float _group_0_binding_0_fs;

layout(location = 0) out vec4 _fs2p_location0;

vec3 mod289_3_(vec3 x) {
    return (x - (floor((x * (1.0 / 289.0))) * 289.0));
}

vec2 mod289_2_(vec2 x_1) {
    return (x_1 - (floor((x_1 * (1.0 / 289.0))) * 289.0));
}

vec3 permute(vec3 x_2) {
    vec3 _e7 = mod289_3_((((x_2 * 34.0) + vec3(1.0)) * x_2));
    return _e7;
}

float snoise(vec2 v) {
    vec2 i = vec2(0.0);
    vec2 i1_ = vec2(0.0);
    vec3 m = vec3(0.0);
    vec4 C = vec4(0.21132487058639526, 0.3660254180431366, -0.5773502588272095, 0.024390242993831635);
    i = floor((v + vec2(dot(v, C.yy))));
    vec2 _e12 = i;
    vec2 _e14 = i;
    vec2 x0_ = ((v - _e12) + vec2(dot(_e14, C.xx)));
    i1_ = vec2(0.0, 1.0);
    if ((x0_.x > x0_.y)) {
        i1_ = vec2(1.0, 0.0);
    }
    vec2 _e32 = i1_;
    vec2 x1_ = ((x0_.xy + C.xx) - _e32);
    vec2 x2_ = (x0_.xy + C.zz);
    vec2 _e37 = i;
    vec2 _e38 = mod289_2_(_e37);
    i = _e38;
    float _e40 = i.y;
    float _e43 = i1_.y;
    vec3 _e48 = permute((vec3(_e40) + vec3(0.0, _e43, 1.0)));
    float _e50 = i.x;
    float _e55 = i1_.x;
    vec3 _e59 = permute(((_e48 + vec3(_e50)) + vec3(0.0, _e55, 1.0)));
    m = max((vec3(0.5) - vec3(dot(x0_, x0_), dot(x1_, x1_), dot(x2_, x2_))), vec3(0.0));
    vec3 _e71 = m;
    vec3 _e72 = m;
    m = (_e71 * _e72);
    vec3 _e74 = m;
    vec3 _e75 = m;
    m = (_e74 * _e75);
    vec3 x_3 = ((2.0 * fract((_e59 * C.www))) - vec3(1.0));
    vec3 h = (abs(x_3) - vec3(0.5));
    vec3 ox = floor((x_3 + vec3(0.5)));
    vec3 a0_ = (x_3 - ox);
    vec3 _e94 = m;
    m = (_e94 * (vec3(1.7928428649902344) - (0.8537347316741943 * ((a0_ * a0_) + (h * h)))));
    vec3 g = vec3(((a0_.x * x0_.x) + (h.x * x0_.y)), ((a0_.yz * vec2(x1_.x, x2_.x)) + (h.yz * vec2(x1_.y, x2_.y))));
    vec3 _e124 = m;
    return (130.0 * dot(_e124, g));
}

void main() {
    vec4 position = gl_FragCoord;
    vec2 coord1_ = vec2(0.0);
    vec2 coord2_ = vec2(0.0);
    vec2 coord3_ = vec2(0.0);
    coord1_ = (position.xy / vec2(500.0));
    coord2_ = (position.xy / vec2(450.0));
    coord3_ = (position.xy / vec2(400.0));
    float _e19 = coord1_.x;
    float _e20 = _group_0_binding_0_fs;
    coord1_.x = (_e19 + sin(((_e20 * 3.1414999961853027) * 2.0)));
    float _e27 = coord1_.y;
    float _e28 = _group_0_binding_0_fs;
    coord1_.y = (_e27 + cos(((_e28 * 3.1414999961853027) * 2.0)));
    float _e35 = coord2_.x;
    float _e36 = _group_0_binding_0_fs;
    coord2_.x = (_e35 + sin((((_e36 + 0.4000000059604645) * 3.1414999961853027) * 2.0)));
    float _e45 = coord2_.y;
    float _e46 = _group_0_binding_0_fs;
    coord2_.y = (_e45 + cos((((_e46 + 0.4000000059604645) * 3.1414999961853027) * 2.0)));
    float _e55 = coord3_.x;
    float _e56 = _group_0_binding_0_fs;
    coord3_.x = (_e55 + sin((((_e56 - 0.5) * 3.1414999961853027) * 2.0)));
    float _e65 = coord3_.y;
    float _e66 = _group_0_binding_0_fs;
    coord3_.y = (_e65 + cos((((_e66 - 0.5) * 3.1414999961853027) * 2.0)));
    float _e75 = coord1_.x;
    float _e77 = _group_0_binding_0_fs;
    coord1_.x = (_e75 * (1.5 + (sin(((_e77 * 3.1414999961853027) * 2.0)) * 0.20000000298023224)));
    float _e87 = coord1_.y;
    float _e89 = _group_0_binding_0_fs;
    coord1_.y = (_e87 * (0.8999999761581421 + ((-cos(((_e89 * 3.1414999961853027) * 2.0))) * 0.5)));
    float _e100 = coord2_.x;
    float _e102 = _group_0_binding_0_fs;
    coord2_.x = (_e100 * (1.5 + (sin(((_e102 * 3.1414999961853027) * 2.0)) * 0.20000000298023224)));
    float _e112 = coord2_.y;
    float _e114 = _group_0_binding_0_fs;
    coord2_.y = (_e112 * (0.8999999761581421 + ((-cos(((_e114 * 3.1414999961853027) * 2.0))) * 0.5)));
    float _e125 = coord3_.x;
    coord3_.x = (_e125 * 1.5);
    float _e129 = coord3_.y;
    coord3_.y = (_e129 * 0.8999999761581421);
    vec2 _e132 = coord1_;
    float _e133 = snoise(_e132);
    vec2 _e134 = coord2_;
    float _e135 = snoise(_e134);
    vec2 _e137 = coord3_;
    float _e138 = snoise(_e137);
    float s = ((_e133 + _e135) + _e138);
    float t_1 = ((s * 0.4000000059604645) + 0.6000000238418579);
    vec3 a = vec3(1.0, 0.0, 1.0);
    vec3 b = vec3(1.0, 0.6000000238418579, 0.0);
    vec3 o = ((a * (1.0 - t_1)) + (b * t_1));
    vec3 o_1 = ((o * 0.75) + vec3(0.25));
    vec2 _e162 = coord1_;
    float _e163 = snoise(_e162);
    vec2 _e167 = coord3_;
    float _e168 = snoise(_e167);
    float b_1 = (pow(((_e163 / 2.0) + (((1.0 - _e168) - 0.5) / 2.0)), 4.0) * 0.20000000298023224);
    vec3 o_2 = clamp((o_1 + vec3(b_1)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    _fs2p_location0 = vec4(o_2, 1.0);
    return;
}

