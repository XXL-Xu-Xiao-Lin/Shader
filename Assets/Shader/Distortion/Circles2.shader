//同心圓2
Shader "K/Distortion/Circles2" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		CenterX ("CenterX", Range(0,1)) = 0.5
		CenterY ("CenterY", Range(0,1)) = 0.5
		Size ("Size", Range(0,4)) = 0.9		
		Bands ("Bands", Range(0,20)) = 10
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed CenterX;
		fixed CenterY;
		fixed Size;
		fixed Bands;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 Center = {CenterX, CenterY};

			float2 dir = IN.uv_MainTex - Center;
			float dist = length(dir) * Size;

			float remainder = frac(dist * Bands);
			float fac;   
			if (remainder < 0.25)
			{
				fac = 1.0;
			}
			else if (remainder < 0.5)
			{
				// transition zone - go smoothly from previous zone to next.
				fac = 1 - 8 * (remainder - 0.25);
			}
			else if (remainder < 0.75)
			{
				fac = -1.0;
			}
			else
			{
				// transition zone - go smoothly from previous zone to next.
				fac = -(1 - 8 * (remainder - 0.75));
			}

			
			fixed4 c = tex2D (_MainTex, dist + fac + Center);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
