package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	/**
	 * LogUtil covers trace method and defined logFunction.
	 * basicly the utils for log.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 */

	public final class LogUtil extends NoInstance
	{
		public static function log(...$args):void
		{
			trace.apply(null, $args);
		}
		public static function logFunction($className:String, $methodName:String, ...$args):void
		{
			log($className+"."+$methodName+"("+(($args)?$args.toString():"")+")");
		}
	}
}