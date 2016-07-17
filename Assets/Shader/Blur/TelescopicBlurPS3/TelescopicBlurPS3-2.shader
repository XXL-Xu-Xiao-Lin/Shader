Shader "K/Blur/TelescopicBlurPS3-2" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CenterX("CenterX", Range(0,1)) = 0.5
		_CenterY("CenterY", Range(0,1)) = 0.5
		_ZoomBlurAmount("ZoomBlurAmount", Range(0,3)) = 2.5
		_EdgeSize("EdgeSize", Range(0.5,4)) = 2
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
		float _ZoomBlurAmount;
		float _EdgeSize;

		struct Input {
			float2 uv_MainTex;
		};

		
		void surf (Input IN, inout SurfaceOutputStandard o) {

			float4 c = 0;
			float2 uv = IN.uv_MainTex;

			//頂點的原點改變，算差距
			uv.x -= _CenterX;
			uv.y -= _CenterY;

						
			//每個像素座標到原點的距離
			float distanceFactor = sqrt (pow (abs (uv.x), _EdgeSize) + pow (abs (uv.y), 2));

			for(int i=0; i < 14; i++)
			{
				float scale = 1.0 - distanceFactor *_ZoomBlurAmount * (i / 30.0);
				float2 coord = uv * scale;
				
				//將值加回0~1
				coord.x += _CenterX;
				coord.y += _CenterY;
				c += tex2D(_MainTex,coord);
			}
			c /= 14;
			

			o.Albedo = c.rgb;		
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
