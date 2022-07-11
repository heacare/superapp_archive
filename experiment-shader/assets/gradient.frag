#version 310 es

precision highp float;
precision highp int;

layout(location = 0) uniform float _group_0_binding_0_fs;

layout(location = 1) uniform float _group_0_binding_1_fs;

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

vec4 gradient(vec2 position_1, float t, float s) {
    vec2 coord = vec2(0.0);
    vec2 coord1_ = vec2(0.0);
    vec2 coord2_ = vec2(0.0);
    vec2 coord3_ = vec2(0.0);
    coord = ((position_1 / vec2(600.0)) / vec2(s));
    vec2 _e12 = coord;
    coord1_ = _e12;
    vec2 _e14 = coord;
    coord2_ = (_e14 * 0.949999988079071);
    vec2 _e18 = coord;
    coord3_ = (_e18 * 0.800000011920929);
    float _e23 = coord1_.x;
    coord1_.x = (_e23 + sin(((t * 3.1414999961853027) * 2.0)));
    float _e30 = coord1_.y;
    coord1_.y = (_e30 + cos(((t * 3.1414999961853027) * 2.0)));
    float _e37 = coord2_.x;
    coord2_.x = (_e37 + sin((((t + 0.4000000059604645) * 3.1414999961853027) * 2.0)));
    float _e46 = coord2_.y;
    coord2_.y = (_e46 + cos((((t + 0.4000000059604645) * 3.1414999961853027) * 2.0)));
    float _e55 = coord3_.x;
    coord3_.x = (_e55 + sin((((t - 0.5) * 3.1414999961853027) * 2.0)));
    float _e64 = coord3_.y;
    coord3_.y = (_e64 + cos((((t - 0.5) * 3.1414999961853027) * 2.0)));
    float _e73 = coord1_.x;
    coord1_.x = (_e73 * (2.0 + (sin(((t * 3.1414999961853027) * 2.0)) * 0.20000000298023224)));
    float _e84 = coord1_.y;
    coord1_.y = (_e84 * (0.8999999761581421 + ((-cos(((t * 3.1414999961853027) * 2.0))) * 0.5)));
    float _e96 = coord2_.x;
    coord2_.x = (_e96 * (2.0 + (sin(((t * 3.1414999961853027) * 2.0)) * 0.20000000298023224)));
    float _e107 = coord2_.y;
    coord2_.y = (_e107 * (0.8999999761581421 + ((-cos(((t * 3.1414999961853027) * 2.0))) * 0.5)));
    float _e119 = coord3_.x;
    coord3_.x = (_e119 * 2.0);
    float _e123 = coord3_.y;
    coord3_.y = (_e123 * 0.8999999761581421);
    vec2 _e126 = coord1_;
    coord1_ = (_e126 + vec2(1000.0));
    vec2 _e130 = coord2_;
    coord2_ = (_e130 + vec2(1000.0));
    vec2 _e134 = coord3_;
    coord3_ = (_e134 + vec2(1000.0));
    vec2 _e138 = coord1_;
    float _e139 = snoise(_e138);
    vec2 _e140 = coord2_;
    float _e141 = snoise(_e140);
    vec2 _e143 = coord3_;
    float _e144 = snoise(_e143);
    float s_2 = ((_e139 + _e141) + _e144);
    float t_2 = ((s_2 * 0.4000000059604645) + 0.6000000238418579);
    vec3 a = vec3(1.0, 0.0, 1.0);
    vec3 b = vec3(1.0, 0.6000000238418579, 0.0);
    vec3 o = ((a * (1.0 - t_2)) + (b * t_2));
    vec3 o_1 = ((o * 0.75) + vec3(0.25));
    vec2 _e168 = coord1_;
    float _e169 = snoise(_e168);
    vec2 _e173 = coord3_;
    float _e174 = snoise(_e173);
    float b_1 = (pow(((_e169 / 2.0) + (((1.0 - _e174) - 0.5) / 2.0)), 4.0) * 0.20000000298023224);
    vec3 o_2 = clamp((o_1 + vec3(b_1)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    return vec4(o_2, 1.0);
}

void main() {
    vec4 position = gl_FragCoord;
    float _e5 = _group_0_binding_0_fs;
    float _e6 = _group_0_binding_1_fs;
    vec4 _e7 = gradient(position.xy, _e5, _e6);
    _fs2p_location0 = _e7;
    return;
}

