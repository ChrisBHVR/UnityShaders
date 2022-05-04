Shader "NiksShaders/Shader6Unlit"
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
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex:   SV_POSITION;
                float4 position: TEXCOORD1;
                float2 uv:       TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                output.uv       = v.texcoord;
                return output;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 colour = i.position * 2;
                colour.r = smoothstep(-0.1, 0.1, colour.r);
                colour.g = smoothstep(-0.1, 0.1, colour.g);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
