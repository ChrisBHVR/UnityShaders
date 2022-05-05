Shader "NiksShaders/Shader37Unlit"
{
    Properties
    {
        [MaterialToggle] _MarbleOn("Marble On", Int) = 1
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

            #include "UnityCG.cginc"
            #include "noiseSimplex.cginc"

            bool _MarbleOn;

            struct v2f
            {
                float4 vertex:   SV_POSITION;
                float4 position: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                return output;
            }

            float4 frag(v2f i) : COLOR
            {
                float2 p = i.position.xy * 2;
                float scale = 800;
                fixed3 colour;
                float noise;

                p *= scale;

                if (_MarbleOn)
                {
                    float d = perlin(p.x, p.y) * scale;
                    float u = p.x + d;
                    float v = p.y + d;
                    d = perlin(u, v) * scale;
                    noise = perlin(p.x + d, p.y + d);
                    colour = fixed3(0.6 * ((fixed3(2, 2, 2) * noise)
                                         - fixed3(noise * 0.1,
                                                  (noise * 0.2) - (sin(u / 30) * 0.1),
                                                  (noise * 0.3) + (sin(v / 40) * 0.2))));
                }
                else
                {
                    noise = perlin(p.x, p.y);
                    colour = fixed3(1, 1, 1) * noise;
                }

                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

