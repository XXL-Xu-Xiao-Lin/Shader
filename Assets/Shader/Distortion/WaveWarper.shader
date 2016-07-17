//波浪扭曲
Shader "K/Distortion/WaveWarper" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		Time ("Time", Range(0,2048)) = 0
		WaveSize ("WaveSize", Range(32,256)) = 64
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed Time;
		fixed WaveSize;

		struct Input {
			float2 uv_MainTex;
		};

		float dist(float a, float b, float c, float d){
			return sqrt((a - c) * (a - c) + (b - d) * (b - d));
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float2 uv = IN.uv_MainTex;

			float4 Color = 0;
			float f = sin(dist(uv.x + Time, uv.y, 0.128, 0.128) * WaveSize)
						  + sin(dist(uv.x, uv.y, 0.64, 0.64) * WaveSize)
						  + sin(dist(uv.x, uv.y + Time / 7, 0.192, 0.64) * WaveSize);
			uv.xy = uv.xy + ((f / WaveSize));
			Color = tex2D(_MainTex , uv.xy);

			o.Albedo = Color.rgb;
			o.Alpha = Color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
