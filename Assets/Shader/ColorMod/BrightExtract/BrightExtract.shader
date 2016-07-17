//明暗度
Shader "K/ColorMod/BrightExtract" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		Threshold ("BaseSaturation", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed Threshold;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {

			float4 originalColor = tex2D (_MainTex, IN.uv_MainTex);
    
			// Undo pre-multiplied alpha.
			// 還原顏色排除Alpha
			float3 c = originalColor.rgb / originalColor.a;

		
			o.Albedo = c.rgb;
			o.Alpha = originalColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}