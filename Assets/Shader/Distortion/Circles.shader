//同心圓
Shader "K/Distortion/Circles" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		CenterX ("CenterX", Range(0,1)) = 0.5
		CenterY ("CenterY", Range(0,1)) = 0.5
		Size ("Size", Range(0,4)) = 0.9
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed CenterX;
		fixed CenterY;
		fixed Size;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			float2 Center = {CenterX, CenterY};

			float2 dir = IN.uv_MainTex - Center;
			float dist = length(dir) * Size;
			
			/*距離一樣的放到同一點(結果如下)
			
				     *
				    *
				   *
				  *	
				 *
				*	
			*/
			fixed4 c = tex2D (_MainTex, dist + Center);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
