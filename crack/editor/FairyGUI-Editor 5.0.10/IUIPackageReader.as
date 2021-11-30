package fairygui
{
   import flash.utils.ByteArray;
   
   public interface IUIPackageReader
   {
       
      
      function readDescFile(param1:String) : String;
      
      function readResFile(param1:String) : ByteArray;
   }
}
