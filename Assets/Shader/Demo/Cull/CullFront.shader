Shader "K/Cull/CullFront" {
	
	SubShader {
		Pass{
		
			Material{
				DIFFUSE(1,1,1,1)
				Emission(0.3,0.3,0.3,0.3)
			}

			Lighting on

			Cull front
		}
	} 
	FallBack "Diffuse"
}
