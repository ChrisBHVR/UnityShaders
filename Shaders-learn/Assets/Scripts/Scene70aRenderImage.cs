using UnityEngine;

// ReSharper disable once InconsistentNaming
namespace ShadersLearn
{
    [ExecuteInEditMode]
    public class Scene70aRenderImage : MonoBehaviour
    {
        private static readonly int Tint = Shader.PropertyToID("_Tint");
        private static readonly int Scanlines = Shader.PropertyToID("_Scanlines");
        private static readonly int ScanlineColor = Shader.PropertyToID("_ScanlineColor");

        [SerializeField]
        private Shader curShader;
        [SerializeField]
        private Color scanlineColor;
        [SerializeField]
        private float tint = 1f;
        [SerializeField]
        private int scanlines = 100;
        private Material screenMat;

        private Material ScreenMaterial
        {
            get
            {
                if (!this.screenMat)
                {
                    this.screenMat = new(this.curShader)
                    {
                        hideFlags = HideFlags.HideAndDontSave
                    };
                }

                return this.screenMat;
            }
        }

        private void Start()
        {
            if (!this.curShader || !this.curShader.isSupported)
            {
                this.enabled = false;
            }
        }

        private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
        {
            if (this.curShader)
            {
                this.ScreenMaterial.SetFloat(Tint, this.tint);
                this.ScreenMaterial.SetFloat(Scanlines, this.scanlines);
                this.ScreenMaterial.SetColor(ScanlineColor, this.scanlineColor);
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
            if (this.screenMat)
            {
                DestroyImmediate(this.screenMat);
            }
        }
    }
}
