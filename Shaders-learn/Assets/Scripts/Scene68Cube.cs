using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class Scene68Cube : MonoBehaviour
{
    private static readonly int Center = Shader.PropertyToID("_Center");

    private Material material;
    private Vector4 center;
    private float startY;

    private void Start()
    {
        this.material = GetComponent<Renderer>().material;
        this.startY   = this.transform.position.y;
    }

    private void Update()
    {
        Vector3 pos = this.transform.position;
        pos.y       = this.startY + (Mathf.Sin(Time.time * 3f) * 0.2f);
        this.transform.position = pos;
        this.center             = pos;
        this.material.SetVector(Center, this.center);
        //Debug.Log(mouse);
    }
}
