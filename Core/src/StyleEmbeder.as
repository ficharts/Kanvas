package
{
	import flash.utils.ByteArray;

	/**
	 * 负责样式文件的嵌入及初始化
	 */	
	public class StyleEmbeder
	{
		public function StyleEmbeder()
		{
		}
		
		/**
		 *  获取样式配置文件
		 */		
		public static function get styleXML():XML
		{
			if (_style == null)
				_style = XML(ByteArray(new ConfigXML).toString());
			
			return _style;
		}
		
		/**
		 */		
		private static var _style:XML;
		
		/**
		 */		
		[Embed(source="Config.xml", mimeType="application/octet-stream")]
		public static var ConfigXML:Class;
	}
}