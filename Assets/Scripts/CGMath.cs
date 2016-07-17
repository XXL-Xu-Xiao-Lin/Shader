using UnityEngine;
using System.Collections;

public class CGMath
{

    public float smoothstep(float a, float b, float x)
    {
        float t;
        if (b - a == 0)
        {
            t = saturate((x - a) / 0.001f);
        }
        else
        {
            t = saturate((x - a) / (b - a));
        }

        
        return t * t * (3.0f - (2.0f * t));
    }

    public float saturate(float x)
    {
        return Mathf.Max(0, Mathf.Min(1, x));
    }

    public float length(float a, float b)
    {
        return Mathf.Sqrt(Mathf.Pow(a, 2) + Mathf.Pow(b, 2));
    }
}
