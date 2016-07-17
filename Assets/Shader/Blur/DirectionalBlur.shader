//單一方向模糊
Shader "K/Blur/DirectionalBlur" {
	Properties {   
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Angle("Angle", Range(0,360)) = 0
		_BlurAmount("BlurAmount", Range(0,0.01)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		uniform  sampler2D _MainTex;
		float _Angle;
		float _BlurAmount;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			float4 c = 0;

			//角度 to 弧度
			float rad = _Angle * 0.0174533f;
								 
			//取360度的 sin cos ，後面做為方向
			// 度		sin		cos
			// 0		0		1
			// 90		1		0
			// 180		0		-1
			// 270		-1		0
			float xOffset = cos(rad);
			float yOffset = sin(rad);

			//每個UV座標取16次，加上位移(_BlurAmount)、乘上方向(xOffset、yOffset)
			//並與原來的相加，產生殘影效果
			for(int i=0; i<16; i++)
			{
				IN.uv_MainTex.x = IN.uv_MainTex.x - _BlurAmount * xOffset;
				IN.uv_MainTex.y = IN.uv_MainTex.y - _BlurAmount * yOffset;
				c += tex2D(_MainTex, IN.uv_MainTex);
			}
			c = c/16;

			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
