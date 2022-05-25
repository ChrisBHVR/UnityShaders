using UnityEngine;

namespace ShadersLearn
{
    public class SmoothFollowTarget : MonoBehaviour
    {
        [SerializeField]
        private GameObject target;
        [SerializeField]
        private Vector2 limitsX = new(float.NegativeInfinity, float.PositiveInfinity);

        private Vector3? offset;

        private void LateUpdate()
        {
            if (!this.target)
            {
                this.target = GameObject.FindGameObjectWithTag("Player");
                if (!this.target) return;
            }

            // ReSharper disable once LocalVariableHidesMember
            Transform transform = this.transform;
            Vector3 targetPosition = this.target.transform.position;
            this.offset ??= transform.position - targetPosition;

            Vector3 pos = targetPosition + this.offset.Value;
            pos.x = Mathf.Clamp(pos.x, this.limitsX[0], this.limitsX[1]);
            this.transform.position = Vector3.Lerp(this.transform.position, pos, Time.deltaTime * 5f);
            this.transform.LookAt(this.target.transform);
        }
    }
}
