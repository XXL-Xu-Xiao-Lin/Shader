Shader "K/Other/Streamer" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FlowTex ("Light Texture(A)" ,2D) = "black" {} //掃光
		_MaskTex ("Mask Texture(A)" ,2D) = "white" {}  //遮罩
		_FlowSpeed ("", float) = 2 //掃光速度
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Transparent"}
		LOD 200
		
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _FlowTex;
		sampler2D _MaskTex;
		float _FlowSpeed;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 mask = tex2D (_MaskTex, IN.uv_MainTex);

			float2 uv = IN.uv_MainTex;
			uv.x/=2;
			uv.x+= _Time.y * _FlowSpeed;
			
			float4 flow = tex2D(_FlowTex ,uv);

			//受光影響
			//o.Albedo = c.rgb + flow.rgb;

			//不受光影響
			o.Emission = c.rgb + flow.rgb * 0.7 * mask;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
