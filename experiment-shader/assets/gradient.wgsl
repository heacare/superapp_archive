// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
//
// Transcribed from GLSL to WGSL by Chris Joel
fn mod289_3(x: vec3<f32>) -> vec3<f32> {
	return x - floor(x * (1. / 289.)) * 289.;
}

fn mod289_2(x: vec2<f32>) -> vec2<f32> {
	return x - floor(x * (1. / 289.)) * 289.;
}

fn permute(x: vec3<f32>) -> vec3<f32> {
	return mod289_3(((x * 34.) + 1.) * x);
}

fn snoise(v: vec2<f32>) -> f32 {
	// Precompute values for skewed triangular grid
	let C = vec4<f32>(
		.211324865405187,
		// (3.0-sqrt(3.0))/6.0
		.366025403784439,
		// 0.5*(sqrt(3.0)-1.0)
		-.577350269189626,
		// -1.0 + 2.0 * C.x
		0.024390243902439);

	// 1.0 / 41.0

	// First corner (x0)
	var i = floor(v + dot(v, C.yy));
	let x0 = v - i + dot(i, C.xx);

	// Other two corners (x1, x2)
	/*
	let i1 = select(
		vec2<f32>(0., 1.),
		vec2<f32>(1., 0.),
		x0.x > x0.y);
	*/
	var i1 = vec2<f32>(0., 1.);
	if (x0.x > x0.y) {
		i1 = vec2<f32>(1., 0.);
	}
	let x1 = x0.xy + C.xx - i1;
	let x2 = x0.xy + C.zz;

	// Do some permutations to avoid
	// truncation effects in permutation
	i = mod289_2(i);
	let p = permute(
		permute(i.y + vec3<f32>(0., i1.y, 1.)) + i.x + vec3<f32>(0., i1.x, 1.));
	var m = max(0.5 - vec3<f32>(
		dot(x0, x0),
		dot(x1, x1),
		dot(x2, x2)
	), vec3<f32>(0.));

	m = m * m;
	m = m * m;

	// Gradients:
	//  41 pts uniformly over a line, mapped onto a diamond
	//  The ring size 17*17 = 289 is close to a multiple
	//	  of 41 (41*7 = 287)

	let x = 2. * fract(p * C.www) - 1.;
	let h = abs(x) - .5;
	let ox = floor(x + .5);
	let a0 = x - ox;

	// Normalise gradients implicitly by scaling m
	// Approximation of: m *= inversesqrt(a0*a0 + h*h);
	m = m * (1.79284291400159 - .85373472095314 * (a0 * a0 + h * h));

	// Compute final noise value at P
	let g = vec3<f32>(
		a0.x * x0.x + h.x * x0.y,
		a0.yz * vec2<f32>(x1.x, x2.x) + h.yz * vec2<f32>(x1.y, x2.y)
	);

	return 130. * dot(m, g);
}
// End : WGSL 2D simplex noise function


@group(0) @binding(0)
var<uniform> t: f32;
@group(0) @binding(1)
var<uniform> s: f32;

let pi = 3.1415;


fn gradient(
	position: vec2<f32>,
	t: f32,
	s: f32,
) -> vec4<f32> {
	var coord = position / 1000. / s;
	var coord1 = coord;
	var coord2 = coord * 0.95;
	var coord3 = coord * 0.8;

	coord1.x += sin(t * pi * 2.);
	coord1.y += cos(t * pi * 2.);
	coord2.x += sin((t + 0.4) * pi * 2.);
	coord2.y += cos((t + 0.4) * pi * 2.);
	coord3.x += sin((t - 0.5) * pi * 2.);
	coord3.y += cos((t - 0.5) * pi * 2.);

	coord1.x *= 2.0 + sin(t * pi * 2.) * 0.2;
	coord1.y *= 0.9 + -cos(t * pi * 2.) * 0.5;
	coord2.x *= 2.0 + sin(t * pi * 2.) * 0.2;
	coord2.y *= 0.9 + -cos(t * pi * 2.) * 0.5;
	coord3.x *= 2.0;
	coord3.y *= 0.9;

	coord1 = coord1 + 1000.;
	coord2 = coord2 + 1000.;
	coord3 = coord3 + 1000.;

	let s = snoise(coord1) + snoise(coord2) + snoise(coord3);
	let t = s * 0.4 + 0.6;

	let a = vec3<f32>(1., 0., 1.);
	let b = vec3<f32>(1., 0.6, 0.);
	// TODO(serverwentdown): Replace lerp
	let o = a * (1. - t) + b * t;

	let o = o * 0.75 + 0.25;
	let b =	pow(snoise(coord1) / 2. + (1. - snoise(coord3) - 0.5) / 2., 4.) * 0.2;
	let o = clamp(
		o + b,
		vec3<f32>(0., 0., 0.),
		vec3<f32>(1., 1., 1.),
	);

	return vec4<f32>(o, 1.);
}

@fragment
fn fs_main(
	@builtin(position) position: vec4<f32>,
) -> @location(0) vec4<f32> {
	return gradient(position.xy, t, s);
}
