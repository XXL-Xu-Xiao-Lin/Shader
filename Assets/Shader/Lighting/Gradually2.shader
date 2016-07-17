Shader "K/Lighting/Gradually2" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	    _Ramp ("Shading Ramp", 2D) = "gray" {}  
		_BumpMap ("Bumpmap", 2D) = "bump" {}    
        _Detail ("Detail", 2D) = "gray" {}    
        _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)    
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0   
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf KGradually
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Ramp;
		sampler2D _BumpMap;    
        sampler2D _Detail;    
        float4 _RimColor;    
        float _RimPower;

		struct Input {
			float2 uv_MainTex; 
			float2 uv_BumpMap;
			float2 uv_Detail;   
			float3 viewDir;    
		};


		half4 LightingKGradually (SurfaceOutput s, half3 lightDir, half atten) 
		{
			half dotNL = max(0, dot(s.Normal, lightDir));

			float hLambert = dotNL * 0.5 + 0.5;   

			half3 ramp = tex2D(_Ramp, float2(hLambert,0)).rgb;

			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (ramp * atten * 2);
			color.a = s.Alpha;

			return color;
		}

		void surf (Input IN, inout SurfaceOutput o) {

			 //先从主纹理获取rgb颜色值    
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;      
			 
            //设置细节纹理    
            o.Albedo *= tex2D (_Detail, IN.uv_Detail).rgb * 2;
			     
            //从凹凸纹理获取法线值    
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));    

            //从_RimColor参数获取自发光颜色    
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));    
            o.Emission = _RimColor.rgb * pow (rim, _RimPower);    
  
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
