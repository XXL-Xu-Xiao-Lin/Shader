Shader "K/CubeMap/NormalMappedReflection" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("MainTex", 2D) = "white" {}
		_NorTex ("NorTex", 2D) = "bump" {}
		_CubeMap("CubeMap" , Cube) = ""{}
		_ReflAmount ("Reflection Amount", Range(0,1)) = 0.5 
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MainTex;
		sampler2D _NorTex;
		samplerCUBE _CubeMap;
		float _ReflAmount;  

		struct Input {
			float2 uv_MainTex;
			float2 uv_NorTex; 
			float3 worldRefl; INTERNAL_DATA  
		};

		void surf (Input IN, inout SurfaceOutput o) {

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;

			o.Normal = UnpackNormal(tex2D(_NorTex, IN.uv_NorTex)).rgb;
			o.Emission = texCUBE(_CubeMap, WorldReflectionVector (IN, o.Normal)).rgb * _ReflAmount;
			o.Albedo = c.rgb * _Color;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
