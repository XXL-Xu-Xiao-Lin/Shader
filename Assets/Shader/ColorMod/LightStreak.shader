//強化明亮區域
Shader "K/ColorMod/LightStreak" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		BrightThreshold ("BrightThreshold", Range(0,1)) = 0.5
		Scale ("Scale", Range(0,1)) = 0.5
		Attenuation ("Attenuation", Range(0,1)) = 0.25
		DirectionX ("DirectionX", Range(-1,1)) = 0.5
		DirectionY ("DirectionY", Range(-1,1)) = 1
		InputSizeX ("InputSizeX", Range(1,1000)) = 800
		InputSizeY ("InputSizeY", Range(1,1000)) = 600
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed BrightThreshold;
		fixed Scale;
		fixed Attenuation;
		fixed DirectionX;
		fixed DirectionY;
		fixed InputSizeX;
		fixed InputSizeY;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {

			fixed2 Direction = fixed2(DirectionX, DirectionY);
			fixed2 InputSize = fixed2(InputSizeX, InputSizeY);

			int numSamples = 2;
			int Iteration = 1;

			float4 pixelColor = tex2D (_MainTex, IN.uv_MainTex);
			float3 rgb = pixelColor.rgb / pixelColor.a;

			//rgb 在 BrightThreshold 以上才有值 (範圍調整)
			float3 bright = saturate((rgb - BrightThreshold) / (1 - BrightThreshold));

			rgb += bright;

			float weightIter = 2;
    
			for (int i = 0; i < numSamples; i++)
			{
				float weight = pow(Attenuation, weightIter * i);
				float2 texCoord = IN.uv_MainTex + (Direction * weightIter * float2(i, i) / InputSize);
				float4 iColor = tex2D(_MainTex, texCoord);
				rgb += saturate(weight) * iColor.rgb / iColor.a;
			}
      
			pixelColor =  float4(rgb * Scale * pixelColor.a, pixelColor.a);

			
			o.Albedo = pixelColor.rgb;
			o.Alpha = pixelColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
