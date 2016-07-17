//X波段效果
Shader "K/Distortion/Bands" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		BandDensity ("BandDensity", Range(0,150)) = 65
		BandIntensity ("BandIntensity", Range(0,1)) = 0.056
		IsRightSideBand ("IsRightSideBand", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed BandDensity;
		fixed BandIntensity;
		fixed IsRightSideBand;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			fixed2 uv = IN.uv_MainTex;
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			/*
			uv.x				=	0 ~ 1
			uv.x * BandDensity	=	0 ~ BandDensity			
			*/
			if(IsRightSideBand == true){
				c.rgb += tan(uv.x * BandDensity) * BandIntensity;
			} 
			else
			{
				c.rgb -= tan(uv.x * BandDensity) * BandIntensity;
			}
    
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
