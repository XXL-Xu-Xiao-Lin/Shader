Shader "K/Blend/Blend" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue" = "Geometry" }

		Pass 
		{
			Blend SrcAlpha OneMinusSrcAlpha
			
			SetTexture[_MainTex]
			{
				Combine Texture
			}
		}
	} 
	FallBack "Diffuse"
}
