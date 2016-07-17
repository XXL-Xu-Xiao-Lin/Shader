Shader "K/AlphaTest/AlphaTest" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass{
		
			AlphaTest Greater 0.6
			SetTexture[_MainTex]
			{
				Combine Texture
			}
		}
	} 
	FallBack "Diffuse"
}
