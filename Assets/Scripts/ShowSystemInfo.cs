using UnityEngine;

public class ShowSystemInfo : MonoBehaviour
{
    string systemInfoLabel;
    private Rect rect = new Rect(10, 10, 1000, 300);

    void OnGUI()
    {
        GUI.Label(rect, systemInfoLabel);
    }

    void Update()
    {
        systemInfoLabel = " CPU型號：" + SystemInfo.processorType
                                + "\n (" + SystemInfo.processorCount + " cores核心, " + SystemInfo.systemMemorySize + "MB RAM)\n "
                                + "\n 顯卡型號：" + SystemInfo.graphicsDeviceName
                                + "\n " + Screen.width + "x" + Screen.height + " @" + Screen.currentResolution.refreshRate +
                                " (" + SystemInfo.graphicsMemorySize + "MB VRAM)";
    }
}