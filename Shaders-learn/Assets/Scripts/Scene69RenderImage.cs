using UnityEngine;

namespace ShadersLearn
{
    [ExecuteInEditMode]
    public class Scene69RenderImage : MonoBehaviour
    {
        [SerializeField]
        private Shader curShader;
        [SerializeField]
        private Color tintColor = Color.white;
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

        private void OnDisable()
        {
            if (this.screenMat)
            {
                DestroyImmediate(this.screenMat);
            }
        }
    }
}
