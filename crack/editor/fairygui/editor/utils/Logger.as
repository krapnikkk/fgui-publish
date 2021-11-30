package fairygui.editor.utils
{
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   
   public class Logger
   {
      
      private static var _file:File;
       
      
      public function Logger()
      {
         super();
      }
      
      public static function print(param1:String) : void
      {
         var _loc5_:String = null;
         var _loc2_:File = null;
         var _loc7_:File = null;
         var _loc6_:* = param1;
         var _loc3_:Date = new Date();
         if(!_file)
         {
            _loc5_ = _loc3_.fullYear + "-" + _loc3_.month + "-" + _loc3_.date + ".log";
            _loc2_ = new File(new File(File.applicationDirectory.url).nativePath);
            _loc7_ = _loc2_.resolvePath("logs");
            if(!_loc7_.exists)
            {
               _loc7_.createDirectory();
            }
            _file = _loc7_.resolvePath(_loc5_);
         }
         var _loc4_:FileStream = new FileStream();
         try
         {
            _loc4_.open(_file,"append");
            _loc4_.writeUTFBytes("[" + _loc3_.toTimeString() + "] " + _loc6_ + "\r\n");
            _loc4_.close();
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
   }
}
