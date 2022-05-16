Shader "NiksShaders/Shader62Lit"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D)                = "white" { }
        _Colour("Colour", Color)                  = (1 ,1, 1, 1)
        _EdgeLength("Edge Length", Range(2, 400)) = 20
        _Phong("Phong Strength", Range(0, 1))     = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Lambert nolightmap vertex:dispNone tessellate:tessEdge tessphong:_Phong
        #include "Tessellation.cginc"

        fixed4 _Colour;
        sampler2D _MainTex;
        float _EdgeLength;
        float _Phong;

        struct appdata
        {
            float4 vertex:   POSITION;
            float3 normal:   NORMAL;
            float2 texcoord: TEXCOORD0;
        };

        struct Input
        {
            float2 uv_MainTex;
        };

        void dispNone(inout appdata v) { }

        float4 tessEdge(appdata v0, appdata v1, appdata v2)
        {
            return UnityEdgeLengthBasedTess(v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
        }

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            fixed4 colour = tex2D(_MainTex, IN.uv_MainTex) * _Colour;
            OUT.Albedo = colour.rgb;
            OUT.Alpha  = colour.a;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
