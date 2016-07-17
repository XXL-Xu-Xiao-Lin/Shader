Shader "K/Combine/SeparateSpecular" {
	Properties {
		_IlluminCol ("SpecularCol", Color) = (1,1,1,1)  
		_Color ("Color", Color) = (1,1,1,0)  
        _SpecColor ("Specular", Color) = (1,1,1,1)  
        _Emission ("Emission", Color) = (0,0,0,0)  
        _Shininess ("Shininess", Range (0.01, 1)) = 0.7  
        _MainTex ("MainTex", 2D) = "white" {}  
		_BlendTex ("BlendTex ", 2D) = "white" {}  
	}
	SubShader {
		Pass   
        {  
            //【1】设置顶点光照值  
            Material   
            {  
                //可调节的漫反射光和环境光反射颜色  
                Diffuse [_Color]  
                Ambient [_Color]  
                //光泽度  
                Shininess [_Shininess]  
                //高光颜色  
                Specular [_SpecColor]  
                //自发光颜色  
                Emission [_Emission]    
            }  
  
            //【2】开启光照  
            Lighting On  
  
            //【3】---------------------开启独立镜面反射----------------  
            SeparateSpecular On  
  
            //【4】将自发光颜色混合上纹理  
            SetTexture [_MainTex]   
            {  
                // 使颜色属性进入混合器  
                constantColor [_IlluminCol]  
                // 使用纹理的alpha通道插值混合顶点颜色  
                combine constant lerp(texture) previous  
            }  
  
            //【5】乘上基本纹理  
            SetTexture [_MainTex] {  combine previous * texture }  
  
			//【6】乘上混合纹理  
            SetTexture [_BlendTex] { combine previous * texture }

            //【7】乘以顶点纹理  
             SetTexture [_MainTex]  {  Combine previous * primary DOUBLE, previous * primary}  
  
        }  
	} 
	FallBack "Diffuse"
}
