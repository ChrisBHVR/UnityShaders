using JetBrains.Annotations;
using UnityEngine;

namespace ShadersLearn
{
    [ExecuteInEditMode]
    public class Scene69RenderImage : MonoBehaviour
    {
        private static readonly int TintColour = Shader.PropertyToID("_TintColour");

        [SerializeField]
        private Shader shader;
        [SerializeField]
        private Color tintColour = Color.white;

        private Material screenMaterial;
        private Material ScreenMaterial
        {
            get
            {
                if (!this.screenMaterial)
                {
                    this.screenMaterial = new(this.shader)
                    {
                        hideFlags = HideFlags.HideAndDontSave
                    };
                    this.ScreenMaterial.SetColor(TintColour, this.tintColour);
                }

                return this.screenMaterial;
            }
        }

        private void Start()
        {
            if (!this.shader || !this.shader.isSupported)
            {
                this.enabled = false;
            }
        }

        private void OnDisable()
        {
            if (this.screenMaterial)
            {
                DestroyImmediate(this.screenMaterial);
            }
        }

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (this.shader)
            {
                this.ScreenMaterial.SetColor(TintColour, this.tintColour);
                Graphics.Blit(source, destination, this.ScreenMaterial);
            }
            else
            {
                Graphics.Blit(source, destination);
            }
        }
    }
}
