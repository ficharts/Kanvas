package model
{
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	

	/**
	 * 负责加载配置文件, 并初始化配置库
	 */	
	public class ConfigInitor
	{
		/**
		 * 缩放，旋转图标的尺寸；
		 */		
		public static const ICON_SIZE_FOR_SCALE_AND_ROLL:uint = 18;
		
		/**
		 * 缩略图的宽度 
		 */		
		public static var THUMB_WIDTH:uint = 400;
		
		/**
		 * 缩略图的高度 
		 */		
		public static var THUMB_HEIGHT:uint = 300;
		
		public static var SERVER_URL:String = "";
		
		public static var DOC_ID:String = "";
		
		
		/**
		 */		
		public function ConfigInitor(core:CoreApp)
		{
			for each (var item:XML in StyleEmbeder.styleXML.child('template').children())
				XMLVOLib.registWholeXML(item.@id, item, item.name().toString());
			
			CoreFacade.coreProxy.initThemeConfig(XML(StyleEmbeder.styleXML.child('themes').toXMLString()));
			core.ready();
		}
	}
}