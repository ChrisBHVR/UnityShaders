using UnityEngine;

namespace ShadersLearn
{
    public class RevealController : MonoBehaviour
    {
        private static readonly int RevealTime = Shader.PropertyToID("_RevealTime");

        [SerializeField]
        private Material material;
        private float revealTime;

        private void Update()
        {
            if (this.material)
            {
                this.material.SetFloat(RevealTime, Time.time - this.revealTime);
            }
        }

        public void RevealClicked()
        {
            this.revealTime = Time.time;
        }
    }
}
