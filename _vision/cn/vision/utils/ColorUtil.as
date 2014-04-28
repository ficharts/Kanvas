package cn.vision.utils
{
	import cn.vision.core.NoInstance;

	/**
	 * ColorUtil used to convert color string between  
	 * <code>uint</code> and <code>String</code>.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 */
	public final class ColorUtil extends NoInstance
	{
		
		/**
		 * Convert the color string to unit.
		 * 
		 * @param value the string needs to convert.
		 * 
		 * @return <code>uint</code>
		 */
		public static function colorString2uint($value:String):uint
		{
			if ($value.charAt(0) == "#") 
				$value = "0x" + $value.substr(1);
			return uint($value);
		}
		
		/**
		 * Convert the color uint to string.
		 * 
		 * @param value the uint needs to convert.
		 * 
		 * @return <code>String</code>
		 */
		public static function colorUint2String($value:uint, $prefix:String = "0x"):String
		{
			$prefix = ($prefix=="#") ? "#" : "0x";
			return $prefix + $value.toString(16);
		}
	}
}