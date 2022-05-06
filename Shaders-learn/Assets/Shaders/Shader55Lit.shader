Shader "NiksShaders/Shader55Lit"
{
    Properties
    {
        _MainTex("Texture", 2D)                           = "white" { }
        _NormalMap("Normal", 2D)                          = "bump" { }
        _Cube("Cubemap", CUBE)                            = "" { }
        _ReflStrength("Reflection Strength", Range(0, 1)) = 0.5
    }

    SubShader
    {

        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        samplerCUBE _Cube;
        sampler2D _NormalMap;
        float _ReflStrength;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo   = tex2D(_MainTex, IN.uv_MainTex).rgb * 0.5;
            OUT.Normal   = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            OUT.Emission = texCUBE(_Cube, WorldReflectionVector(IN, OUT.Normal)).rgb * _ReflStrength;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
