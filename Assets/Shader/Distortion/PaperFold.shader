//摺紙
Shader "K/Distortion/PaperFold" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		FoldAmount ("FoldAmount", Range(0,1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed FoldAmount;

		struct Input {
			float2 uv_MainTex;
		};

		float4 transform(float2 uv, float right) 
		{ 
			fixed4 c;
			// transforming the curent point (uv) according to the new boundaries. 
			float2 tuv = float2((uv.x - FoldAmount) / (right - FoldAmount), uv.y);
 
			float tx = tuv.x; 
			if (tx > 0.5) 
			{ 
				tx = 1 - tx; 
			}
			float top = FoldAmount * tx; 
			float bottom = 1 - top;   
			if (uv.y >= top && uv.y <= bottom) 
			{ 
				//linear interpolation between 0 and 1 considering the angle of folding.  
				float ty = lerp(0, 1, (tuv.y - top) / (bottom - top)); 
				// get the pixel from the transformed x and interpolated y. 
				c = tex2D(_MainTex, float2(tuv.x, ty)); 
			} 

			return c;
		}
		
		void surf (Input IN, inout SurfaceOutput o) {
			
			fixed4 c;
			float2 uv = IN.uv_MainTex;

			float right = 1 - FoldAmount; 
			if(uv.x > FoldAmount && uv.x < right) 
			{ 
				c = transform(uv, right);
			}else{
				c = 0; 
			} 
 
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
