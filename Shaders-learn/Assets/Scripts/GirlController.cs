using UnityEngine;
using UnityEngine.AI;

namespace ShadersLearn
{
    [RequireComponent(typeof(Animator), typeof (NavMeshAgent))]
    public class GirlController : MonoBehaviour
    {
        private static readonly int Position = Shader.PropertyToID("_Position");
        private static readonly int Speed    = Animator.StringToHash("speed");

        [SerializeField]
        private Material material;
        private Animator anim;
        private Camera cam;
        private NavMeshAgent agent;
        private Vector2 smoothDeltaPosition;
        private Vector2 velocity;

        private void Start()
        {
            this.anim     = GetComponent<Animator>();
            this.agent    = GetComponent<NavMeshAgent>();
            this.cam      = Camera.main;
            // Don’t update position automatically
            this.agent.updatePosition = false;

            FindAndSelectMaterial();
        }

        private void FindAndSelectMaterial()
        {
            GameObject go = GameObject.Find("Plane");
            if (!go || !this.material) return;

            Vector3 position = this.transform.position;
            Vector4 pos      = new(position.x, position.y, position.z, Time.time);
            this.material.SetVector(Position, pos);
        }

        private void Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                Ray ray = this.cam.ScreenPointToRay(Input.mousePosition);
                if (Physics.Raycast(ray, out RaycastHit hit))
                {
                    this.agent.destination = hit.point;
                    if (this.material)
                    {
                        Vector4 pos = new (hit.point.x, hit.point.y, hit.point.z, Time.time);
                        this.material.SetVector(Position, pos);
                    }
                }
            }

            // ReSharper disable once LocalVariableHidesMember
            Transform transform = this.transform;
            Vector3 worldDeltaPosition = this.agent.nextPosition - transform.position;

            // Map 'worldDeltaPosition' to local space
            float dx = Vector3.Dot(transform.right,   worldDeltaPosition);
            float dy = Vector3.Dot(transform.forward, worldDeltaPosition);
            Vector2 deltaPosition = new(dx, dy);

            // Low-pass filter the deltaMove
            float smooth = Mathf.Min(1f, Time.deltaTime / 0.15f);
            this.smoothDeltaPosition = Vector2.Lerp(this.smoothDeltaPosition, deltaPosition, smooth);

            // Update velocity if time advances
            if (Time.deltaTime > 1E-5f)
            {
                this.velocity = this.smoothDeltaPosition / Time.deltaTime;
            }

            float speed     = this.velocity.magnitude;
            bool shouldMove = speed > 0.5f; // && agent.remainingDistance > agent.radius;

            // Update animation parameters
            this.anim.SetFloat(Speed, speed);

            //GetComponent<LookAt>().lookAtTargetPosition = agent.steeringTarget + transform.forward;
        }

        private void OnAnimatorMove()
        {
            // Update position to agent position
            this.transform.position = this.agent.nextPosition;
        }
    }
}
