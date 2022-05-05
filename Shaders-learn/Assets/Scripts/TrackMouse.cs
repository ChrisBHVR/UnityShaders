using UnityEngine;

namespace ShadersLearn
{
    [RequireComponent(typeof(Renderer))]
    public class TrackMouse : MonoBehaviour
    {
        private static readonly int Mouse = Shader.PropertyToID("_Mouse");

        private Material material;
        private new Camera camera;

        private Vector2 mousePosition;
        private Vector2 MousePosition
        {
            get => this.mousePosition;
            set
            {
                if (this.MousePosition == value) return;

                this.mousePosition = value;
                this.material.SetVector(Mouse, new(value.x, value.y, Screen.height, Screen.width));
            }
        }

        private void Start()
        {
            this.material = GetComponent<Renderer>().material;
            this.camera   = Camera.main;
        }

        private void Update()
        {
            if (Physics.Raycast(this.camera.ScreenPointToRay(Input.mousePosition), out RaycastHit hit))
            {
                this.MousePosition = hit.textureCoord;
            }
        }
    }
}
