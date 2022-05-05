Shader "NiksShaders/Shader33Unlit"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" { }
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

            sampler2D _MainTex;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col;
                fixed3 colour;
                float2 uv = i.uv * 2;
                float2 offset = _Time.y * 0.25;
                if (i.uv.x < 0.5)
                {
                    if (i.uv.y < 0.5)
                    {
                        col = tex2D(_MainTex, uv);
                        colour = fixed3(col.b, col.b, col.b);
                    }
                    else
                    {
                        col = tex2D(_MainTex, frac(uv - float2(0, 1) + offset));
                        colour = fixed3(col.r, col.r, col.r);
                    }
                }
                else
                {
                    if (i.uv.y<0.5)
                    {
                        col = tex2D(_MainTex, frac(uv - float2(1, 0) - offset));
                        colour = fixed3(col.a, col.a, col.a);
                    }
                    else
                    {
                        col = tex2D(_MainTex, frac(uv - float2(1, 1) + offset));
                        colour = fixed3(col.g, col.g, col.g);
                    }
                }

                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

