//平滑凸面鏡
Shader "K/Distortion/MagnifySmooth" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		CenterPointX ("CenterPointX", Range(0,1)) = 0.5
		CenterPointY ("CenterPointY", Range(0,1)) = 0.5
		InnerRadius ("InnerRadius", Range(0,1)) = 0.2
		OuterRadius ("OuterRadius", Range(0,1)) = 0.4
		MagnificationAmount ("MagnificationAmount", Range(1,5)) = 2
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
		fixed InnerRadius;
		fixed OuterRadius;
		fixed MagnificationAmount;
		fixed AspectRatio;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 CenterPoint = {CenterPointX, CenterPointY};
			float2 uv = IN.uv_MainTex;
			
			//頂點原點改變
			float2 centerToPixel = uv - CenterPoint;

			//算差距
			float dist = length(centerToPixel / float2(1, AspectRatio));

			/*藉由dist來取平滑差值
			
			smoothstep (float a, float b, float x)
			1) Returns 0 if x < a < b or x > a > b
			2) Returns 1 if x < b < a or x > b > a
			3) Returns a value in the range [0,1] for the domain [a,b].

			dist		< InnerRadius	< OuterRadius	 ratio = 0
			InnerRadius < dist			< OuterRadius    ratio = 0 ~ 1
			dist		> OuterRadius	> InnerRadius	 ratio = 1
			
			*/
			float ratio = smoothstep(InnerRadius, max(InnerRadius, OuterRadius), dist);
			float2 samplePoint = lerp(centerToPixel / MagnificationAmount + CenterPoint, uv, ratio);
			fixed4 c = tex2D(_MainTex, samplePoint);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
