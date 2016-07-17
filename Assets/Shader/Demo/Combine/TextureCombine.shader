Shader "K/Combine/TextureCombine" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendTex("Blend Texture",2D) = "white"{}
	}
	SubShader {
		Pass{
			
			SetTexture[_MainTex]{Combine Texture}
			SetTexture[_BlendTex]{Combine Texture * previous}

		}
	} 
	FallBack "Diffuse"
}
