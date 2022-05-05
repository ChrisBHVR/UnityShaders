Shader "NiksShaders/Shader16Unlit"
{
    Properties
    {
        _Colour("Colour", Color)        = (1, 1, 1, 1)
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
            float _LineWidth;

            struct v2f
            {
                float4 vertex :   SV_POSITION;
                float2 uv:        TEXCOORD0;
                float4 position:  TEXCOORD1;
                float4 screenPos: TEXCOORD2;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex    = UnityObjectToClipPos(v.vertex);
                output.position  = v.vertex;
                output.uv        = v.texcoord;
                output.screenPos = ComputeScreenPos(output.vertex);
                return output;
            }

            float onLine(float a, float b, float width, float smoothing)
            {
                float halfLine = width / 2;
                float edge = halfLine * smoothing;
                return smoothstep(a - halfLine - edge, a - halfLine, b)
                     - smoothstep(a + halfLine, a + halfLine + edge, b);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = i.screenPos.xy / i.screenPos.w;
                fixed3 colour = lerp(0, _Colour, onLine(uv.x, uv.y, _LineWidth, 0.2));
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
