Shader "Custom/TwoToneShading"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Standard("Tone Degree", Range(0,128)) = 16
        _LighterTone ("Color", Color) = (0,0,0,0)
        _DarkerTone("Color", Color) = (0,0,0,0)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma exclude_renderers d3d11
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
    
            #include "UnityCG.cginc"
    
            sampler2D _MainTex;
            float _Standard;
            float4 _LighterTone;
            float4 _DarkerTone;
    
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : texcoord;
            };
            
            v2f vert(appdata_base v){
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }
            
            float random(float2 uv){
                return frac(sin(dot(uv,float2(12.9898,78.233))) * 43758.5453123);
            }
            
            float isLargeValue(float4 a,float4 b){
                float4 aValue = a.r + a.g + a.b;
                float4 bValue = b.r + b.g + b.b;
                
                return aValue > bValue ? 0 : 1;
            }
    
            float4 frag(v2f i) : COLOR{
                fixed4 SamplerImage = tex2D(_MainTex,i.uv);
                
                fixed4 returnValue = 0;
                
                float4 degree = ((SamplerImage.r + SamplerImage.g + SamplerImage.b)/3)/(_Standard/255);
                
                returnValue = _DarkerTone * (1-degree) + _LighterTone * degree;
                
                return returnValue;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
