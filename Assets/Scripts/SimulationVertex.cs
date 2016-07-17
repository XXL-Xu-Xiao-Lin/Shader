using UnityEngine;
using System.Collections;
using System.Text;
using System;

public class SimulationVertex : MonoBehaviour
{
    public bool IsShowLog = false;
    public GameObject ElementBlue;
    public GameObject ElementRed;
    private GameObject _go;

    public int rowCount = 11;
    public bool isContinueUpdate = false;

    private CGMath cgMath = new CGMath();

    public enum ShaderType
    {
        Standard,
        TelescopicBlurPS3,
        LightStreak,
        BandedSwirl,
        Bands,
        Circles,
        GlassTiles,
        MagnifySmooth,
        Pinch
    }
    public ShaderType shaderType = ShaderType.Standard;

    [Range(-1, 1)]
    public float coordPosX = 0;
    [Range(-1, 1)]
    public float coordPosY = 0;

    [Range(0, 2)]
    public float coordScaleX = 1;
    [Range(0, 2)]
    public float coordScaleY = 1;

    //-------------------------------------------------
    //TelescopicBlurPS3
    [Range(-1, 1)]
    public float offsetCoordPosX = 0;
    [Range(-1, 1)]
    public float offsetCoordPosY = 0;
    public bool isOffsetCoordSync = true;

    //-------------------------------------------------
    //LightStreak
    [Range(-1, 1)]
    public float DirectionX = 0.5f;
    [Range(-1, 1)]
    public float DirectionY = 1;
    [Range(1, 100)]
    public float InputSizeX = 10;
    [Range(1, 100)]
    public float InputSizeY = 10;

    //-------------------------------------------------
    //BandedSwirl
    [Range(0, 1)]
    public float CenterX = 0.5f;
    [Range(0, 1)]
    public float CenterY = 0.5f;
    [Range(0, 20)]
    public float BandCount = 10;
    [Range(0, 1)]
    public float Strength = 0.5f;
    [Range(0.5f, 2)]
    public float AspectRatio = 1f;


    //-------------------------------------------------
    //Bands
    [Range(0, 150)]
    public float BandDensity = 65;
    [Range(0, 1)]
    public float BandIntensity = 0.056f;
    [Range(0, 1)]
    public float IsRightSideBand = 0;

    //-------------------------------------------------
    //Circles
    [Range(0, 1)]
    public float CirclesCenterX = 0.5f;
    [Range(0, 1)]
    public float CirclesCenterY = 0.5f;
    [Range(0, 4)]
    public float CirclesSize = 0.9f;


    //-------------------------------------------------
    //GlassTiles
    [Range(0, 20)]
    public float Tiles = 5;
    [Range(0, 10)]
    public float BevelWidth = 1;
    [Range(0, 3)]
    public float TilesOffset = 1;


    //-------------------------------------------------
    //MagnifySmooth
    [Range(0, 1)]
    public float MagnifySmoothCenterX = 0.5f;
    [Range(0, 1)]
    public float MagnifySmoothCenterY = 0.5f;
    [Range(0, 1)]
    public float InnerRadius = 0.2f;
    [Range(0, 1)]
    public float OuterRadius = 0.4f;
    [Range(1, 5)]
    public float MagnificationAmount = 2f;
    [Range(0.5f, 2)]
    public float MagnifySmoothAspectRatio = 1f;


    //-------------------------------------------------
    //Pinch
    [Range(0, 1)]
    public float PinchCenterX = 0.5f;
    [Range(0, 1)]
    public float PinchCenterY = 0.5f;
    [Range(0, 1)]
    public float PinchRadius = 0.3f;
    [Range(0, 2)]
    public float PinchStrength = 1f;
    [Range(0.5f, 2)]
    public float PinchAspectRatio = 1f;

