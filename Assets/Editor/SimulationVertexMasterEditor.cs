using UnityEngine;
using System.Collections;
using UnityEditor;

public class SimulationVertexMasterEditor : EditorWindow
{
    [MenuItem("Window/SimulationVertex")]
    static void AddWindow()
    {
        SimulationVertexMasterEditor window = (SimulationVertexMasterEditor)EditorWindow.GetWindow(typeof(SimulationVertexMasterEditor), false, "Simulation Vertex", false);
        window.position = new Rect(100, 100, 500, 500);
    }

    private Texture texture;
    public Rect windowRect = new Rect(100, 100, 200, 200);

    void OnGUI()
    {
        GUILayout.BeginVertical("box");
        GUILayout.Label("Add Background Texture:");
        texture = EditorGUILayout.ObjectField(texture, typeof(Texture), true) as Texture;

        GUILayout.Space(10);

        GUILayout.BeginVertical("box");

        GUILayout.Label(texture, GUILayout.Width(100), GUILayout.Height(40));
        GUILayout.Button("Hi");
        GUILayout.Button("Hi");
        GUILayout.EndVertical();



        GUILayout.EndVertical();

    }

    void DoWindow()
    {
        GUILayout.Button("Hi");
        GUI.DragWindow();
    }
}
