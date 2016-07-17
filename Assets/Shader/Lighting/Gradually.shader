Shader "K/Lighting/Gradually" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	    _Ramp ("Shading Ramp", 2D) = "gray" {}  
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf KGradually
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Ramp;

		struct Input {
			float2 uv_MainTex;
		};


		half4 LightingKGradually (SurfaceOutput s, half3 lightDir, half atten) 
		{
			half dotNL = max(0, dot(s.Normal, lightDir));

			float hLambert = dotNL * 0.5 + 0.5;   

			half3 ramp = tex2D(_Ramp, float2(hLambert, 0)).rgb;

			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (ramp * atten * 2);
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
