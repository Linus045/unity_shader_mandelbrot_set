using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderRenderer : MonoBehaviour
{

    [Range(1, 3000)]
    public float iterations = 800;

    [Range(1, 60000)]
    public float scaling = 1;

    [Range(1, 100000)]
    public float timeSpeed = 1;

    public float xOff = 3705f;

    public float yOff = 1600f;

    public bool zoomIn = true;

    public float moveSpeed = 5f;

    private new Renderer renderer;
    // Start is called before the first frame update
    void Start()
    {
        renderer = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        float vert = Input.GetAxis("Vertical");
        float horz = Input.GetAxis("Horizontal");
        if (vert != 0)
            yOff += moveSpeed * vert * Time.deltaTime;

        if (horz != 0)
            xOff += moveSpeed * horz * Time.deltaTime;

        if (Input.GetButton("Jump"))
            scaling += moveSpeed * Time.deltaTime;

        if (Input.GetButton("Sprint"))
            scaling += -moveSpeed * Time.deltaTime;

        renderer.material.SetFloat("_Iterations", iterations);
        renderer.material.SetFloat("_Scaling", scaling);
        renderer.material.SetFloat("_TimeSpeed", timeSpeed);
        renderer.material.SetFloat("_XOff", xOff);
        renderer.material.SetFloat("_YOff", yOff);
        renderer.material.SetFloat("_ZoomIn", zoomIn ? 1f : 0f);
    }
}
