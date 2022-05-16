Shader "NiksShaders/Shader66Glass"
{
    Properties
    {
        _MainTex ("Base (RGB) Trans (A)", 2D)                   = "white" { }
        _NormalMap("Normal Map", 2D)                            = "bump" { }
        _Colour ("Colour", Color)                               = (1, 1, 1, 1)
        _Magnitude("Magnitude", Range(0, 1))                    = 0.05
        _TintStrength("Tint Strength", Range(0, 1))             = 0.3
        _EnvironmentMap("Environment Map", Cube)                = "cube" { }
        _ReflectionStrength("Reflection Strength", Range(0, 1)) = 0.3
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }

        GrabPass { "_GrabTexture" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _NormalMap;
            fixed4 _Colour;
            float _Magnitude;
            float _TintStrength;
            samplerCUBE _EnvironmentMap;
            float _ReflectionStrength;
            sampler2D _GrabTexture;

            struct appdata
            {
                float4 vertex:   POSITION;
                float4 color:    COLOR;
                float2 texcoord: TEXCOORD0;
                float3 normal:   NORMAL;
            };

            struct v2f
            {
                float4 vertex:  POSITION;
                fixed4 color:   COLOR;
                float2 uv:      TEXCOORD0;
                float4 uvGrab:  TEXCOORD1;
                float3 reflect: TEXCOORD2;
            };

            // Vertex function
            v2f vert (appdata v)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.color  = v.color;
                output.uv     = v.texcoord;
                output.uvGrab = ComputeGrabScreenPos(output.vertex);
                float3 viewDir     = WorldSpaceViewDir(v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                output.reflect     = reflect(-viewDir, worldNormal);
                return output;
            }

            // Fragment function
            fixed4 frag (v2f i) : COLOR
            {
                fixed4 colour     = lerp(tex2D(_MainTex, i.uv), _Colour, _TintStrength);
                fixed4 normal     = tex2D(_NormalMap, i.uv);
                half2 distortion  = UnpackNormal(normal).rg;
                i.uvGrab.xy      += distortion * _Magnitude;
                fixed4 grabColour = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvGrab));
                fixed4 reflectionColour = texCUBE(_EnvironmentMap, i.reflect);
                reflectionColour       *= colour.a * _ReflectionStrength;
                return (grabColour * colour * _Colour) + reflectionColour;
            }
            ENDCG
        }
    }
}
