Shader "NiksShaders/Shader31Unlit"
{
    Properties
    {
        _ColourA("Colour A", Color) = (1, 0, 0, 1)
        _ColourB("Colour B", Color) = (1, 1, 0, 1)
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

            fixed4 _ColourA;
            fixed4 _ColourB;

            float random (float2 pos)
            {
                const float a = 12.9898;
                const float b = 78.233;
                const float c = 43758.543123;
                return frac(sin(dot(pos, float2(a, b))) * c );
            }

            // 2D Noise based on Morgan McGuire @morgan3d
            // https://www.shadertoy.com/view/4dS3Wd
            float noise (float2 st)
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

            fixed4 frag (v2f_img i) : SV_Target
            {
                float2 n = 0;
                float2 pos;
                //Generate noise x value
                pos  = float2((i.uv.x * 1.4) + 0.01, i.uv.y - (_Time.y * 0.69));
                n.x += noise(pos * 12);
                pos  = float2((i.uv.x * 0.5) - 0.033, (i.uv.y * 2) - (_Time.y * 0.12));
                n.x += noise(pos * 8);
                pos  = float2((i.uv.x * 0.94) + 0.02, (i.uv.y * 3) - (_Time.y * 0.61));
                n.x += noise(pos * 4);

                // Generate noise y value
                pos  = float2((i.uv.x * 0.7) - 0.01, i.uv.y - (_Time.y * 0.27));
                n.y += noise(pos * 12);
                pos  = float2((i.uv.x * 0.45) + 0.033, (i.uv.y * 1.9) - (_Time.y * 0.61));
                n.y += noise(pos * 8);
                pos  = float2((i.uv.x * 0.8) - 0.02, (i.uv.y * 2.5) - (_Time.y * 0.51));
                n.y += noise(pos * 4);

                n /= 2.3;

                fixed3 color = lerp(_ColourA.rgb, _ColourB.rgb, n.y * n.x);
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
}
