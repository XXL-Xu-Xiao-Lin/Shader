//水波繞射
Shader "K/Distortion/Underwater" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		Timer ("Timer", Range(0,1)) = 0
		Refracton ("Refracton", Range(20,60)) = 50
		VerticalTroughWidth ("VerticalTroughWidth", Range(20,30)) = 23
		Wobble2 ("Wobble2", Range(20,30)) = 23
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		float2 poisson[12] =
		{
			float2(-0.326212, -0.40581),
			float2(-0.840144, -0.07358),
			float2(-0.695914, 0.457137),
			float2(-0.203345, 0.620716),
			float2(0.96234, -0.194983),
			float2(0.473434, -0.480026),
			float2(0.519456, 0.767022),
			float2(0.185461, -0.893124),
			float2(0.507431, 0.064425),
			float2(0.89642, 0.412458),
			float2(-0.32194, -0.932615),
			float2(-0.791559, -0.59771)
		};

		sampler2D _MainTex;
		fixed Timer;
		fixed Refracton;
		fixed VerticalTroughWidth;
		fixed Wobble2;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			float2 uv = IN.uv_MainTex;

			float2 Delta = { sin(Timer + uv.x * VerticalTroughWidth + uv.y * uv.y * Wobble2 ) * 0.02 , cos(Timer + uv.y * 32 + uv.x * uv.x * 13)*0.02 };

			float2 NewUV = uv + Delta;

			float4 Color = 0;
			for (int i = 0; i < 12; i++)
			{
				float2 Coord = NewUV + (poisson[i] / Refracton);
				Color += tex2D(_MainTex, Coord)/12.0;
			}
			Color += tex2D(_MainTex, uv)/4;
			Color.a = 1.0;

			o.Albedo = Color.rgb;
			o.Alpha = Color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
