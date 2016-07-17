//顏色混合(灰階)
Shader "K/ColorMod/Monochrome" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		FilterColor ("FilterColor", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 FilterColor;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {

			float4 c =  tex2D (_MainTex, IN.uv_MainTex);
		    float3 rgb = c.rgb;
		    float3 luminance = dot(rgb, float3(0.30, 0.59, 0.11));
		    c = float4(luminance * FilterColor.rgb, c.a);
			//c = c * FilterColor;

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
