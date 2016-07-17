//翻頁
Shader "K/Distortion/Pivot" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		pivotAmount ("pivotAmount", Range(0,0.5)) = 0.2
		edge ("edge", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex;
		fixed pivotAmount;
		fixed edge;

		struct Input {
			float2 uv_MainTex;
		};

		float4 transform(float2 uv) 
		{ 
			float right = 1 - pivotAmount; 
			// transforming the curent point (uv) according to the new boundaries. 
			float2 tuv = float2((uv.x - pivotAmount) / (right - pivotAmount), uv.y);
 
			float tx = tuv.x - edge; 
			if (tx > edge) 
			{ 
				tx = 1 - tx; 
			}
			float top = pivotAmount * tx; 
			// float top = 1;
			float bottom = 1 - top;         
			if (uv.y >= top && uv.y <= bottom) 
			{ 
				//linear interpolation between 0 and 1 considering the angle of folding.  
				float ty = lerp(0, 1, (tuv.y - top ) / (bottom - top)); 
				// get the pixel from the transformed x and interpolated y. 
				return tex2D(_MainTex, float2(tuv.x , ty)); 
			}else{
				return 0;
			}
		} 

		void surf (Input IN, inout SurfaceOutput o) {
			
			fixed4 c;
			float2 uv = IN.uv_MainTex;

			float right = 1 - pivotAmount; 
			if(uv.x > pivotAmount && uv.x < right) 
			{ 
				c = transform(uv); 
			} else{
				c = 0;
			}
 
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
