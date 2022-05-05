Shader "NiksShaders/Shader18Unlit"
{
    Properties
    {
        _AxisColour("Axis Colour", Color)   = (0.8, 0.8, 0.8, 1)
        _SweepColour("Sweep Colour", Color) = (0.1, 0.3, 1, 1)
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

            fixed4 _AxisColour;
            fixed4 _SweepColour;

            struct v2f
            {
                float4 vertex:   SV_POSITION;
                float4 position: TEXCOORD1;
                float2 uv:       TEXCOORD0;
            };

            v2f vert (appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                output.uv       = v.texcoord;
                return output;
            }

            float onLine(float x, float y, float lineWidth, float smoothing)
            {
                float halfLineWidth = lineWidth / 2;
                float edge = halfLineWidth * smoothing;
                return smoothstep(x - halfLineWidth - edge, x - halfLineWidth, y) - smoothstep(x + halfLineWidth, x + halfLineWidth + edge, y);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 center = 0.5;
                fixed3 colour = onLine(i.uv.y, 0.5, 0.002, 0.5) * _AxisColour;
                colour       += onLine(i.uv.x, 0.5, 0.002, 0.5) * _AxisColour;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
