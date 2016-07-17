Shader "K/Lighting/Lambert" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf KLambert
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};


		half4 LightingKLambert (SurfaceOutput s, half3 lightDir, half atten) 
		{
			half dotNL = max(0, dot(s.Normal, lightDir));

			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (dotNL * atten * 2);
			color.a = s.Alpha;

			return color;
		}

		void surf (Input IN, inout SurfaceOutput o) {

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
