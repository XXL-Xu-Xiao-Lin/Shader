Shader "K/AlphaTest/AlphaTestChange" {
	Properties {
		_Color ("Color", Color) = (1,1,1,0)  
        _SpecColor ("Specular", Color) = (1,1,1,1)  
        _Emission ("Emission", Color) = (0,0,0,0)  
        _Shininess ("Shininess", Range (0.01, 1)) = 0.7  
        _MainTex ("MainTex", 2D) = "white" {} 
		
		_AtColor ("AtColor",Range(0,1)) = 0.5 
	}
	SubShader {
		Pass{

			//能被渲染出的透明度
			AlphaTest Greater [_AtColor]

			Material{
				DIFFUSE[_Color]
				Ambient[_Color]
				SPECULAR[_SpecColor]
				Emission[_Emission]
				Shininess[_Shininess]
			}

			Lighting on

			SetTexture[_MainTex]
			{
				Combine Texture * primary
			}
		}
	} 
	FallBack "Diffuse"
}
