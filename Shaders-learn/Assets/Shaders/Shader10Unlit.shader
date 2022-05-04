Shader "NiksShaders/Shader10Unlit"
{
    Properties
    {
        _Colour("Colour", Color) = (1, 1, 0, 1)
        _Radius("Radius", Float) = 0.5
        _Size("Size", Float)     = 0.3
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
            float _Size;

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

            float rect(float2 pos, float2 size, float2 center)
            {
                pos -= center;
                size /= 2;
                float2 test = step(-size, pos) - step(size, pos);
                return test.x * test.y;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float inRect = rect(i.position.xy, _Size, float2(cos(_Time.y), sin(_Time.y)) * _Radius);
                fixed3 colour = _Colour * inRect;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
