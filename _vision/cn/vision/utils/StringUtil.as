package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	public final class StringUtil extends NoInstance
	{
		public static function toString($value:*):String
		{
			return ($value is String) ? $value : String($value);
		}
	}
}