Shader "K/Surface/Surface2" {
	
	Properties{
	
		_Color("Color",Color) = (1,1,1,1)
	}

	SubShader{
	
		Tags{"RenderType"="Opaque"}

		CGPROGRAM

		#pragma surface surf Lambert

		float4 _Color;

		struct Input {
			float4 Color : COLOR;
		};

		void surf (Input IN,inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
		}


		ENDCG

	}

	FallBack "Diffuse"
}
