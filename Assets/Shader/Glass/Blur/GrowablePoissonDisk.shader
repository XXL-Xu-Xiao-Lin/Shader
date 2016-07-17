Shader "K/Glass/Blur/GrowablePoissonDisk" {
	Properties {
		_DiskRadius("DiskRadius", Range(1,10)) = 1
		_InputSizeX("InputSizeX", Range(0,150)) = 0
		_InputSizeY("InputSizeY", Range(0,150)) = 0
	}
    SubShader {
 
        Tags { "Queue" = "Transparent" }
 
        GrabPass { 
			Name "GrowablePoissonDisk" 
			Tags { "LightMode" = "Always" }
		}
 
        Pass {
			Name "GrowablePoissonDisk"
			Tags { "LightMode" = "Always" }			
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag 
			#pragma target 3.0
 

			static const float2 poisson[12] = 
			{
				float2(-0.326212f, -0.40581f),
				float2(-0.840144f, -0.07358f),
				float2(-0.695914f, 0.457137f),
				float2(-0.203345f, 0.620716f),
				float2(0.96234f, -0.194983f),
				float2(0.473434f, -0.480026f),
				float2(0.519456f, 0.767022f),
				float2(0.185461f, -0.893124f),
				float2(0.507431f, 0.064425f),
				float2(0.89642f, 0.412458f),
				float2(-0.32194f, -0.932615f),
				float2(-0.791559f, -0.59771f)
			};

			sampler2D _GrabTexture : register(s0);
			float _DiskRadius;
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
				float2 InputSize = float2(_InputSizeX,_InputSizeY);
			
				for(int tap = 0; tap < 12; tap++)
				{
					float2 coord = screenPos.xy + (poisson[tap] / InputSize * _DiskRadius);
				
					// Sample pixel
					c += tex2D(_GrabTexture, coord);
				}
				

				return c/13;
			}
		ENDCG
        }
    }
	FallBack "Diffuse"
}
