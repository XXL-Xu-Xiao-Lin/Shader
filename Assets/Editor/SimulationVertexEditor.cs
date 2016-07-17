using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof(SimulationVertex))]
public class SimulationVertexEditor : Editor
{

    public override void OnInspectorGUI()
    {
        SimulationVertex SV = (SimulationVertex)target;

        SV.IsShowLog = EditorGUILayout.Toggle("Is Show Log", SV.IsShowLog);
        SV.ElementBlue = EditorGUILayout.ObjectField("ElementBlue", SV.ElementBlue, typeof(GameObject), true) as GameObject;
        SV.ElementRed = EditorGUILayout.ObjectField("ElementRed", SV.ElementRed, typeof(GameObject), true) as GameObject;
        SV.rowCount = EditorGUILayout.IntField("Row Count", SV.rowCount);
        SV.shaderType = (SimulationVertex.ShaderType)EditorGUILayout.EnumPopup("ElementRed", SV.shaderType);

        SV.coordPosX = EditorGUILayout.Slider("Coord Pos X", SV.coordPosX, -1, 1, null);
        SV.coordPosY = EditorGUILayout.Slider("Coord Pos Y", SV.coordPosY, -1, 1, null);

        GUILayout.Space(10);

        //動態控制UI
        switch (SV.shaderType)
        {
            case SimulationVertex.ShaderType.Standard:
                GUILayout.Space(-10);
                SV.coordScaleX = EditorGUILayout.Slider("Coord Scale X", SV.coordScaleX, 0, 2, null);
                SV.coordScaleY = EditorGUILayout.Slider("Coord Scale Y", SV.coordScaleY, 0, 2, null);
                break;
            case SimulationVertex.ShaderType.TelescopicBlurPS3:
                addDividers();
                SV.isOffsetCoordSync = EditorGUILayout.Toggle("Is Offset Coord Sync", SV.isOffsetCoordSync);
                SV.offsetCoordPosX = EditorGUILayout.Slider("Offset Coord Pos X", SV.offsetCoordPosX, -1, 1, null);
                SV.offsetCoordPosY = EditorGUILayout.Slider("Offset Coord Pos Y", SV.offsetCoordPosY, -1, 1, null);
                break;
            case SimulationVertex.ShaderType.LightStreak:
                addDividers();
                SV.DirectionX = EditorGUILayout.Slider("Direction X", SV.DirectionX, -1, 1, null);
                SV.DirectionY = EditorGUILayout.Slider("Direction Y", SV.DirectionY, -1, 1, null);
                SV.InputSizeX = EditorGUILayout.Slider("Input Size X", SV.InputSizeX, 1, 100, null);
                SV.InputSizeY = EditorGUILayout.Slider("Input Size Y", SV.InputSizeY, 1, 100, null);
                break;
            case SimulationVertex.ShaderType.BandedSwirl:
                addDividers();
                SV.CenterX = EditorGUILayout.Slider("Center X", SV.CenterX, 0, 1, null);
                SV.CenterY = EditorGUILayout.Slider("Center Y", SV.CenterY, 0, 1, null);
                SV.BandCount = EditorGUILayout.Slider("Bands", SV.BandCount, 0, 20, null);
                SV.Strength = EditorGUILayout.Slider("Strength", SV.Strength, 0, 1, null);
                SV.AspectRatio = EditorGUILayout.Slider("Aspect Ratio", SV.AspectRatio, 0.5f, 2, null);
                break;
            case SimulationVertex.ShaderType.Bands:
                addDividers();
                SV.BandDensity = EditorGUILayout.Slider("Band Density", SV.BandDensity, 0, 150, null);
                SV.BandIntensity = EditorGUILayout.Slider("Band Intensity", SV.BandIntensity, 0, 1, null);
                SV.IsRightSideBand = EditorGUILayout.Slider("Is RightSideBand", SV.IsRightSideBand, 0, 1, null);
                break;
            case SimulationVertex.ShaderType.Circles:
                addDividers();
                SV.CirclesCenterX = EditorGUILayout.Slider("Center X", SV.CirclesCenterX, 0, 1, null);
                SV.CirclesCenterY = EditorGUILayout.Slider("Center Y", SV.CirclesCenterY, 0, 1, null);
                SV.CirclesSize = EditorGUILayout.Slider("Circles Size", SV.CirclesSize, 0, 4, null);
                break;
            case SimulationVertex.ShaderType.GlassTiles:
                addDividers();
                SV.Tiles = EditorGUILayout.Slider("Tiles", SV.Tiles, 0, 20, null);
                SV.BevelWidth = EditorGUILayout.Slider("BevelWidth", SV.BevelWidth, 0, 10, null);
                SV.TilesOffset = EditorGUILayout.Slider("TilesOffset", SV.TilesOffset, 0, 3, null);
                break;
            case SimulationVertex.ShaderType.MagnifySmooth:
                SV.MagnifySmoothCenterX = EditorGUILayout.Slider("Center X", SV.MagnifySmoothCenterX, 0, 1, null);
                SV.MagnifySmoothCenterY = EditorGUILayout.Slider("Center Y", SV.MagnifySmoothCenterY, 0, 1, null);
                SV.InnerRadius = EditorGUILayout.Slider("Inner Radius", SV.InnerRadius, 0, 1, null);
                SV.OuterRadius = EditorGUILayout.Slider("Outer Radius", SV.OuterRadius, 0, 1, null);
                SV.MagnificationAmount = EditorGUILayout.Slider("Magnification Amount", SV.MagnificationAmount, 1, 5, null);
                SV.MagnifySmoothAspectRatio = EditorGUILayout.Slider("AspectRatio", SV.MagnifySmoothAspectRatio, 0.5f, 2, null);
                break;
            case SimulationVertex.ShaderType.Pinch:
                SV.PinchCenterX = EditorGUILayout.Slider("Center X", SV.PinchCenterX, 0, 1, null);
                SV.PinchCenterY = EditorGUILayout.Slider("Center Y", SV.PinchCenterY, 0, 1, null);
                SV.PinchRadius = EditorGUILayout.Slider("Radius", SV.PinchRadius, 0, 1, null);
                SV.PinchStrength = EditorGUILayout.Slider("Strength", SV.PinchStrength, 0, 2, null);
                SV.PinchAspectRatio = EditorGUILayout.Slider("AspectRatio", SV.PinchAspectRatio, 0.5f, 2, null);
                break;
        }

        GUILayout.Space(10);
        SV.isContinueUpdate = EditorGUILayout.Toggle("Is Continue Update", SV.isContinueUpdate);

        if (SV.isContinueUpdate)
            SV.CreateElement();

        GUILayout.BeginHorizontal();
        if (GUILayout.Button("CreateElement"))
        {
            SV.CreateElement();
        }

        if (GUILayout.Button("ClearElement"))
        {
            SV.ClearElement();
        }
        GUILayout.EndHorizontal();
    }

    void addDividers()
    {
        GUILayout.Label("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    }
}
