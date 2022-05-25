﻿using UnityEngine;

namespace ShadersLearn
{
    [RequireComponent(typeof(Renderer))]
    public class Scene67Cube : MonoBehaviour
    {
        private static readonly int Center = Shader.PropertyToID("_Center");

        private Material material;
        private float startY;

        private void Awake()
        {
            this.material = GetComponent<Renderer>().material;
            this.startY   = this.transform.position.y;
        }

        private void Update()
        {
            // ReSharper disable once LocalVariableHidesMember
            Transform transform = this.transform;
            transform.Rotate(0f, 0.4f, 0f);
            Vector3 position   = transform.position;
            position.y         = this.startY + (Mathf.Sin(Time.time * 3f) * 0.2f);
            transform.position = position;
            this.material.SetVector(Center, position);
        }
    }
}
