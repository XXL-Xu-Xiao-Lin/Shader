using UnityEngine;
using System.Collections;
using UnityEditor;
[InitializeOnLoad]
public class HierarchQuickSetActive
{

    static HierarchQuickSetActive()
    {
        EditorApplication.hierarchyWindowItemOnGUI += hierarchWindowOnGUI;
    }

    static void hierarchWindowOnGUI(int instanceID, Rect selectionRect)
    {
        // make rectangle
        Rect r = new Rect(selectionRect);
        r.x = r.width - 10;
        r.width = 18;

        // get objects
        Object o = EditorUtility.InstanceIDToObject(instanceID);
        GameObject g = (GameObject)o as GameObject;

        // drag toggle gui
        if (g != null)
            g.SetActive(GUI.Toggle(r, g.activeSelf, string.Empty));
    }
}