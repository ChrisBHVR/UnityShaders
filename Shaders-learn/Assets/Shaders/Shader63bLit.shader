Shader "NiksShaders/Shader63bLit"
{
    Properties
    {
    }

    SubShader
    {
        Tags { "Queue" = "Geometry-1" }

        ColorMask 0
        ZWrite Off

        Stencil
        {
            Ref 1
            Comp Always
            Pass Replace
        }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = 1;
        }
        ENDCG
    }

    Fallback "Diffuse"
}
