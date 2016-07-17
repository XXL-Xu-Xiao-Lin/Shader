//銳化
Shader "K/Blur/Sharpens" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	    _Amount("Amount", Range(0,10)) = 0
		_InputSizeX("InputSizeX", Range(1,1000)) = 1
		_InputSizeY("InputSizeY", Range(1,1000)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _Amount;
		float _InputSizeX;
		float _InputSizeY;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			float2 InputSize = float2(_InputSizeX ,_InputSizeY);
			float2 oset = 1 / InputSize;
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			c.rgb += tex2D (_MainTex, IN.uv_MainTex - oset) * _Amount;
			c.rgb -= tex2D (_MainTex, IN.uv_MainTex + oset) * _Amount;

			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
