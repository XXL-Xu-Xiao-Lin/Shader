Shader "K/Basic/TypeTest"{
	Properties{
		_testRange("Test Range",Range(0.0,1.0))=0.5
		_testColor("Test Color",Color)=(0.78,1,1,1)
		_testFloat("Test Float",float)=0.5 
		_testVector("Test Vector",Vector)=(1,0.5,1,1)
		_test2D ("Test 2D",2D) = ""{}
		_tesrRect ("Test Rect",Rect)=""{}
		_testCube("Test Cube",Cube)=""{}
	}
	SubShader{
		pass{
		}
	}

	FallBack "Diffuse"
}