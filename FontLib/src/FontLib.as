package
{
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	import flashx.textLayout.compose.ISWFContext;
	
	
	/**
	 */	
	public class FontLib extends MovieClip implements ISWFContext
	{
		
		[Embed(source="WawaSC-Regular.otf", fontName="娃娃体", mimeType="application/x-font")]
		public var FangSong:Class;
		
		[Embed(source="msyh.ttf", fontName="微软雅黑", mimeType="application/x-font")]
		public var YaHei:Class;
		
		[Embed(source="simsun.ttc", fontName="宋体", mimeType="application/x-font")]
		public var Sonti:Class;
		
		[Embed(source="gangbi.fon", fontName="钢笔字", mimeType="application/x-font")]
		public var GangBi:Class;
		
		
		
		[Embed(source="lantingtehei.TTF", fontName="兰亭黑", mimeType="application/x-font")]
		public var LanTing:Class;
		
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
		
		public var fonts:Array = ["微软雅黑", "娃娃体", "宋体", "钢笔字", "兰亭黑"];
	}
}