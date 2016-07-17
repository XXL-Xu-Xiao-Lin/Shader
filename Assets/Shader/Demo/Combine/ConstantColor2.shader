Shader "K/Combine/ConstantColor2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Specular ("Specular(RGB)", Color) = (1,1,1,1)  
	}
	SubShader {
		Pass{
			
			Material{
				DIFFUSE(1,1,1,1)
				Ambient(1,1,1,1)
			}

			Lighting on

			SetTexture[_MainTex]
			{
				ConstantColor[_Specular]

				Combine Constant lerp(Texture) previous
			}

			SetTexture[_MainTex]
			{
				Combine previous * Texture
			}
		
		}
	} 
	FallBack "Diffuse"
}
