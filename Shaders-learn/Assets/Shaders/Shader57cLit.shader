Shader "NiksShaders/Shader57cLit"
{
    Properties
    {
        _MainTex("Texture", 2D)                       = "white" { }
        _Colour("Colour", Color)                      = (1, 1, 1, 1)
        _OutlineColour("Outline Colour", Color)       = (0, 0, 0, 1)
        _OutlineWidth("Outline Width", Range(0, 0.1)) = 0.03
        _LevelCount("Level Count", Int)               = 3
    }

    Subshader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Ramp

        sampler2D _MainTex;
        int _LevelCount;
        fixed4 _Colour;

        struct Input
        {
            float2 uv_MainTex;
        };

        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
        {
            half diff = pow((dot(s.Normal, lightDir) * 0.5) + 0.5, 2);
            half3 ramp = floor(diff * _LevelCount) / _LevelCount;
            half3 colour = s.Albedo * _LightColor0.rgb * ramp * atten;
            return fixed4(colour, s.Alpha);
        }

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = _Colour.rgb * tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG

        Pass
        {
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float _OutlineWidth;
            fixed4 _OutlineColour;

            float4 vert(float4 position: POSITION, float3 normal: NORMAL) : SV_POSITION
            {
                position.xyz += normal * _OutlineWidth;
                return UnityObjectToClipPos(position);
            }

            fixed4 frag() : SV_TARGET
            {
                return _OutlineColour;
            }
            ENDCG
        }
    }
}
