Shader "K/Surface/Surface" {
	
	SubShader{
	
		Tags{"RenderType"="Opaque"}

		CGPROGRAM

		#pragma surface surf Lambert

		struct Input {
			float4 Color : COLOR;
		};

		void surf (Input IN,inout SurfaceOutput o)
		{
			o.Albedo = float3(0.5,0.8,0.3);
		}


		ENDCG

	}

	FallBack "Diffuse"
}
