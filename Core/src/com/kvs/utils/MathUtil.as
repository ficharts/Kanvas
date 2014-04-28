package com.kvs.utils
{
	public class MathUtil
	{
		public function MathUtil()
		{
	
		}
		
		public static function angleToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		public static function radianToAngle(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}
		
		public static function modRotation(value:Number):Number
		{
			value = value % 360;
			if (value < 0) value += 360;
			
			return value;
		}
		
		/**
		 * 修正目标旋转角度使之小于180
		 */
		public static function modTargetRotation(start:Number, target:Number):Number
		{
			if (Math.abs(start - target) > 180)
				target = (target > start) ? target - 360 : target + 360;
			return target;
		}
		
		/**
		 * 是否为偶数
		 */		
		public static function ifOddNumber(value:uint):Boolean
		{
			return !Boolean((value % 2));
		}
		
		/**
		 */		
		public static function numChange(value:String, from:uint, to:uint):String
		{
			var num:Number = parseInt(value, from); 
			return num.toString(to);
		}
		
		/**
		 * 按照小数点的位数四舍五入
		 */		
		public static function round(value:Number, length:uint):String
		{
			var factor:Number = 1;
			for (var i:uint = 0; i < length; i ++)
			{
				factor *= 10;
			}
			
			var result:Number = Math.round(value * factor) / factor;
			var integer:String = String(result).split('.')[0];
			var decimal:String = String(result).split('.')[1];
			
			if (decimal && decimal.length < length)
			{
				for (i = 0; i < length - decimal.length; i ++)
					decimal = decimal + '0';
				
				return integer + '.' + decimal;
			}
			else
			{
				return result.toString();
			}
		}
		
		/**
		 * 判断2个数是否相等，
		 * 
		 * @param value1
		 * @param value2
		 * @param accuracy 精度
		 * @return 
		 * 
		 */
		public static function equals(value1:Number, value2:Number, accuracy:int = 10):Boolean
		{
			var factor:Number = Math.pow(10, accuracy);
			return Math.floor(value1 * factor) == Math.floor(value2 * factor);
		}
		
		/**
		 * 按照保留小数点的位数向上取整
		 */		
	    public static function ceil(value:Number, length:uint):Number
		{
			var factor:Number = 1;
			for (var i:uint = 0; i < length; i ++)
			{
				factor *= 10;
			}
			
			return Math.ceil(value * factor) / factor; 
		}
		
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			return Math.max(Math.min(value, max), min);
		}
		
		/**
		 * 按照保留小数点的位数向下取整
		 */		
		public static function floor(value:Number, length:uint):Number
		{
			var factor:Number = 1;
			for (var i:uint = 0; i < length; i ++)
			{
				factor *= 10;
			}
			
			return Math.floor(value * factor) / factor; 
		}
		
		/**
		 * 求以2为底的对数
		 */		
		public static function log2(value:Number):Number
		{
			return Math.log(value) / Math.LN2;
		}
		
		/**
		 * 求以2为底的次幂
		 */		
		public static function exp2(value:Number):Number
		{
			return Math.pow(2, value);
		}
		
		/**
		 * 求以3为底的对数
		 */		
		public static function log3(value:Number):Number
		{
			return Math.log(value) / MathUtil.LN3;
		}
		
		/**
		 * 求以3为底的次幂
		 */		
		public static function exp3(value:Number):Number
		{
			return Math.pow(3, value);
		}
		
		public static function log10(value:Number):Number
		{
			return Math.log(value) / Math.LN10;
		}
		
		public static const LN3:Number = Math.log(3);
	}
}