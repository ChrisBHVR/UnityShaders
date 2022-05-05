Shader "NiksShaders/Shader41Unlit"
{
    Properties
    {
        _TextureA("Texture A", 2D)     = "white" { }
        _TextureB("Texture B", 2D)     = "white" { }
        _Duration("Duration", Float)   = 6
        _StartTime("StartTime", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _TextureA;
            sampler2D _TextureB;
            float _Duration;
            float _StartTime;

            struct v2f
            {
                float4 vertex:   SV_POSITION;
                float2 uv:       TEXCOORD0;
                float4 position: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.vertex   = UnityObjectToClipPos(v.vertex);
                output.uv       = v.texcoord;
                output.position = v.vertex;
                return output;
            }

            float4 frag(v2f i) : COLOR
            {
                float time    = _Time.y - _StartTime;
                float2 pos    = (2 * i.uv) - 1;
                float len     = length(pos);
                float2 ripple = i.uv + ((pos / len) * cos(len * 12 - time * 4) * 0.03);
                float delta   = saturate(time / _Duration);
                float2 uv     = lerp(ripple, i.uv, saturate(time / _Duration));
                float fade    = smoothstep(delta * 1.41, delta * 2.5, len);
                fixed3 colour = lerp(tex2D(_TextureB, uv).rgb, tex2D(_TextureA, uv).rgb, fade);
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

