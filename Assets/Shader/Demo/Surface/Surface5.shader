Shader "K/Surface/Surface5" {
	Properties{
	
		_MainTex("MainTex",2D) = "white"{}
		_Color("Color",Color) = (0.6, 0.6, 0.3, 0.3)
	}

	SubShader{
	
		Tags{"RenderType"="Opaque"}

		CGPROGRAM
			
			#pragma surface surf Lambert finalcolor:setColor

			sampler2D _MainTex;
			float4 _Color;

			struct Input{
				float2 uv_MainTex;
			};

			void setColor(Input IN, SurfaceOutput o, inout fixed4 color)
			{
				color *= _Color;
			}

			void surf(Input IN, inout SurfaceOutput o)
			{
				o.Albedo = tex2D(_MainTex,IN.uv_MainTex).rgb;
			}

		ENDCG
	}
}
