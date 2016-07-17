Shader "K/Basic/Color" {
	
	Properties{
		_Color("Color",Color) = (1,1,1,0)
		_SpecColor("SpecColor",Color) = (1,1,1,1)
		_Emission("Emission",Color) = (0,0,0,0)
		_Shininess("Shininess",Range(0.01,1)) = 0.7
	}

	SubShader {
			pass{		

				Material{
		
					//漫返色光
					Diffuse[_Color]

					//環境反射光
					Ambient[_Color]

					//光澤度
					Shininess[_Shininess]

					//高光顏色
					Specular[_SpecColor]

					//自發光顏色
					Emission[_Emission]
				}

				Lighting on
			}
	} 
}
