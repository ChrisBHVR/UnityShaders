Shader "NiksShaders/Shader68Unlit"
{
    Properties
    {
        _Colour("Colour", Color)  = (1, 1, 1, 1)
        _Radius("Radius", Float)  = 0.4
        _Center("Center", Vector) = (0, 0, 0, 0)
        _Texture("Texture", 2D)   = "white" { }
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define STEPS 144
            #define STEP_SIZE 0.00694444

            fixed4 _Colour;
            float _Radius;
            float3 _Center;
            sampler2D _Texture;

            struct v2f
            {
                float4 position: SV_POSITION; // Clip space
                float3 worldPos: TEXCOORD1;   // World position
            };

            v2f vert (appdata_base v)
            {
                 v2f output;
                 output.position = UnityObjectToClipPos(v.vertex);
                 output.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                 return output;
            }

            fixed4 raymarch(float3 position, float3 direction)
            {
                float alpha   = 0;
                float3 center = _Center - 0.5;
                for (int i = 0; i < STEPS; i++)
                {
                    int index     = floor((position.z - center.z) * STEPS);
                    float2 uv     = saturate(position.xy - center.xy) / 12;
                    float2 offset = float2(fmod(index, 12), floor(index / 12.0)) / 12;
                    float texel   = tex2D(_Texture, uv + offset).r;
                    alpha        += texel * STEP_SIZE;
                    position     += direction * STEP_SIZE;
                }

                return alpha;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 direction = normalize(i.worldPos - _WorldSpaceCameraPos);
                float alpha      = raymarch(i.worldPos, direction);
                return fixed4(_Colour.rgb, alpha);
            }
            ENDCG
        }
    }

    FallBack off
}
