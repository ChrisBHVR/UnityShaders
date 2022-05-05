Shader "NiksShaders/Shader17Unlit"
{
    Properties
    {
        _Colour("Color", Color)         = (1, 1, 1, 1)
        _LineWidth("Line Width", Float) = 0.02
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
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex    = UnityObjectToClipPos(v.vertex);
                output.position  = v.vertex;
                output.uv        = v.texcoord;
                return output;
            }

            float getDelta(float x)
            {
                return (sin(x) + 1) / 2;
            }

            float onLine(float a, float b, float width, float smoothing)
            {
                float halfLine = width / 2;
                float edge     = halfLine * smoothing;
                return smoothstep(a - halfLine - edge, a - halfLine,        b)
                     - smoothstep(a + halfLine,        a + halfLine + edge, b);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 pos = i.position * 2;
                fixed3 colour = _Colour * onLine(pos.y, lerp(-0.4, 0.4, getDelta(pos.x * UNITY_PI)), 0.05, 0.25);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
