package
{
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	import flashx.textLayout.compose.ISWFContext;
	
	/**
	 */	
	public class FontLib extends Sprite implements ISWFContext
	{
		
		[Embed(source="msyh.ttf", fontName="微软雅黑", mimeType="application/x-font")]
		public var YaHei:Class;
		
		[Embed(source="simfang.ttf", fontName="仿宋", mimeType="application/x-font")]
		public var FangSong:Class;
		
		[Embed(source="simsun.ttc", fontName="宋体", mimeType="application/x-font")]
		public var Sonti:Class;
		
		/**
		 */		
		public function FontLib()
		{
		}
		
		/**
		 */		
		public function callInContext(fn:Function, thisArg:Object, argsArray:Array, returns:Boolean=true):*
		{
			if (returns)
				return fn.apply(thisArg, argsArray);
			fn.apply(thisArg, argsArray);
		}
		
		public var fonts:Array = ["微软雅黑", "仿宋", "宋体"];
	}
}