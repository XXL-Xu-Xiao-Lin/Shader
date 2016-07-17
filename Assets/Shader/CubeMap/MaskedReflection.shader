Shader "K/CubeMap/MaskedReflection" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}  
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)  
		_Cubemap ("CubeMap", Cube) = ""{}  
		_ReflAmount ("Reflection Amount", Range(0.01, 1)) = 0.5 
		_ReflMask ("Reflection Mask", 2D) = ""{}   
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert  
		#pragma target 3.0

		sampler2D _MainTex;  
		sampler2D _ReflMask;
		samplerCUBE _Cubemap;  
		float4 _MainTint;  
		float _ReflAmount;

		struct Input 
		{
			float2 uv_MainTex; 
			float2 uv_ReflMask; 
			float3 worldRefl;
		};

        void surf (Input IN, inout SurfaceOutput o)    
		{ 
			half4 c = tex2D (_MainTex, IN.uv_MainTex);  
			float3 reflection = texCUBE(_Cubemap, IN.worldRefl).rgb;  
			float4 reflMask = tex2D(_ReflMask, IN.uv_ReflMask);  
  
			o.Albedo = c.rgb * _MainTint;  
			o.Emission = (reflection * reflMask.rgb) * _ReflAmount;  
			o.Alpha = c.a;  
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
