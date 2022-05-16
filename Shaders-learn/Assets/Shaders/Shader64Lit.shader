Shader "NiksShaders/Shader64Lit"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D)           = "white" { }
        _NormalMap("Normal Map", 2D)           = "bump" { }
        _Colour("Colour", Color)               = (1, 1, 1, 1)
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1))     = 0
        _RimColour("Rim Colour", Color)        = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0.5, 8))  = 3
        _RevealTime("Reveal Time", Float)      = 2
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Cull Off

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;
        half _Smoothness;
        half _Metallic;
        fixed4 _Colour;
        fixed4 _RimColour;
        float _RimPower;
        float _RevealTime;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 viewDir;
            float3 worldPos;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard OUT)
        {
            clip(frac(IN.worldPos.y * 10) - 1 + _RevealTime);
            fixed4 colour = tex2D(_MainTex, IN.uv_MainTex) * _Colour;
            OUT.Albedo = colour.rgb;
            OUT.Alpha = colour.a;
            OUT.Metallic = _Metallic;
            OUT.Smoothness = _Smoothness;
            OUT.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            half rim = 1 - saturate(dot(normalize(IN.viewDir), OUT.Normal));
            OUT.Emission = _RimColour.rgb * pow(rim, _RimPower);
        }
        ENDCG
    }

    FallBack "Diffuse"
}
