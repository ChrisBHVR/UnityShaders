Shader "NiksShaders/Shader14Unlit"
{
    Properties
    {
        _Colour("Colour", Color) = (1, 1, 0, 1)
        _Radius("Radius", Float) = 0.3
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

            float2 circle(float2 pos, float2 center, float radius)
            {
                pos -= center;
                return 1 - step(radius, length(pos));
            }

            float2 circle(float2 pos, float2 center, float radius, float smoothing)
            {
                pos -= center;
                float edge = radius * smoothing;
                return 1 - smoothstep(radius - edge, radius + edge, length(pos));
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float inCircle = circle(i.position * 2, 0, _Radius, 0.01);
                fixed3 colour = _Colour * inCircle;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
