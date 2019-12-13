using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteAlways]
public class PostProcessing : MonoBehaviour
{
    public Material material;
    // Start is called before the first frame update
    void Start()
    {
        activePostProcessing(CameraEvent.AfterEverything);
    }

    void activePostProcessing(CameraEvent cameraEvent)
    {
        if (material == null)
            return;

        var currentCam = Camera.main;

        if (currentCam == null)
            return;

        CommandBuffer cBuffer = new CommandBuffer();
        
        var tempShaderID = Shader.PropertyToID("_Temp");
        cBuffer.GetTemporaryRT(tempShaderID,-1,-1,0,FilterMode.Bilinear);
        //get RenderTexture

        cBuffer.Blit(BuiltinRenderTextureType.CurrentActive, tempShaderID);
        cBuffer.Blit(tempShaderID,BuiltinRenderTextureType.CurrentActive,material);
        //renderTexture set Material
        
        cBuffer.ReleaseTemporaryRT(tempShaderID);
        currentCam.AddCommandBuffer(cameraEvent,cBuffer);
        //add Camera commandBuffer
    }
}
