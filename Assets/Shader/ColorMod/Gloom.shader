//強化黑暗區域
Shader "K/ColorMod/Gloom" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		GloomIntensity ("GloomIntensity", Range(0,1)) = 1
		BaseIntensity ("BaseIntensity", Range(0,1)) = 0.5
		GloomSaturation ("GloomSaturation", Range(0,1)) = 1
		BaseSaturation ("BaseSaturation", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed GloomIntensity;
		fixed BaseIntensity;
		fixed GloomSaturation;
		fixed BaseSaturation;

		struct Input {
			float2 uv_MainTex;
		};


		float3 AdjustSaturation(float3 color, float saturation)
		{
			float grey = dot(color, float3(0.3, 0.59, 0.11));
			return lerp(grey, color, saturation);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			
			float BloomThreshold = 0.25f;
			
			float4 color = tex2D (_MainTex, IN.uv_MainTex);
			float3 base = 1- color.rgb / color.a;

			/*
			範圍調整
			base < BloomThreshold			bloom = 0
			BloomThreshold < base < 1       bloom = 0 ~ 1
			base = 1						bloom = 1
			*/
			float3 bloom = saturate((base - BloomThreshold) / (1 - BloomThreshold));
    
			// 調整 色彩飽和度 和 亮度
			bloom = AdjustSaturation(bloom, GloomSaturation) * GloomIntensity;
			base = AdjustSaturation(base, BaseSaturation) * BaseIntensity;
    
			// Darken down the base image in areas where there is a lot of bloom,
			// to prevent things looking excessively burned-out.
			base *= (1 - saturate(bloom));
    
			// Combine the two images. 
			color = float4(1 - (bloom + base) * color.a, color.a);

			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
