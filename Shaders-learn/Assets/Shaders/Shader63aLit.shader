Shader "NiksShaders/Shader63aLit"
{
    Properties
    {
      _MainTex("Texture", 2D) = "white" { }
    }

    SubShader
    {
        Tags { "Queue"="Geometry" }

        Stencil
        {
            Ref 1
            Comp NotEqual
            Pass Keep
        }

        Cull Back

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG

        Stencil
        {
            Ref 1
            Comp Always
            Pass Keep
        }

        Cull Front

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
