//環狀波紋
Shader "K/Distortion/BandedSwirl" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		CenterX ("CenterX", Range(0,1)) = 0.5
		CenterY ("CenterY", Range(0,1)) = 0.5
		Bands ("Bands", Range(0,20)) = 10
		Strength ("Strength", Range(0,1)) = 0.5
		AspectRatio ("AspectRatio", Range(0.5,2)) = 1.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed CenterX;
		fixed CenterY;
		fixed Bands;
		fixed Strength;
		fixed AspectRatio;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 Center = {CenterX, CenterY};

			float2 dir = IN.uv_MainTex - Center;
			dir.y /= AspectRatio;
			float dist = length(dir);
			float angle = atan2(dir.y, dir.x);
			

			/*
			波形連續(形成平滑)

			remainder	fac
			0.00~0.25	1
			0.25~0.50	1 ~ -1
			0.50~0.75	-1
			0.75~1		-1 ~ 1

			fac(y)
			1   |---         |---
			    |   \       /|
			    |------------|-----
			    |    \     / |
			-1  |     \---/  |
						       remainder(x)
			*/
			float remainder = frac(dist * Bands);
			float fac;   
			if (remainder < 0.25)
			{
				fac = 1.0;
			}
			else if (remainder < 0.5) 
			{
				// 1 ~ -1
				fac = 1 - 8 * (remainder - 0.25);
			}
			else if (remainder < 0.75)
			{
				fac = -1.0;
			}
			else
			{
				// -1 ~ 1
				fac = -(1 - 8 * (remainder - 0.75));
			}

			float newAngle = angle + fac * Strength * dist;
			float2 newDir;
			sincos(newAngle, newDir.y, newDir.x);

			newDir.y *= AspectRatio;

			float2 samplePoint = Center + dist * newDir;

			fixed4 c = tex2D (_MainTex, samplePoint);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
