//浮雕
Shader "K/Distortion/Embossed" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		EmbossedAmount ("EmbossedAmount", Range(0,1)) = 0.5
		Width ("Width", Range(0,0.01)) = 0.003
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed EmbossedAmount;
		fixed Width;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float4 outC = {0.5, 0.5, 0.5, 1.0};

			outC -= tex2D(_MainTex, IN.uv_MainTex - Width) * EmbossedAmount;
			outC += tex2D(_MainTex, IN.uv_MainTex + Width) * EmbossedAmount;
			outC.rgb = (outC.r + outC.g + outC.b) / 3.0f;
			
			o.Albedo = outC.rgb;
			o.Alpha = outC.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
