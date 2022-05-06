Shader "NiksShaders/Shader57bLit"
{
    Properties
    {
      _MainTex ("Texture", 2D)                  = "white" { }
      _Colour("Colour", Color)                   = (1, 1, 1, 1)
      _Roughness("Roughness", Range(0, 1))      = 0.5
      _LevelCount("Level Count", Int)           = 3
      _SpecPower("Specular Power", Range(0, 1)) = 0.5
      _SpecColor("Specular Colour", Color)      = (1, 1, 1, 1)
      _Glossiness("Glossiness", Range(0, 1))    = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf OrenNayer

        sampler2D _MainTex;
        float _SpecPower;
        float _Glossiness;
        float _Roughness;
        int _LevelCount;
        fixed4 _Colour;

        struct Input
        {
              float2 uv_MainTex;
        };

        half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            half normalDot = max(0, dot(s.Normal, lightDir));
            half3 colour   = s.Albedo * _LightColor0.rgb * normalDot * atten;
            return half4(colour, s.Alpha);
        }

        half4 LightingHalfLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            half normalDot = max(0, dot(s.Normal, lightDir));
            half diff      = (normalDot * 0.5) + 0.5;
            half3 colour   = s.Albedo * _LightColor0.rgb * diff * diff * atten;
            return half4(colour, s.Alpha);
        }

        half4 LightingPhong(SurfaceOutput s, half3 lightDir, half viewDir, half atten)
        {
            half3 lightReflectDir = reflect(-lightDir, s.Normal);
            half normalDot        = max(0, dot(s.Normal, lightDir));
            half reflectDot       = max(0, dot(lightReflectDir, viewDir));

            //Specular calculations
            half3 specularity   = pow(reflectDot, _Glossiness * 10) * _SpecPower * _SpecColor.rgb;
            half3 lightingModel = (normalDot * _Colour) + specularity;
            float3 attenColour  = (atten * _LightColor0.rgb);
            half3 colour        = s.Albedo * lightingModel * attenColour;
            return half4(colour, s.Alpha);
        }

        half4 LightingMyBlinnPhong(SurfaceOutput s, half3 lightDir, half viewDir, half atten)
        {
            float3 halfDir = normalize(viewDir + lightDir);
            half normalDot = max(0, dot(s.Normal, lightDir));
            half viewDot   = max(0, dot(s.Normal, halfDir));

            //Specular calculations
            half3 specularity   = pow(normalDot, _Glossiness * 20) * _SpecPower * 2 *_SpecColor.rgb;
            half3 lightingModel = (normalDot * _Colour) + specularity;
            float3 attenColour   = atten * _LightColor0.rgb;
            half3 colour        = s.Albedo * lightingModel * attenColour;
            return half4(colour, s.Alpha);
        }

        half4 LightingMinnaert(SurfaceOutput s, half3 lightDir, half viewDir, half atten)
        {
            half normalDot = max(0, dot(s.Normal, lightDir));
            half viewDot = max(0, dot(s.Normal, viewDir));
            half3 minnaert = saturate(normalDot * pow(normalDot * viewDot, _Roughness));
            half3 colour = s.Albedo * _LightColor0.rgb * atten * minnaert;
            return half4(colour, s.Alpha);
        }

        half4 LightingOrenNayer(SurfaceOutput s, half3 lightDir, half viewDir, half atten)
        {
            half roughnessSqr = _Roughness * _Roughness;
            half3 ONFraction  = roughnessSqr / (roughnessSqr + float3(0.33, 0.13, 0.09));
            float3 ON         = float3(1, 0, 0) + (float3(-0.5, 0.17, 0.45) * ONFraction);
            float normalDot   = saturate(dot(s.Normal, lightDir));
            float viewDot     = saturate(dot(s.Normal, viewDir));
            float ONs         = saturate(dot(lightDir, viewDir)) - normalDot * viewDot;
            ONs              /= lerp(max(normalDot, viewDot), 1, step(ONs, 0));

            //lighting and final diffuse
            half3 lightingModel = _Colour * normalDot * (ON.x + (_Colour * ON.y) + (ON.z * ONs));
            half3 attenColor = atten * _LightColor0.rgb;
            half3 colour = s.Albedo * lightingModel * attenColor;
            return half4(colour, s.Alpha);
        }

        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
        {
            half normalDot = max(0, dot(s.Normal, lightDir));
            half diff      = (normalDot * 0.5) + 0.5;
            half3 ramp = floor(diff * diff * _LevelCount) / _LevelCount;
            half3 colour = s.Albedo * _LightColor0.rgb * ramp * atten;
            return half4(colour, s.Alpha);
        }

        void surf(Input IN, inout SurfaceOutput OUT)
        {
            OUT.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
