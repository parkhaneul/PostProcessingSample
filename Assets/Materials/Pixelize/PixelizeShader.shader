Shader "Custom/PixelizeShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DPI ("dpi", Range(2,1024)) = 64
    }
    SubShader
    {
        Pass{
            CGPROGRAM
            #pragma exclude_renderers d3d11
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float _DPI;
            float4 _MainTex_ST;
    
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
    
            float4 frag(v2f i) : COLOR{
                float2 uv = i.uv;
                
                uv.x *= _DPI;
                uv.y *= _DPI;
                uv.x = round(uv.x);
                uv.y = round(uv.y);
                uv.x /= _DPI;
                uv.y /= _DPI;
                
                fixed4 returnValue = tex2D(_MainTex,uv);
                return returnValue;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
