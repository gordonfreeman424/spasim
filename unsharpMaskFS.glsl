varying vec2 v_Texcoords;

uniform sampler2D u_image;
uniform vec2 u_step;

const int KERNEL_WIDTH = 3; // Odd
const float offset = 1.0;
const mat3 gauss = mat3(vec3(1,2,1), vec3(2,4,2), vec3(1,2,1));

void main(void)
{
    vec3 accum = vec3(0.0);

	for (int i = 0; i < KERNEL_WIDTH; ++i)
	{
		for (int j = 0; j < KERNEL_WIDTH; ++j)
		{
			vec2 coord = vec2(v_Texcoords.s + ((float(i) - offset) * u_step.s), v_Texcoords.t + ((float(j) - offset) * u_step.t));
			accum += texture2D(u_image, coord).rgb * gauss[i][j];
		}
	}	

	vec4 originalColor = texture2D(u_image, v_Texcoords);

	// Unsharp Maskv
	vec3 difference = abs(vec3(originalColor.rgb) - accum/16.0) ;
	if (difference.x > 0.025 || difference.y > 0.025 || difference.z > 0.025)
		gl_FragColor = vec4((difference*5.1+originalColor.rgb)/2.0 , 1.0);
	else
		gl_FragColor = vec4(originalColor.rgb, 1.0);
}
