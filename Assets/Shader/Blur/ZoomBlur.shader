//根據位置進行變焦模糊
Shader "K/Blur/ZoomBlur" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CenterX ("CenterX", Range(0,1)) = 0.5
		_CenterY ("CenterY", Range(0,1)) = 0.5
		_BlurAmount ("BlurAmount", Range(0,2)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		fixed _CenterX;
		fixed _CenterY;
		fixed _BlurAmount;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed2 center = fixed2(_CenterX, _CenterY);

			IN.uv_MainTex -= center;

			fixed4 c = 0;

			//每個像素座標到原點的距離
			float distanceFactor = sqrt (pow (abs (IN.uv_MainTex.x), 2) + pow (abs (IN.uv_MainTex.y), 2));

			for(int i = 0; i < 15; i++)
			{
				fixed scale = 1 - distanceFactor * _BlurAmount * (i/14.0);
				c += tex2D (_MainTex, IN.uv_MainTex * scale + center);
			}

			c /= 15;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
