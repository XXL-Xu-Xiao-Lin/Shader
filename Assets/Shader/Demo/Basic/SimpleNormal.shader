Shader "K/Basic/SimpleNormal" {
	Properties {
	    _MainTex ("Base (RGB)", 2D) = "white" {}
        _Bump ("Bump", 2D) = "bump" {}
		_Intensity("Intensity", Range(-2 , 2)) = 1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

		sampler2D _MainTex;
        sampler2D _Bump;                
		fixed _Intensity;

        struct Input {
			float2 uv_MainTex;
            float2 uv_Bump;
        };

        void surf (Input IN, inout SurfaceOutput o) {

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

			fixed3 n = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
		    o.Normal = fixed3(n.r * _Intensity, n.g * _Intensity, n.b);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
        }

        ENDCG
    } 
    FallBack "Diffuse"
}
