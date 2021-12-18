using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderRenderer : MonoBehaviour
{

    [Range(1, 3000)]
    public int iterations = 800;

    [Range(1, 60000)]
    public int scaling = 1;

    [Range(1, 100000)]
    public int timeSpeed = 1;

    public float xOff = 3705f;

    public float yOff = 1600f;

    public bool zoomIn = true;

    private new Renderer renderer;
    // Start is called before the first frame update
    void Start()
    {
        renderer = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        renderer.material.SetInt("_Iterations", iterations);
        renderer.material.SetInt("_Scaling", scaling);
        renderer.material.SetInt("_TimeSpeed", timeSpeed);
        renderer.material.SetFloat("_XOff", xOff);
        renderer.material.SetFloat("_YOff", yOff);
        renderer.material.SetFloat("_ZoomIn", zoomIn ? 1f : 0f);
    }
}
