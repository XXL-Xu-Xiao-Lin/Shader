using UnityEngine;
using System.Collections;

public class GetShaderValue : MonoBehaviour
{  
     
    public Shader m_Shader;
    public Renderer m_Renderer; 
     
    [ContextMenu("Print Shader Value")]
    void PrintShaderValue()
    {
        Material m = m_Renderer.material;
        m.shader = m_Shader;
        print(m.GetFloat("_uvx"));
    }

}
