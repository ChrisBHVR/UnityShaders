Shader "NiksShaders/Shader38Unlit"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" { }
        _Angle("Angle", Float)       = 0
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

            #define DEG_TO_RAD UNITY_PI / 180

            sampler2D _MainTex;
            float _Angle;

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

            float2x2 getRotationMatrix(float theta)
            {
                float c = cos(theta);
                float s = sin(theta);
                return float2x2(c, s, -s, c);
            }

            float4 frag(v2f i) : COLOR
            {
                float aspect = 4.0 / 3;
                float2 center = 0.5;
                float2 pos   = i.uv - center;
                pos.y       /= aspect;
                pos          = mul(pos, getRotationMatrix(_Angle * DEG_TO_RAD));
                pos.y       *= aspect;
                pos         += center;

                fixed3 colour = pos.x >= 0 && pos.x <= 1 && pos.y >= 0 && pos.y <= 1 ? tex2D(_MainTex, pos).rgb : 0;
                return fixed4(colour, 1);
            }
            ENDCG
        }
    }
}

