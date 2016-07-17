//除霧、曝光、灰度、暗角、和藍色值校正
Shader "K/ColorMod/ToneMapping" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		Defog ("Defog", Range(0,1)) = 0.01
		FogColor("FogColor", Color) = (1,1,1,1)
		Exposure ("Exposure", Range(-1,1)) = 0.2
		Gamma ("Gamma", Range(0.5,2)) = 0.8
		VignetteCenterX ("VignetteCenterX", Range(0,1)) = 0.5
		VignetteCenterY ("VignetteCenterY", Range(0,1)) = 0.5
		VignetteRadius ("VignetteRadius", Range(0,1)) = 1
		VignetteAmount ("VignetteAmount", Range(-1,1)) = -1
		BlueShift ("BlueShift", Range(0,1)) = 0.25
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed Defog;
		fixed4 FogColor;
		fixed Exposure;
		fixed Gamma;
		fixed VignetteCenterX;
		fixed VignetteCenterY;
		fixed VignetteRadius;
		fixed VignetteAmount;
		fixed BlueShift;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 VignetteCenter = float2(VignetteCenterX, VignetteCenterY);

			float4 c = tex2D (_MainTex, IN.uv_MainTex);

			//去掉顏色值
			c.rgb = max(0, c.rgb - Defog * FogColor.rgb);

			//曝光
			c.rgb *= pow(2.0f, Exposure);

			//灰度
			c.rgb = pow(c.rgb, Gamma);

			//位移(重置原點)
			float2 tc = IN.uv_MainTex - VignetteCenter;
			//算出距離原點距離，並縮小值
			float v = length(tc) / VignetteRadius;
			//縮放值倍率，並加上值，形成暗角區域
			c.rgb += pow(v, 4) * VignetteAmount;

			//調整顏色比例(藍色居多)，並進行差值
			float3 d = c.rgb * float3(1.05f, 0.97f, 1.27f);
			c.rgb = lerp(c.rgb, d, BlueShift);
    
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
