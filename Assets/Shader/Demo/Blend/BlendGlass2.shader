Shader "K/Blend/BlendGlass2" {

	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)  
        _MainTex ("Base (RGB) Transparency (A)", 2D) = "white" {}  
        _Reflections ("Base (RGB) Gloss (A)", Cube) = "skybox" { TexGen CubeReflect }  
	}

	//--------------------------------【子着色器】--------------------------------  
    SubShader   
    {  
        //-----------子着色器标签----------  
        Tags { "Queue" = "Transparent" }  
  

		//----------------通道1--------------
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha

			Material{
				DIFFUSE[_Color]
			}

			Lighting on 

			SetTexture[_MainTex]
			{
				Combine Texture * primary double, Texture * primary
			}
		}


        //----------------通道2---------------  
        Pass   
        {  
            //进行纹理混合  
            Blend One One  
  
			//设置材质  
            Material   
            {  
                Diffuse [_Color]  
            }  


            //开光照  
            Lighting On  
  
            //和纹理相乘  
            SetTexture [_Reflections]   
            {  
                combine texture  
                Matrix [_Reflection]  
            }  
        }  
    }  

	FallBack "Diffuse"
}
