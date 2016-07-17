//漩渦
Shader "K/Distortion/Swirl" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}

		CenterPointX("CenterPointX", Range(0,1)) = 0.5
		CenterPointY("CenterPointY", Range(0,1)) = 0.5
		SpiralStrength("SpiralStrength", Range(0,20)) = 10
		AspectRatio("AspectRatio", Range(0.5,2)) = 1
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			#pragma surface surf Lambert
			#pragma target 3.0

			sampler2D _MainTex;
			fixed CenterPointX;
			fixed CenterPointY;
			fixed SpiralStrength;
			fixed AspectRatio;

			struct Input {
				float2 uv_MainTex;
			};


			void surf(Input IN, inout SurfaceOutput o) {

				float2 Center = {CenterPointX, CenterPointY};
				float2 uv = IN.uv_MainTex;

				float2 dir = uv - Center;
				dir.y /= AspectRatio;
				float dist = length(dir);
				float angle = atan2(dir.y, dir.x);

				float newAngle = angle + SpiralStrength * dist;
				float2 newDir;
				sincos(newAngle, newDir.y, newDir.x);
				newDir.y *= AspectRatio;

				float2 samplePoint = Center + newDir * dist;
				bool isValid = all(samplePoint >= 0) && all(samplePoint <= 1);
				fixed4 c = isValid ? tex2D(_MainTex, samplePoint) : float4(0, 0, 0, 0);

				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
