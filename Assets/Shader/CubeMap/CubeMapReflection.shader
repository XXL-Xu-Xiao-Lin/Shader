Shader "K/CubeMap/CubeMapReflection" {
	Properties {
		_Cubemap ("CubeMap", Cube) = ""{}  
		_ReflAmount ("Reflection Amount", Range(0.01, 1)) = 0.5  
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert  
		#pragma target 3.0

		samplerCUBE _Cubemap;  
		float _ReflAmount;

		struct Input 
		{
			float2 uv_MainTex; 
			float3 worldRefl;
		};

        void surf (Input IN, inout SurfaceOutput o)    
		{ 
			o.Emission = texCUBE(_Cubemap, IN.worldRefl).rgb * _ReflAmount;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
