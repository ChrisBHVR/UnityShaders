Shader "NiksShaders/Shader60Lit"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" { }
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex;

            struct v2f
            {
                float2 uv:      TEXCOORD0;
                float4 pos:     SV_POSITION;
                fixed3 diff:    COLOR0;
                fixed3 ambient: COLOR1;
                SHADOW_COORDS(1)
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.pos     = UnityObjectToClipPos(v.vertex);
                output.uv      = v.texcoord;
                half3 normal   = UnityObjectToWorldNormal(v.normal);
                half normalDot = max(0, dot(normal, _WorldSpaceLightPos0.xyz));
                output.diff    = normalDot * _LightColor0.rgb;
                output.ambient = ShadeSH9(half4(normal, 1));
                TRANSFER_SHADOW(output)
                return output;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float lighting = min(1, (i.diff * SHADOW_ATTENUATION(i)) + i.ambient);
                fixed3 colour  = tex2D(_MainTex, i.uv).rgb * lighting;
                return fixed4(colour, 1);
            }
            ENDCG
        }

        // Shadow casting support
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
