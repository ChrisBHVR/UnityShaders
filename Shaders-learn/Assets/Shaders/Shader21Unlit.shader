Shader "NiksShaders/Shader21Unlit"
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

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                output.uv       = v.texcoord;
                return output;
            }

            float sweep(float2 pos, float2 center, float radius, float lineWidth, float smoothing)
            {
                pos             -= center;
                float theta      = _Time.z;
                float2 sweepLine = float2(cos(theta), -sin(theta)) * radius;
                float height     = clamp(dot(pos, sweepLine) / dot(sweepLine, sweepLine), 0, 1);
                float len        = length(pos - (sweepLine * height));
                float edge       = lineWidth * smoothing;

                float gradient = 0;
                const float GRADIENT_ANGLE = UNITY_PI / 2;
                if (length(pos) < radius)
                {
                    float angle = fmod(theta + atan2(pos.y, pos.x), UNITY_TWO_PI);
                    gradient    = (clamp(GRADIENT_ANGLE - angle, 0, GRADIENT_ANGLE) / GRADIENT_ANGLE) / 2;
                }

                return gradient + 1 - smoothstep(lineWidth, lineWidth + edge, len);
            }

            float circle(float2 pos, float2 center, float radius, float lineWidth, float smoothing)
            {
                float len = length(pos - center);
                float halfLineWidth = lineWidth / 2;
                float edge = halfLineWidth * smoothing;
                return smoothstep(radius - halfLineWidth - edge, radius - halfLineWidth,        len)
                     - smoothstep(radius + halfLineWidth,        radius + halfLineWidth + edge, len);
            }

            float onLine(float x, float y, float lineWidth, float smoothing)
            {
                float halfLineWidth = lineWidth / 2;
                float edge = halfLineWidth * smoothing;
                return smoothstep(x - halfLineWidth - edge, x - halfLineWidth, y) - smoothstep(x + halfLineWidth, x + halfLineWidth + edge, y);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 center = 0.5;
                fixed3 colour = onLine(i.uv.y, 0.5, 0.002, 0.5) * _AxisColour;
                colour       += onLine(i.uv.x, 0.5, 0.002, 0.5) * _AxisColour;

                colour       += circle(i.uv, center, 0.3, 0.002, 0.5) * _AxisColour;
                colour       += circle(i.uv, center, 0.2, 0.002, 0.5) * _AxisColour;
                colour       += circle(i.uv, center, 0.1, 0.002, 0.5) * _AxisColour;

                colour       += sweep(i.uv, center, 0.3, 0.002, 0.5) * _SweepColour;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
