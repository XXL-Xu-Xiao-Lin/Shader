//明暗度
Shader "K/ColorMod/BrightExtract 2" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		Threshold ("Threshold", Range(0,1)) = 0.5
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

			fixed4 c = 0;

			float4 originalColor = tex2D (_MainTex, IN.uv_MainTex);

			// Undo pre-multiplied alpha.
			float3 rgb = originalColor.rgb / originalColor.a;

			// Adjust RGB to keep only values brighter than the specified threshold.
			// rgb 在 Threshold 以上才有值 (調整範圍)
			rgb = saturate((rgb - Threshold) / (1 - Threshold));
			//rgb = saturate(rgb - Threshold);
    
			// Re-apply alpha.
			c = float4(rgb * originalColor.a, originalColor.a);

			o.Albedo = c.rgb;
			o.Alpha = c.a;

		}
		ENDCG
	} 
	FallBack "Diffuse"
}