//反轉顏色
Shader "K/ColorMod/InvertColor" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		InvertSwitch("InvertSwitch", Range(0,1)) = 0 
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed InvertSwitch;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			if(InvertSwitch == 1)
				c = fixed4(c.a - c.rgb, c.a);
				//c = fixed4(1 - c.rgb, c.a);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
