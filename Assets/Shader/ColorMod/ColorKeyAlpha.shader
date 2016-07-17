//排除顏色
Shader "K/ColorMod/ColorKeyAlpha" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		ColorTint("ColorTint",Color) = (1,1,1,1)
		Tolerance("Tolerance",Range(0,1)) = 0.3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 ColorTint;
		fixed Tolerance;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
   
			if (all(abs(c.rgb - ColorTint.rgb) < Tolerance)) {
				c.rgba = 0;
			}


			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}