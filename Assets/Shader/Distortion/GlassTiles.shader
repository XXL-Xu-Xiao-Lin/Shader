//玻璃磚塊
Shader "K/Distortion/GlassTiles" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		Tiles ("Tiles", Range(0,20)) = 5
		BevelWidth ("BevelWidth", Range(0,10)) = 1
		TilesOffset ("TilesOffset", Range(0,3)) = 1
		GroutColor("GroutColor", Color) = (1,1,1,1) 
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed Tiles;
		fixed BevelWidth;
		fixed TilesOffset;
		fixed4 GroutColor;

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			
			fixed2 uv = IN.uv_MainTex;

			float2 newUV1;

			//一周中tan會有一小部分處於極小(大)值
			//uv.xy原範圍為0~1，乘以 (Tiles * 2.5) 後範圍變成 0~(Tiles * 2.5)，波長變長、周期變多
			//uv.xy加上一個極小(大)值，點會超出0~1
			newUV1.xy = uv.xy + tan((Tiles * 2.5) * uv.xy + TilesOffset) * (BevelWidth / 100);

			float4 c1 = tex2D(_MainTex, newUV1);

			//uv.xy 不在 0~1(超出範圍) 時，設定顏色
			if(newUV1.x < 0 || newUV1.x > 1 || newUV1.y < 0 || newUV1.y > 1)
			{
				c1 = GroutColor;
			}
			c1.a = 1;			

			o.Albedo = c1.rgb;
			o.Alpha = c1.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
