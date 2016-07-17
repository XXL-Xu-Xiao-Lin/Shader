//兩個顏色間的顏色飽和度
Shader "K/ColorMod/ColorTone" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		Desaturation("Desaturation",Range(0,1)) = 0.5
		Toned("Toned",Range(0,1)) = 0.5
		LightColor("LightColor",Color) = (1,1,1,1)
		DarkColor("DarkColor",Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed Desaturation;
		fixed Toned;
		fixed4  LightColor;
		fixed4  DarkColor;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float4 color = tex2D (_MainTex, IN.uv_MainTex);
			float3 scnColor = LightColor * (color.rgb / color.a);

			//轉成灰階
			float gray = dot(float3(0.3, 0.59, 0.11), scnColor);
    
			//灰度
			float3 muted = lerp(scnColor, gray.xxx, Desaturation);

			//藉由灰度來取得顏色比例
			float3 middle = lerp(DarkColor, LightColor, gray);
    
			scnColor = lerp(muted, middle, Toned);
			color = float4(scnColor * color.a, color.a);
			

			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
