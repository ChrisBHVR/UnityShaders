using UnityEngine;

namespace ShadersLearn
{
    public class UIHandler : MonoBehaviour
    {
        private static readonly int TextureA  = Shader.PropertyToID("_TextureA");
        private static readonly int TextureB  = Shader.PropertyToID("_TextureB");
        private static readonly int StartTime = Shader.PropertyToID("_StartTime");

        [SerializeField]
        private MeshRenderer quad;
        [SerializeField]
        private Texture[] images;
        private int index;

        private void Start()
        {
            if (!this.quad) return;

            this.quad.material.SetFloat(StartTime, -100f);
        }

        public void NextClicked()
        {
            if (!this.quad) return;

            int previous = this.index;
            this.index = (this.index + 1) % this.images.Length;
            this.quad.material.SetTexture(TextureA, this.images[previous]);
            this.quad.material.SetTexture(TextureB, this.images[this.index]);
            this.quad.material.SetFloat(StartTime, Time.time);
        }
    }
}
