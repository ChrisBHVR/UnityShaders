Shader "NiksShaders/Shader65Lit"
{
    Properties
    {
      _MainTex("Texture", 2D)         = "white" { }
      _AlphaTest("Alpha Test", Range(0, 1)) = 0.7
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }

        ZWrite Off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput OUT)
        {
            fixed4 colour = tex2D(_MainTex, IN.uv_MainTex);
            OUT.Albedo    = colour.rgb;
            OUT.Alpha     = 1 - colour.a;
        }
        ENDCG

        ColorMask 0

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade alphatest:_AlphaTest addshadow
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput OUT)
        {
            fixed4 colour = tex2D(_MainTex, IN.uv_MainTex);
            OUT.Albedo    = colour.rgb;
            OUT.Alpha     = 1 - colour.a;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
