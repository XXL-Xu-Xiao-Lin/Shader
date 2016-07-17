Shader "K/Glass/Blur/TelescopicBlurPS3" {
	 Properties {
		_CenterX("CenterX", Range(0,1)) = 0.5
		_CenterY("CenterY", Range(0,1)) = 0.5
		_ZoomBlurAmount("ZoomBlurAmount", Range(0,3)) = 2.5
		_EdgeSize("EdgeSize", Range(0.5,4)) = 2
	}
    SubShader {
 
        Tags { "Queue" = "Transparent" }
 
        GrabPass { 
			Name "" 
			Tags { "LightMode" = "Always" }
		}
 
        Pass {
			Name ""
			Tags { "LightMode" = "Always" }
 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag 
			#pragma target 3.0
 
			sampler2D _GrabTexture : register(s0);
			float _CenterX;
			float _CenterY;
			float _ZoomBlurAmount;
			float _EdgeSize;

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
				float2 uv = screenPos;

				uv.x -= _CenterX;//0~1 d:0.5
				uv.y -= _CenterY;//0~1 d:0.5

			
				//_EdgeSize 0.5~4  d:2
				//float distanceFactor = pow (pow (abs (uv.x), _EdgeSize) + pow (abs (uv.y), 2), 2);
			
				//每個像素座標到原點的距離
				float distanceFactor = sqrt (pow (abs (uv.x), _EdgeSize) + pow (abs (uv.y), 2));

				for(int i=0; i < 14; i++)
				{
					float scale = 1.0 - distanceFactor *_ZoomBlurAmount * (i / 30.0);
					float2 coord = uv * scale;
					coord.x += _CenterX;
					coord.y += _CenterY;
					c += tex2D(_GrabTexture, coord);
				}
				c /= 14;
				

				return c;
			}
		ENDCG
        }
    }
	FallBack "Diffuse"
}
