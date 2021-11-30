package fairygui.editor.settings
{
   import fairygui.editor.plugin.PlugInManager;
   
   public class CustomProps extends ISerializedSettings
   {
       
      
      public var all:Object;
      
      public function CustomProps()
      {
         super();
         _fileName = "CustomProperties";
         this.all = {};
      }
      
      override public function load() : void
      {
         this.all = loadFile();
         this.reset();
      }
      
      public function reset() : *
      {
         PlugInManager.FYOUT = this.all.outputScaling != null?Number(this.all.outputScaling):1;
         PlugInManager.FYOUT_Ext = this.all.outputExt != null?Number(this.all.outputExt):-1;
         PlugInManager.TuextureCount = this.all.textureCount != null?Number(this.all.textureCount):4;
         if(this.all.isCompress == "true")
         {
            PlugInManager.COMPRESS = true;
         }
         else
         {
            PlugInManager.COMPRESS = false;
         }
         if(this.all.isBinary == "true")
         {
            PlugInManager.ISBINARY = true;
         }
         else
         {
            PlugInManager.ISBINARY = false;
         }
         PlugInManager.FYOUT1 = PlugInManager.FYOUT;
      }
      
      override public function save() : void
      {
         saveFile(this.all);
         PlugInManager.FYOUT = this.all.outputScaling != null?Number(this.all.outputScaling):1;
         PlugInManager.COMPRESS = this.all.isCompress == "true"?true:false;
         PlugInManager.FYOUT_Ext = this.all.outputExt != null?Number(this.all.outputExt):-1;
         PlugInManager.FYOUT1 = PlugInManager.FYOUT;
         PlugInManager.ISBINARY = this.all.isBinary == "true"?true:false;
         PlugInManager.TuextureCount = this.all.textureCount != null?Number(this.all.textureCount):4;
      }
   }
}
