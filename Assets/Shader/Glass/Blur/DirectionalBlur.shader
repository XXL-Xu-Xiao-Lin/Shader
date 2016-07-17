Shader "K/Glass/Blur/DirectionalBlur" {
    Properties {
		_Angle("Angle", Range(0,360)) = 0
		_BlurAmount("BlurAmount", Range(0,0.01)) = 0
	}
    SubShader {
 
        Tags { "Queue" = "Transparent" }
 
		GrabPass { 
			Name "DirectionalBlur" 
			Tags { "LightMode" = "Always" }
		}

        Pass {
			Name "DirectionalBlur"
			Tags { "LightMode" = "Always" }
			

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag 
			#pragma target 3.0
 
			sampler2D _GrabTexture : register(s0);
			float _Angle;
			float _BlurAmount;

			struct data {
				float4 vertex : POSITION;
			};
 

			struct v2f {
				float4 position : POSITION;
				float4 screenPos : TEXCOORD0;
			};
 
 
			v2f vert(data i){
				v2f o;
				o.position = mul(UNITY_MATRIX_MVP, i.vertex);
				o.screenPos = o.position;
				return o;
			}
 
 
			half4 frag( v2f i ) : COLOR
			{
 
				float2 screenPos = i.screenPos.xy / i.screenPos.w;
				screenPos.x = (screenPos.x + 1) * 0.5;
				screenPos.y = 1-(screenPos.y + 1) * 0.5;
				
				half4 c = 0;

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
					screenPos.x = screenPos.x - _BlurAmount * xOffset;
					screenPos.y = screenPos.y - _BlurAmount * yOffset;
					c += tex2D(_GrabTexture, screenPos);
				}
				c = c/16;

				return c;
			}
		ENDCG
        }
    }
 
	Fallback Off
}