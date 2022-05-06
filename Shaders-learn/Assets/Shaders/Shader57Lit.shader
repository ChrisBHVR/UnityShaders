Shader "NiksShaders/Shader57Lit"
{
    Properties
    {
      _MainTex ("Texture", 2D)       = "white" { }
      _LevelCount("LevelCount", Int) = 4
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Ramp

        sampler2D _MainTex;
        int _LevelCount;

        struct Input
        {
            float2 uv_MainTex;
        };

        half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            half normalDot = max(0, dot(s.Normal, lightDir));
            half3 colour   = s.Albedo * _LightColor0.rgb * normalDot * atten;
            return half4(colour, s.Alpha);
        }

        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
        {
            half normalDot = max(0, dot(s.Normal, lightDir));
            half3 ramp     = floor(normalDot * _LevelCount) / _LevelCount;
            half3 colour   = s.Albedo * _LightColor0.rgb * ramp * atten;
            return half4(colour, s.Alpha);
        }

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
