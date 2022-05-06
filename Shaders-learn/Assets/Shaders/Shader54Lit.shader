Shader "NiksShaders/Shader54Lit"
{
    Properties
    {
        _MainTex("Texture", 2D)                           = "white" { }
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
        float _ReflStrength;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldRefl;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * 0.5;
            OUT.Emission = texCUBE(_Cube, IN.worldRefl).rgb * _ReflStrength;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
