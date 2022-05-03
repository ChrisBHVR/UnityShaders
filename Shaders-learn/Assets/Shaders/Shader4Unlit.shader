Shader "NiksShaders/Shader4Unlit"
{
    Properties
    {
        _ColourA("Colour A", Color) = (1, 0, 0, 1)
        _ColourB("Colour B", Color) = (0, 0, 1, 1)
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

            #include "UnityCG.cginc"

            fixed4 _ColourA;
            fixed4 _ColourB;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float t = i.uv.x;
                fixed3 colour = lerp(_ColourA, _ColourB, t);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}
