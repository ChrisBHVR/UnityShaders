Shader "NiksShaders/Shader58Lit"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D)           = "white" { }
        _NormalMap("Normal", 2D)               = "bump" { }
        _Colour("Colour", Color)               = (1, 1, 1, 1)
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1))     = 0
        _RimColour("Rim Colour", Color)        = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0.5, 8))  = 3
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _NormalMap;
        float _Smoothness;
        float _Metallic;
        fixed4 _Colour;
        fixed4 _RimColour;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 viewDir;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard OUT)
        {
            fixed4 colour  = tex2D(_MainTex, IN.uv_MainTex) * _Colour;
            OUT.Albedo     = colour.rgb;
            OUT.Alpha      = colour.a;
            OUT.Metallic   = _Metallic;
            OUT.Smoothness = _Smoothness;
            OUT.Normal     = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            float rim      = 1 - saturate(dot(normalize(IN.viewDir), OUT.Normal));
            OUT.Emission   = _RimColour.rgb * pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
