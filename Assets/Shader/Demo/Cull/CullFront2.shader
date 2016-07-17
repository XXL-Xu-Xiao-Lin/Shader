Shader "K/Cull/CullFront2" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}  

		_Color ("Color", Color) = (1,1,1,0)  
        _SpecColor ("Specular", Color) = (1,1,1,1)  
        _Emission ("Emission", Color) = (0,0,0,0)  
        _Shininess ("Shininess", Range (0.01, 1)) = 0.7  
	}
	SubShader {
		Pass   
        {  
            //【1】设置顶点光照  
            Material  
            {  
                Diffuse [_Color]  
                Ambient [_Color]  
                Shininess [_Shininess]  
                Specular [_SpecColor]  
                Emission [_Emission]  
            }  
  
            //【2】开启光照  
            Lighting On  
  
            // 【3】将顶点颜色混合上纹理  
            SetTexture [_MainTex]   
            {  
                Combine Primary * Texture  
            }  
  
        }
		
		//--------------------------【通道二】-------------------------------  
        //      说明：采用亮蓝色来渲染背面  
        //----------------------------------------------------------------------  
        Pass   
        {  
            Color (0,0,1,1)  
            Cull Front  
        }    
	} 
	FallBack "Diffuse"
}
