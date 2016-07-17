//放大鏡
Shader "K/Distortion/Magnify" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		CenterPointX ("CenterPointX", Range(0,1)) = 0.5
		CenterPointY ("CenterPointY", Range(0,1)) = 0.5
		Radius ("Radius", Range(0,1)) = 0.25
		MagnificationAmount ("MagnificationAmount", Range(1,5)) = 2
		AspectRatio ("AspectRatio", Range(0,2)) = 1
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
		fixed MagnificationAmount;
		fixed AspectRatio;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 uv = IN.uv_MainTex;
			float2 CenterPoint = {CenterPointX, CenterPointY};

			//頂點的原點改變，算差距
			float2 centerToPixel = uv - CenterPoint;

			//各點與原點距離
			float dist = length(centerToPixel / float2(1, AspectRatio));

			//距離小於Radius，進行頂點距離縮小(貼圖顯示放大)，並將位置加回0~1
			float2 samplePoint = uv;
			if (dist < Radius) {
				samplePoint = centerToPixel / MagnificationAmount + CenterPoint;
			}

			fixed4 c = tex2D (_MainTex, samplePoint);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
