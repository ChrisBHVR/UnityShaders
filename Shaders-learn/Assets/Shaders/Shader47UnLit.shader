Shader "NiksShaders/Shader47Unlit"
{
    Properties
    {
        _Scale("Scale", Range(0.1, 3)) = 0.3
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

            float _Scale;

            struct v2f
            {
                float4 pos:   SV_POSITION;
                float2 uv:    TEXCOORD0;
                float4 noise: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.noise       = float4(-turbulence(v.normal / 2), 0, 0, 0);
                float b            = (_Scale / 2) * pnoise(v.vertex / 20, 100);
                float displacement = b - (_Scale * output.noise.x);
                float3 pos = v.vertex + (v.normal * displacement);
                output.pos = UnityObjectToClipPos(pos);
                output.uv  = v.texcoord;
                return output;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 colour = fixed3(i.uv * (1 - (2 * i.noise.x)), 0);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

