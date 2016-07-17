using UnityEngine;
using System.Collections;

public class ShowWorldNormals : MonoBehaviour
{
    [Range(0, 1)]
    public float range = 0.5f;

    void OnDrawGizmos()
    {
        Gizmos.matrix = transform.localToWorldMatrix;

        Mesh curMesh = transform.GetComponent<MeshFilter>().sharedMesh;
        if (curMesh)
        {
            Vector3[] verts = curMesh.vertices;
            Vector3[] normals = curMesh.normals;

            if (verts.Length > 0)
            {
                for (int i = 0; i < verts.Length; i++)
                {
                    Vector3 colorVec = verts[i].normalized;
                    Gizmos.color = new Color(colorVec.x, colorVec.y, colorVec.z, 1.0f);
                    Gizmos.DrawRay(verts[i], normals[i] * range);
                }
            }
        }
    }
}
