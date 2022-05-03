using UnityEngine;

namespace ShadersLearn
{
    [RequireComponent(typeof(Renderer))]
    public class Scene67Cube : MonoBehaviour
    {
        private static readonly int Center = Shader.PropertyToID("_Center");

        private Material material;
        private Vector4 center;
        private float startY;

        private void Start()
        {
            Renderer rend = GetComponent<Renderer>();
            this.material = rend.material;
            this.startY   = this.transform.position.y;
        }

        private void Update()
        {
            // ReSharper disable once LocalVariableHidesMember
            Transform transform = this.transform;
            transform.Rotate(0f, 0.4f, 0f);
            Vector3 pos = transform.position;
            pos.y       = this.startY + (Mathf.Sin(Time.time * 3f) * 0.2f);
            transform.position = pos;
            this.center        = pos;
            this.material.SetVector(Center, this.center);
            //Debug.Log(mouse);
        }
    }
}
