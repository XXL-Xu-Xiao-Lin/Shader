using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/K/Blur/DirectionalBlur")]
public class DirectionalBlur : MonoBehaviour {

    public Shader shader = null;

    [Range(0, 360)]
    public float Angle = 0;

    [Range(0, 0.01f)]
    public float BlurAmount = 0;

    private Material _material = null;
    public Material material
    {
        get
        {
            if (_material == null)
            {
                _material = new Material(shader);
                _material.hideFlags = HideFlags.DontSave;
            }
            return _material;
        }
    }

    void OnDisable()
    {
        if (material)
        {
            DestroyImmediate(material);
        }
    }	

    //判斷是否支援
    void Start()
    {
        // Disable if we don't support image effects
        if (!SystemInfo.supportsImageEffects)
        { 
            enabled = false;
            return; 
        } 
        // Disable if the shader can't run on the users graphics card
        if (!shader || !material.shader.isSupported)
        {
            enabled = false;
            return;
        }
    }

    //每次渲染的最後抓取畫面(RenderTexture)
    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
        if (shader != null)
        {
            material.SetFloat("Angle", Angle);
            material.SetFloat("BlurAmount", BlurAmount);

            //sourceTexture傳遞給Shader，進行後處理
            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }  
    }
}
