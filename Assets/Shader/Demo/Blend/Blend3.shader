Shader "K/Blend/Blend3" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color",Color )=(1,1,1,0)
	}

	SubShader   
    {  
        //-----------子着色器标签----------  
        Tags { "Queue" = "Transparent" }  
  
        //----------------通道---------------  
         Pass   
            {  
                //【1】设置材质  
                Material  
                {  
                    Diffuse [_Color]    
                    Ambient [_Color]   
                }  
  
                //【2】开启光照    
                Lighting On   
                Blend One OneMinusDstColor          // Soft Additive  
                SetTexture [_MainTex]  
                {   
                    // 使颜色属性进入混合器    
                    constantColor [_Color]    
                    // 使用纹理的alpha通道插值混合顶点颜色    
                    combine constant lerp(texture) previous    
                }  
            }  
    }  

	FallBack "Diffuse"
}
