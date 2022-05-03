using UnityEngine;

public class SmoothFollowTarget : MonoBehaviour
{
    [SerializeField]
    private GameObject target;
    [SerializeField]
    private float[] limitsX;
    private Vector3 offset;
    private bool b;

    private void LateUpdate()
    {
        if (!this.target)
        {
            this.target = GameObject.FindGameObjectWithTag("Player");
            return;
        }

        if (!this.b)
        {
            this.offset = this.transform.position - this.target.transform.position;
            this.b = true;
        }

        Vector3 pos = this.target.transform.position + this.offset;
        if (this.limitsX is { Length: 2 })
        {
            pos.x = Mathf.Clamp(pos.x, this.limitsX[0], this.limitsX[1]);
            //Debug.Log("pos.x clamped to " + pos.x);
        }

        this.transform.position = Vector3.Lerp(this.transform.position, pos, Time.deltaTime * 5f);
        this.transform.LookAt(this.target.transform);
    }
}