    public void CreateElement()
    {
        ClearElement();

        Vector3 v = this.transform.position;

        float x = 1f;
        float z = 1f;
        int row = 0;
        int rowXCoord = 0;
        _go = ElementBlue;

        for (int i = 0; i < Math.Pow(rowCount, 2); i++)
        {

            if (i != 0 && i % rowCount == 0)
            {
                row++;
                rowXCoord = 0;

                if (row % 2 == 0)
                    _go = ElementBlue;
                else
                    _go = ElementRed;
            }

            if (_go != null)
            {
                Vector3 pos = new Vector3((i * x) - (x * row * rowCount), 0, row * z);

                Vector3 pos2 = new Vector3((pos.x + coordPosX * 10), 0, (pos.z + coordPosY * 10));
                //Vector3 pos2 = new Vector3((coordPosX * 10 - pos.x), 0, (coordPosY * 10 - pos.z));


                Vector3 pos3 = Vector3.zero;
                switch (shaderType)
                {
                    case ShaderType.Standard:
                        pos3 = new Vector3(pos2.x * coordScaleX, 0, pos2.z * coordScaleY);
                        break;
                    case ShaderType.TelescopicBlurPS3:
                        pos3 = TelescopicBlurPS3(pos2);
                        break;
                    case ShaderType.LightStreak:
                        pos3 = LightStreak(pos2);
                        break;
                    case ShaderType.BandedSwirl:
                        pos3 = BandedSwirl(pos2, i);
                        break;
                    case ShaderType.Bands:
                        Bands(pos2);
                        break;
                    case ShaderType.Circles:
                        pos3 = Circles(pos2);
                        break;
                    case ShaderType.GlassTiles:
                        GlassTiles(pos2);
                        break;
                    case ShaderType.MagnifySmooth:
                        pos3 = MagnifySmooth(pos2, i);
                        break;
                    case ShaderType.Pinch:
                        pos3 = Pinch(pos2);
                        break;
                }


                GameObject temp = Instantiate(_go, pos3 + v, Quaternion.identity) as GameObject;
                temp.name = "Element\t" + (i + 1) + "\t" + rowXCoord + "," + row;
                temp.transform.parent = this.transform;

                rowXCoord++;
            }


        }

        IsShowLog = false;
    }

    public void ClearElement()
    {
        int count = this.transform.childCount;

        for (int i = count - 1; i >= 0; --i)
        {
            if (this.transform.GetChild(i).gameObject.name.StartsWith("NoClear"))
                continue;

            DestroyImmediate(this.transform.GetChild(i).gameObject);
        }
    }

    void ClearConsoleLog()
    {
        var logEntries = System.Type.GetType("UnityEditorInternal.LogEntries,UnityEditor.dll");
        var clearMethod = logEntries.GetMethod("Clear", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public);
        clearMethod.Invoke(null, null);
    }
    public void Reset()
    {
        CreateElement();
    }


    #region Vertex Control Function

    Vector3 TelescopicBlurPS3(Vector3 v)
    {
        if (isOffsetCoordSync)
        {
            offsetCoordPosX = coordPosX;
            offsetCoordPosY = coordPosY;
        }

        double distanceFactor = Math.Sqrt(Math.Pow(Math.Abs(v.x / 10), 2) + Math.Pow(Math.Abs(v.z / 10), 2));
        float scale = (float)(1.0 - distanceFactor /** 2 * (15 / 30.0)*/);
        //print("distanceFactor" + distanceFactor);
        //print("scale" + scale);
        Vector3 pos = new Vector3(v.x * scale, 0, v.z * scale);

        Vector3 pos2 = new Vector3((pos.x - offsetCoordPosX * 10), 0, (pos.z - offsetCoordPosY * 10));

        return pos2;
    }


    Vector3 LightStreak(Vector3 v)
    {
        float i = 1;

        float x = v.x + ((DirectionX * 10) * 2 * i / InputSizeX);
        float z = v.z + ((DirectionY * 10) * 2 * i / InputSizeY);

        return new Vector3(x, 0, z);
    }


