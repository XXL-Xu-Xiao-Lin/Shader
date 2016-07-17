Shader "K/Surface/Surface7" {
	Properties {
		_Color("Color",Color) = (0,0,0,0)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DetailTex ("DetailTex", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _DetailTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_DetailTex;
		};


		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			/*fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			c += tex2D (_DetailTex, IN.uv_DetailTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;*/

			//先从主纹理获取rgb颜色值
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;   
			//设置细节纹理
			o.Albedo *= tex2D (_DetailTex, IN.uv_DetailTex).rgb; 

		}
		ENDCG
	} 
	FallBack "Diffuse"
}
