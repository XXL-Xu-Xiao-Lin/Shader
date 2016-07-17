Shader "K/AlphaTest/Plant" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (0.5,0.5,0.5,0.5)

		_AtColor ("AtColor",Range(0,1)) = 0.5 
	}
	SubShader {
		 //【1】定义材质  
        Material   
        {  
            Diffuse [_Color]  
            Ambient [_Color]  
        }  


		//【2】开启光照  
        Lighting On  
  
        //【3】关闭裁剪，渲染所有面，用于接下来渲染几何体的两面  
        Cull Off  

		//--------------------------【通道一】-------------------------------  
        //      说明：渲染所有超过[_AtColor] 不透明的像素  
        //----------------------------------------------------------------------  
		Pass
		{
		
			AlphaTest Greater [_AtColor]

			SetTexture[_MainTex]
			{
				Combine Texture * primary, Texture
			}
		}


		//----------------------------【通道二】-----------------------------  
        //      说明：渲染半透明的细节  
        //----------------------------------------------------------------------  
        Pass   
        {  
            // 不写到深度缓冲中  
            ZWrite off  
  
            // 不写已经写过的像素  
            ZTest Less  
  
            // 深度测试中，只渲染小于或等于的像素值  
            AlphaTest LEqual [_AtColor]  
  
            // 设置透明度混合  
			Blend SrcAlpha OneMinusSrcAlpha  
              
            // 进行纹理混合  
            SetTexture [_MainTex]   
            {  
                combine texture * primary, texture  
            }  
        }  

	} 
	FallBack "Diffuse"
}
