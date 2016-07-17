using UnityEngine;
using System.Collections; 

public class moveUV : MonoBehaviour {

    public MeshRenderer m_MeshRenderer;

    private float size = 0.5f;
	 
	void Update () {   
        Vector3 pos = Input.mousePosition;

        float xmax = 1 / size; 
        float ymax = 1 / size;

        float x = 0.5f - pos.x / Screen.width * xmax;
        float y = 0.5f - pos.y / Screen.height * ymax;


        m_MeshRenderer.material.mainTextureOffset = new Vector2(x, y);
    }
}
