Shader "NiksShaders/Shader42Unlit"
{
    Properties
    {
        _Radius("Radius", Float) = 1
        _Delta("Lerp Factor", Range(0, 1)) = 0
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

            float _Radius;
            float _Delta;

            struct v2f
            {
                float4 vertex: SV_POSITION;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                float4 spherical = float4(normalize(v.vertex.xyz) * _Radius * 0.01, v.vertex.w);
                float4 pos       = lerp(v.vertex, spherical, _Delta);
                output.vertex    = UnityObjectToClipPos(pos);
                return output;
            }

            float4 frag(v2f i) : COLOR
            {
                return fixed4(1, 1, 1, 1);
            }
            ENDCG
        }
    }
}

