Shader "K/Surface/Surface8" {
	Properties {
		 _MainTex ("MainTex", 2D) = "white" {}    
        _BumpMap ("Bumpmap", 2D) = "bump" {} 
		_Detail ("Detail", 2D) = "gray" {}     
		_ColorTint ("ColorTint", Color) = (0.6, 0.3, 0.6, 0.3)
        _RimColor ("Rim Color", Color) = (0.17,0.36,0.81,0.0)    
        _RimPower ("Rim Power", Range(0.6,9.0)) = 1.0    
    }    
	SubShader {
		//渲染类型为Opaque，不透明    
        Tags { "RenderType" = "Opaque" }    
    
        //-------------------开始CG着色器编程语言段-----------------    
        CGPROGRAM    
    
        //使用 漫反射 光照模式    
        #pragma surface surf Lambert finalcolor:setcolor

        //输入结构    
        struct Input     
        {    
            float2 uv_MainTex;//纹理贴图    
            float2 uv_BumpMap;//法线贴图
            float2 uv_Detail;//细节纹理的uv值  
            float3 viewDir;//观察方向    
        };    
    
        //变量声明    
        sampler2D _MainTex;//主纹理    
        sampler2D _BumpMap;//凹凸纹理 
		sampler2D _Detail;
		fixed4 _ColorTint;   
        float4 _RimColor;//边缘颜色    
        float _RimPower;//边缘颜色强度    
		

		//自定义颜色函数setcolor的编写
		void setcolor (Input IN, SurfaceOutput o, inout fixed4 color)
		{
			color *= _ColorTint;
		}

        //表面着色函数的编写    
        void surf (Input IN, inout SurfaceOutput o)    
        {    
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);   
			
			c *= tex2D (_Detail, IN.uv_Detail) * 2;

			o.Albedo = c.rgb;
			 
            //表面法线为凹凸纹理的颜色    
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));    
            //边缘颜色    
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));    
            //边缘颜色强度    
            o.Emission = _RimColor.rgb * pow (rim, _RimPower);    
        }    
    
        //-------------------结束CG着色器编程语言段------------------    
        ENDCG    
	} 
	FallBack "Diffuse"
}
