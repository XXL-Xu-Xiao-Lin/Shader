//水波漣漪
Shader "K/Distortion/Ripple" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		CenterPointX ("CenterPointX", Range(0,1)) = 0.5
		CenterPointY ("CenterPointY", Range(0,1)) = 0.5
		Amplitude ("Amplitude", Range(0,1)) = 0.1
		Frequency ("Frequency", Range(0,100)) = 70
		Phase ("Phase", Range(-20,20)) = 0
		AspectRatio ("AspectRatio", Range(0.5,2)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed CenterPointX;
		fixed CenterPointY;
		fixed Amplitude;
		fixed Frequency;
		fixed Phase;
		fixed AspectRatio;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 Center = {CenterPointX, CenterPointY};
			float2 uv = IN.uv_MainTex;

			float2 dir = uv - Center; // vector from center to pixel
			dir.y /= AspectRatio;
			float dist = length(dir);
			dir /= dist;
			dir.y *= AspectRatio;

			float2 wave;
			sincos(Frequency * dist + Phase, wave.x, wave.y);
		
			float falloff = saturate(1 - dist);
			falloff *= falloff;
		
			dist += Amplitude * wave.x * falloff;
			float2 samplePoint = Center + dist * dir;
			float4 color = tex2D(_MainTex, samplePoint);

			float lighting = 1 - Amplitude * 0.2 * (1 - saturate(wave.y * falloff));
			color.rgb *= lighting;

			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
