Shader "K/Blend/BlendGlass" {

	Properties {
        _Reflections ("Base (RGB) Gloss (A)", Cube) = "skybox" { TexGen CubeReflect }  
	}

	//--------------------------------【子着色器】--------------------------------  
    SubShader   
    {  
        //-----------子着色器标签----------  
        Tags { "Queue" = "Transparent" }  
  
        //----------------通道---------------  
        Pass   
        {  
            //进行纹理混合  
            Blend One One  
  
  
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
