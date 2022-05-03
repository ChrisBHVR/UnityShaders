using UnityEngine;

[ExecuteInEditMode]
public class Scene70RenderImage : MonoBehaviour
{
    private static readonly int Tint = Shader.PropertyToID("_Tint");
    private static readonly int Scanlines = Shader.PropertyToID("_Scanlines");

    [SerializeField]
    private Shader curShader;
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
