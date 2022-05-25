using UnityEngine;

namespace ShadersLearn
{
    [ExecuteInEditMode]
    public class Scene70aRenderImage : MonoBehaviour
    {
        private static readonly int Tint           = Shader.PropertyToID("_Tint");
        private static readonly int TintColour     = Shader.PropertyToID("_TintColour");
        private static readonly int Scanlines      = Shader.PropertyToID("_Scanlines");
        private static readonly int ScanlineColour = Shader.PropertyToID("_ScanlineColour");

        [SerializeField]
        private Shader shader;
        [SerializeField, Range(0f, 1f)]
        private float tint = 1f;
        [SerializeField]
        private Color tintColour = new(0.6f, 1f, 0.6f);
        [SerializeField, Range(50, 150)]
        private int scanlines = 100;
        [SerializeField]
        private Color scanlineColour;

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

        private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
        {
            if (this.shader)
            {
                this.ScreenMaterial.SetFloat(Tint, this.tint);
                this.ScreenMaterial.SetColor(TintColour, this.tintColour);
                this.ScreenMaterial.SetFloat(Scanlines, this.scanlines);
                this.ScreenMaterial.SetColor(ScanlineColour, this.scanlineColour);
                Graphics.Blit(sourceTexture, destTexture, this.ScreenMaterial);
            }
            else
            {
                Graphics.Blit(sourceTexture, destTexture);
            }
        }

        private void Update()
        {
            this.tint = Mathf.Clamp01(this.tint);
        }

        private void OnDisable()
        {
            if (this.screenMaterial)
            {
                DestroyImmediate(this.screenMaterial);
            }
        }
    }
}
