Shader "NiksShaders/Shader13Unlit"
{
    Properties
    {
        _Colour("Colour", Color) = (1, 1, 0, 1)
        _Size("Size", Float) = 0.3
        _Anchor("Anchor", Vector) = (0, 0, 0, 0.5)
        _TileCount("Tile Count", Int) = 6
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
            float _Size;
            float4 _Anchor;
            int _TileCount;

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
                pos -= center;
                size /= 2;
                float2 test = step(-size, pos) - step(size, pos);
                return test.x * test.y;
            }

            float rect(float2 pos, float2 size, float2 center, float2 anchor)
            {
                pos -= center;
                size /= 2;
                float2 test = step(-size - anchor, pos) - step(size - anchor, pos);
                return test.x * test.y;
            }

            float2x2 getRotationMatrix(float theta)
            {
                float s = sin(theta);
                float c = cos(theta);
                return float2x2(c, -s, s, c);
            }

            float2x2 getScaleMatrix(float scale)
            {
                return float2x2(scale, 0, 0, scale);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2x2 rotationMatrix  = getRotationMatrix(_Time.y);
                float2x2 scaleMatrix     = getScaleMatrix(((sin(_Time.y) + 1) / 3) + 0.5);
                float2x2 mat  = mul(rotationMatrix, scaleMatrix);
                float2 pos = frac(i.uv * _TileCount);
                pos        = mul(mat, pos - _Anchor.zw) + _Anchor.zw;
                float inRect  = rect(pos, _Size, _Anchor.zw, _Anchor.xy);
                fixed3 colour = _Colour * inRect;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
