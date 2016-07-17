using UnityEngine;
 

public class SetArray : MonoBehaviour
{
    public int rowCount = 5; 
    public GameObject[] go;

    public void StartSort()
    {
        if (go == null)
            return;

        Vector3 pos = this.transform.position;
       
        float x = 1.5f;
        float z = -1.5f;
        int row = 0;

        for (int i = 0; i < go.Length; i++)
        {

            if (i != 0 && i % rowCount == 0)
            {
                row++;
            }

            if (go[i] != null)
            {
                go[i].transform.position = new Vector3((i * x) - (x * row * rowCount), 0, row * z) + pos;
            }

        }

    }
}
