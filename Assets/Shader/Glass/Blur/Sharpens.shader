Shader "K/Glass/Blur/Sharpens" {
    Properties {
		_Amount("Amount", Range(0,10)) = 0
		_InputSizeX("InputSizeX", Range(1,1000)) = 1
		_InputSizeY("InputSizeY", Range(1,1000)) = 1
	}
    SubShader {
 
        Tags { "Queue" = "Transparent" }
 
        GrabPass { 
			Name "Sharpens" 
			Tags { "LightMode" = "Always" }
		}
 
        Pass {
			Name "Sharpens"
			Tags { "LightMode" = "Always" }
 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag 
			#pragma target 3.0
 
			sampler2D _GrabTexture : register(s0);
			float _Amount;
			float _InputSizeX;
			float _InputSizeY;

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

				float2 InputSize = float2(_InputSizeX ,_InputSizeY);
				float2 oset = 1 / InputSize;
				c = tex2D (_GrabTexture, screenPos);

				c.rgb += tex2D (_GrabTexture, screenPos - oset) * _Amount;
				c.rgb -= tex2D (_GrabTexture, screenPos + oset) * _Amount;


				return c;
			}
		ENDCG
        }
    }
 
	Fallback Off
}