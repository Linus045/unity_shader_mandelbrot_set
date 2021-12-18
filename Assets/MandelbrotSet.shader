Shader "Unlit/MandelbrotSet"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Iterations ("Iterations", Int) = 1
        _Scaling ("Scaling", Int) = 1
        _TimeSpeed("TimeSpeed", Int) = 1
        _XOff("X Offset", Int) = 1
        _YOff("Y Offset", Int) = 1
        _ZoomIn ("Zoom In", Float) = 1.
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            #define INF 2.

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Iterations;
            float _Scaling;
            float _TimeSpeed;
            float _XOff;
            float _YOff;
            float _ZoomIn;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


            float2 addComplex(float2 a, float2 b)
            {
                return float2(a.x + b.x, a.y + b.y);
            }

            float2 multComplex(float2 a, float2 b)
            {
                return float2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
            }

            float mandelbrot(float2 x, int n)
            {
                float2 z = float2(.0, .0);
                for (int i = 0; i < n; i++)
                {
                    if (abs(z.x) > INF)
                    {
                        return float(i) / float(n);
                    }
                    else
                    {
                        z = multComplex(z, z);
                        z = addComplex(z, x);
                    }
                }
                return z.x / INF;
            }



            // Official HSV to RGB conversion
            float3 hsv2rgb(in float3 c)
            {
                float3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
                return c.z * lerp(float3(1., 1., 1.), rgb, c.y);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Normalized pixel coordinates (from -0.5 to 0.5)
                float2 uv = i.uv - float2(0.5, 0.5);
                int iterations = _Iterations;

                float xShift = _XOff * 0.0001;
                float yShift = _YOff * 0.0001;
                float iFrame = _ZoomIn * _Time.y / _TimeSpeed + 1;
                float2 scaling = float2(float(iFrame), float(iFrame)) * _Scaling;
                float2 pos = uv.xy + float2(xShift, yShift) * scaling;

                float m = mandelbrot(pos / scaling, iterations);
                float3 col = float3(hsv2rgb(float3(m, 1., 1.)));
                // Output to screen
                return float4(col,1.0);
            }
            ENDCG
        }
    }
}
