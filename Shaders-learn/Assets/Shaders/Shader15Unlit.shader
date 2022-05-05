Shader "NiksShaders/Shader15Unlit"
{
    Properties
    {
        _Colour("Colour", Color)          = (1, 1, 0, 1)
        _Radius("Radius", Float)        = 0.3
        _LineWidth("Line Width", Float) = 0.01
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

            fixed4 _Colour;
            float _Radius;
            float _LineWidth;

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

            float2 circleOutline(float2 pos, float2 center, float radius, float lineWidth)
            {
                float len = length(pos - center);
                float halfLine = lineWidth / 2;
                return step(radius - halfLine, len) - step(radius + halfLine, len);
            }

            float2 circleOutline(float2 pos, float2 center, float radius, float lineWidth, float smoothing)
            {
                float len = length(pos - center);
                float halfLine = lineWidth / 2;
                float edge = radius * smoothing;
                return smoothstep(radius - halfLine - edge, radius - halfLine,        len)
                     - smoothstep(radius + halfLine,        radius + halfLine + edge, len);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float inCircle = circleOutline(i.position * 2, 0, _Radius, _LineWidth, 0.015);
                fixed3 colour = _Colour * inCircle;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
