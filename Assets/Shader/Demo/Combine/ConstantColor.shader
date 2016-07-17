Shader "K/Combine/ConstantColor" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass{

			//【1】设置白色的顶点光照
			Material{
				DIFFUSE(1,1,1,1)
				Ambient(1,1,1,1)
			}

			//【2】开光照
			Lighting on
		
			//【3】使用 纹理的Alpha通道 来插值 混合颜色(1,1,1,1)  
			SetTexture[_MainTex]
			{
				ConstantColor(1,1,1,1)
				Combine constant lerp(Texture) previous  
			}

			//【4】和纹理相乘
			SetTexture[_MainTex]
			{
				Combine previous * Texture
			}
		}
	} 
	FallBack "Diffuse"
}
