Shader "NiksShaders/Shader70aUnlit"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D)                = "white" { }
        _Tint("Tint", Range(0, 1))                = 1.0
        _TintColour("Tint Colour", Color)         = (0.6, 1, 0.6, 1)
        _Scanlines("Scanlines", Range(50, 150))   = 100
        _ScanlineColour("Scanline Colour", Color) = (0, 0, 0, 1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed _Tint;
            fixed4 _TintColour;
            float _Scanlines;
            fixed4 _ScanlineColour;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed3 renderTex = tex2D(_MainTex, i.uv).rgb;
                fixed gray       = (renderTex.r + renderTex.g + renderTex.b) / 3;
                fixed3 tinted    = gray * _TintColour;
                float scanline   = smoothstep(0.2, 0.4, frac(i.uv.y * _Scanlines));
                fixed3 colour    = lerp(renderTex, tinted, _Tint);
                colour           = lerp(_ScanlineColour, colour, scanline);
                return fixed4(colour, 1);

            }
            ENDCG
        }
    }
    FallBack off
}
