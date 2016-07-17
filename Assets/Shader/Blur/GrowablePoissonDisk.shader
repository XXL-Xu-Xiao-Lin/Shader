//根據輸入點進行模糊
Shader "K/Blur/GrowablePoissonDisk" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DiskRadius("DiskRadius", Range(1,10)) = 1
		_InputSizeX("InputSizeX", Range(0,150)) = 0
		_InputSizeY("InputSizeY", Range(0,150)) = 0
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		static const float2 poisson[12] = 
		{
			float2(-0.326212f, -0.40581f),
			float2(-0.840144f, -0.07358f),
			float2(-0.695914f, 0.457137f),
			float2(-0.203345f, 0.620716f),
			float2(0.96234f, -0.194983f),
			float2(0.473434f, -0.480026f),
			float2(0.519456f, 0.767022f),
			float2(0.185461f, -0.893124f),
			float2(0.507431f, 0.064425f),
			float2(0.89642f, 0.412458f),
			float2(-0.32194f, -0.932615f),
			float2(-0.791559f, -0.59771f)
		};


		sampler2D _MainTex;
		float _DiskRadius;
		float _InputSizeX;
		float _InputSizeY;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 cOut;
			float2 InputSize = float2(_InputSizeX,_InputSizeY);
			
			for(int tap = 0; tap < 12; tap++)
			{
				float2 coord = IN.uv_MainTex.xy + (poisson[tap] / InputSize * _DiskRadius);
				
				// Sample pixel
				cOut += tex2D(_MainTex, coord);
			}
			
			
			o.Albedo = (cOut/13).rgb;
			o.Alpha = (cOut/13).a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
