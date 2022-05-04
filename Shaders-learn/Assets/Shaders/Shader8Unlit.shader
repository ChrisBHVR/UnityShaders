Shader "NiksShaders/Shader8Unlit"
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

            float rect(float2 pos, float2 size, float2 center)
            {
                pos  -= center;
                size /= 2;
                float2 test = step(-size, pos) - step(size, pos);
                return test.x * test.y;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float inLeftRect  = rect(i.position.xy, 0.3, float2(-0.25, 0));
                float inRightRect = rect(i.position.xy, 0.4, float2(0.25, 0));
                fixed3 colour = (fixed3(1, 1, 0) * inLeftRect) + (fixed3(0, 1, 0) * inRightRect);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
