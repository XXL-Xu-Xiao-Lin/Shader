//控制亮度和對比度
Shader "K/ColorMod/ContrastAdjust" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		Brightness("Brightness",Range(-1,1)) = 0
		Contrast("Contrast",Range(0,2)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed Brightness;
		fixed Contrast;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float4 pixelColor = tex2D (_MainTex, IN.uv_MainTex);
			pixelColor.rgb /= pixelColor.a;
    
			// 顏色比率	  Contrast
			// 顏色分界點 0.5
			/*
			RGB		Contrast	Value
			1		2			1.5
			0.9		2			1.3
			0.8		2			1.1
			0.7		2			0.9
			0.6		2			0.7					↑↑ RGB < Value
			0.5		2			0.5 **顏色分界點		 RGB = Value
			0.4		2			0.3					↓↓ RGB > Value 
			0.3		2			0.1
			0.2		2			-0.1
			0.1		2			-0.3
			0.0		2			-0.5

			RGB		Contrast	Value
			1		0.7			0.85
			0.9		0.7			0.78
			0.8		0.7			0.71
			0.7		0.7			0.64
			0.6		0.7			0.57				↑↑ RGB > Value 
			0.5		0.7			0.5 **顏色分界點		 RGB = Value
			0.4		0.7			0.43				↓↓ RGB < Value 
			0.3		0.7			0.36
			0.2		0.7			0.29
			0.1		0.7			0.22
			0.0		0.7			0.15
			*/
			//當Contrast越大時顏色差距越大(顏色深淺越大)
			pixelColor.rgb = ((pixelColor.rgb - 0.5f) * Contrast) + 0.5f;
    
			// 亮度
			pixelColor.rgb += Brightness;
    
			// Return final pixel color.
			pixelColor.rgb *= pixelColor.a;

			o.Albedo = pixelColor.rgb;
			o.Alpha = pixelColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
