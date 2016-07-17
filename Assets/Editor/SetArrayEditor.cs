using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SetArray))]
public class SetArrayEditor : Editor
{
    private SerializedObject m_Object;
    private SerializedProperty m_Property;

    void OnEnable()
    {
        m_Object = new SerializedObject(target);
    }

    public override void OnInspectorGUI()
    {
        SetArray SA = (SetArray)target;

        //public int rowCount = 5;
        //public GameObject[] go;

        SA.rowCount = EditorGUILayout.IntField("Row Count", SA.rowCount);

        if (GUILayout.Button("StartSort"))
        {
            SA.StartSort();
        }

        GUILayout.Space(10);

        m_Property = m_Object.FindProperty("go");
        EditorGUILayout.PropertyField(m_Property, new GUIContent("Object"), true);
        m_Object.ApplyModifiedProperties();

        
    }

}
