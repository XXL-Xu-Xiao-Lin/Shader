Shader "K/Blur/TelescopicBlurPS3-1" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CenterX("CenterX", Range(0,1)) = 0.5
		_CenterY("CenterY", Range(0,1)) = 0.5
		_Scale("ZoomBlurAmount", Range(0,2)) = 1
	} 

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		float _CenterX;
		float _CenterY;
		float _Scale;

		struct Input {
			float2 uv_MainTex;
		};

		
		void surf (Input IN, inout SurfaceOutputStandard o) {

			float4 c = 0;
			float2 uv = IN.uv_MainTex;

			uv.x -= _CenterX;//0~1 d:0.5
			uv.y -= _CenterY;//0~1 d:0.5


			//_EdgeSize 0.5~4  d:2
			//float distanceFactor = pow (pow (abs (uv.x), _EdgeSize) + pow (abs (uv.y), 2), 2);

			//_ZoomBlurAmount 0~3  d:2.5
			//float scale = 1.0 - /*distanceFactor **/ _ZoomBlurAmount;
			float2 coord = uv * _Scale;
			
			coord.x += _CenterX;
			coord.y += _CenterY;
			c = tex2D(_MainTex,coord);			

			o.Albedo = c.rgb;		
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
