Shader "K/Basic/Texture" {
	
	Properties{
	
		_MainTex("MainTex",2D) = "white"{TexGen SphereMap}
	
	}

	SubShader{
		Pass{
			SetTexture[_MainTex]{Combine Texture}
		}
	}

	FallBack "Diffuse"
}
