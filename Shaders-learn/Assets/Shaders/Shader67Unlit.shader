Shader "NiksShaders/Shader67Unlit"
{
    Properties
    {
        _Radius("Radius", Float)  = 0.4
        _Center("Center", Vector) = (0, 0,0 , 0)
        _Colour("Colour", Color)  = (0, 0, 1, 1)
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

            #define STEPS 100
            #define STEP_SIZE 0.0175

            float _Radius;
            float3 _Center;
            fixed4 _Colour;

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
                for (int i = 0; i < STEPS; i++)
                {
                    if (length(position - _Center.xyz) < _Radius)
                    {
                        return _Colour;
                    }
                    position += direction * STEP_SIZE;
                }

                return -1;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 direction = normalize(i.worldPos - _WorldSpaceCameraPos);
                fixed4 colour = raymarch(i.worldPos, direction);
                clip(colour);
                return colour;

            }
            ENDCG
        }
    }

    FallBack off
}