    Vector3 BandedSwirl(Vector3 v, int i)
    {
        string debugStr = "";

        Vector3 dir = new Vector3((v.x - CenterX * 10), 0, (v.z - CenterY * 10));
        dir.z /= AspectRatio;
        float dist = Mathf.Sqrt(Mathf.Pow(dir.x, 2) + Mathf.Pow(dir.z, 2));
        float angle = Mathf.Atan2(dir.z, dir.x);


        debugStr += i + "\t";
        debugStr += "dir.x:" + dir.x / 10 + "\t";
        debugStr += "dir.z:" + dir.z / 10 + "\t";
        debugStr += "dist:" + dist / 10 + "\t";
        debugStr += "angle:" + angle + "\t";


        float remainder = dist * BandCount - Mathf.Floor(dist * BandCount);
        float fac;
        if (remainder < 0.25f)
        {
            fac = 1.0f;
        }
        else if (remainder < 0.5f)
        {
            // transition zone - go smoothly from previous zone to next.
            fac = 1 - 8 * (remainder - 0.25f);
        }
        else if (remainder < 0.75f)
        {
            fac = -1.0f;
        }
        else
        {
            // transition zone - go smoothly from previous zone to next.
            fac = -(1 - 8 * (remainder - 0.75f));
        }

        debugStr += "Bands:" + BandCount + "\t";
        debugStr += "remainder:" + remainder + "\t";
        debugStr += "fac:" + fac + "\t";

        float newAngle = angle + fac * Strength * dist;

        Vector3 newDir;
        newDir.x = Mathf.Cos(newAngle);
        newDir.z = Mathf.Sin(newAngle);


        debugStr += "newAngle:" + angle + fac * Strength * dist / 10 + "\t\t";
        debugStr += "Cos:" + newDir.x + "\t";
        debugStr += "Sin:" + newDir.z + "\t";


        newDir.z *= AspectRatio;

        Vector3 samplePoint = new Vector3(CenterX * 10 + dist * newDir.x, 0, CenterY * 10 + dist * newDir.z);

        if (IsShowLog)
            Debug.Log(debugStr);

        return samplePoint;
    }

    void Bands(Vector3 v)
    {
        string debugStr = "";

        v /= 10;

        debugStr += "v.x:" + v.x + "\t";
        debugStr += "v.z:" + v.z + "\t";
        debugStr += "v.x * BandDensity:" + v.x * BandDensity + "\t\t";
        debugStr += "Tan:" + Mathf.Tan(v.x * BandDensity) * BandIntensity;

        if (IsShowLog)
            Debug.Log(debugStr);
    }


    Vector3 Circles(Vector3 v)
    {
        string debugStr = "";

        debugStr += "v.x:" + v.x + "\t";
        debugStr += "v.z:" + v.z + "\t";

        Vector3 dir = new Vector3((v.x - CirclesCenterX * 10), 0, (v.z - CirclesCenterY * 10));

        debugStr += "length:" + Mathf.Sqrt(Mathf.Pow(dir.x, 2) + Mathf.Pow(dir.z, 2)) + "\t";
        float dist = Mathf.Sqrt(Mathf.Pow(dir.x, 2) + Mathf.Pow(dir.z, 2)) * CirclesSize;

        debugStr += "dist:" + dist / 10 + "\t";
        v = new Vector3((dist + CirclesCenterX * 10), 0, (dist + CirclesCenterY * 10));

        if (IsShowLog)
            Debug.Log(debugStr);

        return v;
    }


    void GlassTiles(Vector3 v)
    {
        string debugStr = "";
        if (IsShowLog && v.x == 0 && v.z == 0)
        {
            for (int i = 0; i <= 100; i++)
            {
                if (i % 10 == 0)
                    debugStr += "<color=red>";

                debugStr += "x:" + (float)i / 100 + "\t";
                debugStr += "in Tan x:" + ((Tiles * 2.5f) * (float)i / 100 + TilesOffset) + "\t";
                debugStr += "Tan x:" + Mathf.Tan((Tiles * 2.5f) * (float)i / 100 + TilesOffset) + "\t";
                debugStr += "BevelWidth x:" + Mathf.Tan((Tiles * 2.5f) * (float)i / 100 + TilesOffset) * (BevelWidth / 100) + "\t";
                debugStr += "End x:" + ((float)i / 100 + Mathf.Tan((Tiles * 2.5f) * (float)i / 100 + TilesOffset) * (BevelWidth / 100)) + "\n";

                if (i % 10 == 0)
                    debugStr += "</color>";
            }

            Debug.Log(debugStr);

        }
    }

