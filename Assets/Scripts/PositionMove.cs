using UnityEngine;
using System.Collections;

public class PositionMove : MonoBehaviour
{


    public float speed;
    public float range;

    public GameObject m_go1;
    public GameObject m_go2;

    private Vector3 _pos1;
    private Vector3 _pos2;



    void Start()
    {
        _pos1 = m_go1.transform.position;
        _pos2 = m_go2.transform.position;
    }


    void Update()
    {
        m_go1.transform.position = new Vector3(Mathf.Sin(Time.time * speed) * range, _pos1.y, _pos1.z);
        m_go2.transform.position = new Vector3(_pos2.x, Mathf.Sin(Time.time * speed) * range, _pos2.z);
    }
}
