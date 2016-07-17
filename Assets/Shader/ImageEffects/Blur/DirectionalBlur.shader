//單一方向模糊
Shader "K/ImageEffect/Blur/DirectionalBlur" {
	Properties {   
		_MainTex ("Base (RGB)", 2D) = "white" {}
		Angle("Angle", Range(0,360)) = 0
		BlurAmount("BlurAmount", Range(0,0.01)) = 0
	}
	SubShader {
		
		Pass {
			CGPROGRAM
			#pragma vertex vert  
			#pragma fragment frag  

			//接收傳遞過來的 RenderTexture (sourceTexture)
			uniform sampler2D _MainTex;
			uniform float Angle;
			uniform float BlurAmount;

			struct Vdata
			{
				//local space pos
				fixed4 vertex : POSITION;

				//UV coordinate for that vertex
				fixed2 textcoord : TEXCOORD0;
			};

			struct v2f
			{
				//projection space pos
				fixed4 pos : SV_POSITION;

				//UV coordinate for that vertex
				fixed2 uv : TEXCOORD;
			};

			v2f vert(Vdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				o.uv = i.textcoord;
				return o;
			}

			fixed4 frag(v2f i) : COLOR  
			{  
				float4 c = 0;
				
				//角度 to 弧度
				float rad = Angle * 0.0174533f;
								 
				//取360度的 sin cos ，後面做為方向
				// 度		sin		cos
				// 0		0		1
				// 90		1		0
				// 180		0		-1
				// 270		-1		0
				float xOffset = cos(rad);
				float yOffset = sin(rad);

				//每個UV座標取16次，加上位移(BlurAmount)、乘上方向(xOffset、yOffset)
				//並與原來的相加，產生殘影效果
				for(int j=0; j<16; j++)
				{
					i.uv.x = i.uv.x - BlurAmount * xOffset;
					i.uv.y = i.uv.y - BlurAmount * yOffset;
					c += tex2D(_MainTex, i.uv);
				}

				return c/16;
			}  
		
		
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
