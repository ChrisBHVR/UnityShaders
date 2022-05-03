using UnityEngine;

public class TrackMouse : MonoBehaviour
{
    private static readonly int Mouse = Shader.PropertyToID("_Mouse");

    private Material material;
    private Vector4 mouse;
    private new Camera camera;

    private void Start()
    {
        Renderer rend = GetComponent<Renderer>();
        this.material = rend.material;
        this.mouse    = new(0f, 0f, Screen.height, Screen.width);
        this.camera   = Camera.main;
    }

    private void Update()
    {
        this.material.SetVector(Mouse, this.mouse);
    }
}