    Vector3 MagnifySmooth(Vector3 v, int count)
    {
        StringBuilder debugStr = new StringBuilder();

        Vector3 centerToPixel = new Vector3((v.x - MagnifySmoothCenterX * 10), 0, (v.z - MagnifySmoothCenterY * 10));

        debugStr.Append("centerToPixel.x:" + centerToPixel.x + "\t");
        debugStr.Append("centerToPixel.z:" + centerToPixel.z + "\t");

        float dist = cgMath.length(centerToPixel.x / 10, centerToPixel.z / 10 / MagnifySmoothAspectRatio);
        float ratio = cgMath.smoothstep(InnerRadius, Mathf.Max(InnerRadius, OuterRadius), dist);

        debugStr.Append("dist:" + dist + "\t");


        debugStr.Append("in Lerp x:" + (centerToPixel.x / MagnificationAmount + MagnifySmoothCenterX * 10) + "\t");
        debugStr.Append("in Lerp z:" + (centerToPixel.z / MagnificationAmount + MagnifySmoothCenterY * 10) + "\t");
        debugStr.Append("v.x:" + v.x + "\t");
        debugStr.Append("v.z:" + v.z + "\t");
        debugStr.Append("ratio:" + ratio + "\t");

        centerToPixel.x = Mathf.Lerp(centerToPixel.x / MagnificationAmount + MagnifySmoothCenterX * 10, v.x, ratio);
        centerToPixel.z = Mathf.Lerp(centerToPixel.z / MagnificationAmount + MagnifySmoothCenterY * 10, v.z, ratio);
        centerToPixel.y = 0;



        debugStr.Append("centerToPixel.x:" + centerToPixel.x + "\t");
        debugStr.Append("centerToPixel.z:" + centerToPixel.z + "\t\n");

        if (ratio != 1)
        {
            debugStr.Insert(0, "<color=red>");
            debugStr.Append("</color>");
        }


        if (IsShowLog)
            Debug.Log(debugStr);


        return centerToPixel;
    }


    Vector3 Pinch(Vector3 v)
    {
        StringBuilder debugStr = new StringBuilder();

        Vector3 dir = new Vector3((PinchCenterX * 10 - v.x), 0, (PinchCenterY * 10 - v.z));

        debugStr.Append("dir.x:" + dir.x + "\t");
        debugStr.Append("dir.z:" + dir.z + "\t");


        Vector3 scaledDir = dir;
        scaledDir.y /= PinchAspectRatio * 10;
        float dist = cgMath.length(scaledDir.x / 10, scaledDir.z / 10);
        float range = cgMath.saturate(1 - (dist / (Mathf.Abs(Mathf.Sin(PinchRadius * 8) * PinchRadius) + 0.00000001F)));

        debugStr.Append("Abs Sin:" + (Mathf.Abs(Mathf.Sin(PinchRadius * 8) * PinchRadius) + "\t"));
        debugStr.Append("dist:" + dist + "\t");
        debugStr.Append("dist / :" + (dist / (Mathf.Abs(Mathf.Sin(PinchRadius * 8) * PinchRadius + 0.00000001F))) + "\t");
        debugStr.Append("range:" + range + "\t");

        Vector3 samplePoint = new Vector3(v.x + dir.x * range * PinchStrength, 0, v.z + dir.z * range * PinchStrength);

        debugStr.Append("samplePoint.x:" + samplePoint.x + "\t");
        debugStr.Append("samplePoint.z:" + samplePoint.z + "\t");

        if (range != 0)
        {
            debugStr.Insert(0, "<color=red>");
            debugStr.Append("</color>");
        }

        if (IsShowLog)
            Debug.Log(debugStr);

        return samplePoint;
    }
    #endregion

}
