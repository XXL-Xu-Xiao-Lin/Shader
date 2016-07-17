Shader "K/!Standard" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		
		_PosX("PosX", Range(-1,1)) = 0
		_PosY("PosY", Range(-1,1)) = 0
		_ScaleX("ScaleX", Range(0,2)) = 1
		_ScaleY("ScaleY", Range(0,2)) = 1

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		float _PosX;
		float _PosY;
		float _ScaleX;
		float _ScaleY;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			float2 uv = IN.uv_MainTex;
			uv.x = (uv.x + _PosX) * _ScaleX;
			uv.y = (uv.y + _PosY) * _ScaleY;

			fixed4 c = tex2D (_MainTex, uv);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
