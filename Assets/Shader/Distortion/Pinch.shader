//跳動凸起
Shader "K/Distortion/Pinch" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		CenterPointX ("CenterPointX", Range(0,1)) = 0.5
		CenterPointY ("CenterPointY", Range(0,1)) = 0.5
		Radius ("Radius", Range(0,1)) = 0.3
		Strength ("Strength", Range(0,2)) = 1
		AspectRatio ("AspectRatio", Range(0.5,2)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed CenterPointX;
		fixed CenterPointY;
		fixed Radius;
		fixed Strength;
		fixed AspectRatio;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 Center = {CenterPointX, CenterPointY};
			float2 uv = IN.uv_MainTex;
			
			float2 dir = Center - uv;
			float2 scaledDir = dir;
			scaledDir.y /= AspectRatio;
			float dist = length(scaledDir);

			/*
			 1.            sin(Radius * 8)				波長調整變長(如 Radius 是 1，將有 2.5 個峰)

			 2.        abs(sin(Radius * 8) * Radius		重算比例限制在 0 ~ Radius

			 3.dist > (abs(sin(Radius * 8) * Radius 	value > 1	
			   dist < (abs(sin(Radius * 8) * Radius 	value < 1

			 4.saturate(1 - ...)						主要是限制最大值為 1，如果超標變為 0 不是 1
														value > 1	        range = 0
														value < 1		0 <	range < 1
			*/
			float range = saturate(1 - (dist / (abs(sin(Radius * 8) * Radius) + 0.00000001F)));

			float2 samplePoint = uv + dir * range * Strength;


			fixed4 c = tex2D(_MainTex, samplePoint);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
