package fairygui.editor.dialogs
{
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import flash.desktop.NativeApplication;
   
   public class AboutDialog extends WindowBase
   {
       
      
      public function AboutDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","AboutDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.modal = true;
         var _loc4_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc4_.namespace("");
         var _loc3_:String = _loc4_._loc2_::versionNumber;
         contentPane.getChild("version").text = _loc3_;
         contentPane.getChild("msg").text = "Copyright 2013-2017 by FairyGUI.com\nAll Rights Reserved.[color=#3399FF]\n[url=http://www.fairygui.com]http://www.fairygui.com[/url][/color]\nsupport@fairygui.com\n\nThis software is powered by FairyGUI.";
         contentPane.getChild("n14").addClickListener(this.closeEventHandler);
      }
   }
}
