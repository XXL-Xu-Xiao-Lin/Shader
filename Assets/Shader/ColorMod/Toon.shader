//卡通效果
Shader "K/ColorMod/Toon" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		Levels ("Levels", Range(3,15)) = 5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		float Levels; 

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float4 color = tex2D (_MainTex, IN.uv_MainTex);
			color.rgb /= color.a;

			/*
			levels = 3
			1		3		3		1	
			0.9		2.7		2		0.666	
			0.8		2.4		2		0.666	
			0.7		2.1		2		0.666	
			0.6		1.8		1		0.333	
			0.5		1.5		1		0.333	
			0.4		1.2		1		0.333	
			0.3		0.9		0		0	
			0.2		0.6		0		0	
			0.1		0.3		0		0	
			0.0		0		0		0

			levels = 15
			1		15		15		1	
			0.9		13.5	13		0.866	
			0.8		12.0	12		0.800	
			0.7		10.5	10		0.666	
			0.6		9.0		9		0.600	
			0.5		7.5		7		0.466	
			0.4		6.0		6		0.400	
			0.3		4.5		4		0.266	
			0.2		3.0		3		0.200	
			0.1		1.5		1		0.066	
			0.0		0		0		0
			*/
			int levels = floor(Levels);
			color.rgb *= levels;
			color.rgb = floor(color.rgb);
			color.rgb /= levels;


			color.rgb *= color.a;
			
			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
