Shader "NiksShaders/Shader29Unlit"
{
    Properties
    {
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            float random(float2 pos)
            {
                const float a = 12.9898;
                const float b = 78.233;
                const float c = 43758.543123;
                return frac(sin(dot(pos, float2(a, b))) * c);
            }

            // 2D Noise based on Morgan McGuire @morgan3d
            // https://www.shadertoy.com/view/4dS3Wd
            float noise(float2 st)
            {
                float2 i = floor(st);
                float2 f = frac(st);

                // Four corners in 2D of a tile
                float a = random(i);
                float b = random(i + float2(1, 0));
                float c = random(i + float2(0, 1));
                float d = random(i + float2(1, 1));

                // Smooth Interpolation

                // Cubic Hermine Curve.  Same as SmoothStep()
                float2 u = f * f * (3 - (2 * f));
                // u = smoothstep(0, 1, f);

                // Mix 4 coorners percentages
                return lerp(a, b, u.x)
                     + ((c - a) * u.y * (1 - u.x))
                     + ((d - b) * u.x * u.y);
            }

            fixed4 frag(v2f_img i) : SV_Target
            {
                // Scale the coordinate system to see some noise in action
                float2 pos = i.uv * 8;

                // Use the noise function
                float n = noise(pos);
                n = smoothstep(0.4, 0.6, n);
                fixed3 colour = n * fixed3(1, 1, 1);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
