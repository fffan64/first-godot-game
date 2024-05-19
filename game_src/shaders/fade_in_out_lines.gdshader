shader_type canvas_item;
//
//uniform vec4 in_color:source_color;
//uniform vec4 out_color:source_color;
//
//uniform float in_out:hint_range(0.,1.)=0.;
//
//uniform float position:hint_range(-1.5,1.) = 0.856;
//uniform vec2 size = vec2(16., 16.);



uniform float num_lines = 20.;
uniform float y_threshold: hint_range(0.0, 1.0) = 0.5;
uniform vec4 line_color_a: source_color = vec4(1.);
uniform vec4 line_color_b: source_color = vec4(0., 0., 0., 1.0);

void fragment() {
	vec2 tiled_uv = vec2(fract(UV.x * num_lines / 2.), UV.y);
	if (tiled_uv.x < 0.5){
		if(tiled_uv.y < y_threshold){
			COLOR = line_color_a;
		} else {
			COLOR = vec4(0.0);
		}
	} else {
		if (tiled_uv.y > 1. - y_threshold){
			COLOR = line_color_b;
		} else {
			COLOR = vec4(0.0);
		}
	}
}