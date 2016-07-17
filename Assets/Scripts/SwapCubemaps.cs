using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SwapCubemaps : MonoBehaviour {

    public Cubemap cubeA;
    public Cubemap cubeB;

    public Transform posA;
    public Transform posB;

    private Material curMat;
    private Cubemap curCube;

    void Update()
    {
        curMat = GetComponent<Renderer>().sharedMaterial;
        if (curMat)
        {
            curCube = CheckProbeDistance();
            curMat.SetTexture("_Cubemap", curCube);

        }
    }  

    private Cubemap CheckProbeDistance()
    {
        float distA = Vector3.Distance(transform.position, posA.position);
        float distB = Vector3.Distance(transform.position, posB.position);

        if (distA <= distB)
        {
            return cubeA;
        }
        else 
        {
            return cubeB;
        }
    }  
}
