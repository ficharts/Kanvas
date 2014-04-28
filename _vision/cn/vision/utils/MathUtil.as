package cn.vision.utils
{
	import cn.vision.consts.ConstsMath;
	import cn.vision.core.NoInstance;
	
	/**
	 * Util of Mathematics.
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class MathUtil extends NoInstance
	{
		
		/**
		 * Conver angle to radian.
		 * 
		 * @param angle Angle to be converted.
		 * @return Radian converted.
		 * 
		 */
		public static function angleToRadian(angle:Number):Number
		{
			return ConstsMath.PI_MOD_ANGLE * angle;
		}
		
		/**
		 * Convert radian to angle.
		 * 
		 * @param radian Radian to be converted.
		 * @return Angle converted.
		 * 
		 */
		public static function radianToAngle(radian:Number):Number
		{
			return ConstsMath.ANGLE_MOD_PI * radian;
		}
		
		/**
		 * Modulo angle, if value is larger than 360 or smaller than 0, modulo it to 0-360.
		 * 
		 * @param angle
		 * @return Angle in the range of 0-360 degrees.
		 * 
		 */
		public static function moduloAngle(angle:Number):Number
		{
			angle = angle % 360;
			return (angle < 0) ? 360 + angle : angle;
		}
		
		/**
		 * Determine whether two numbers are equal.
		 * 
		 * @param value1
		 * @param value2
		 * @param accuracy Digits after the decimal, 0 to use the system default precision.
		 * @return Boolean
		 * 
		 */
		public static function equal(a:Number, b:Number, accuracy:uint = 0):Boolean
		{
			var f:Number = Math.pow(10, accuracy);
			return (f == 1) ? (a == b) : (Math.floor(a * f) == Math.floor(b * f));
		}
		
		/**
		 * Returns the 2 logarithm of the parameter value.
		 * 
		 * @param value
		 * @return Number
		 * 
		 */
		public static function log2(value:Number):Number
		{
			return Math.log(value) / Math.LN2;
		}
		
		/**
		 * Returns the 3 logarithm of the parameter val.
		 * 
		 * @param value
		 * @return Number
		 * 
		 */
		public static function log3(value:Number):Number
		{
			return Math.log(value) / ConstsMath.LN3;
		}
	}
}