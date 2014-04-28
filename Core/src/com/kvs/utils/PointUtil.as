package com.kvs.utils
{
	import flash.geom.Point;

	public class PointUtil
	{
		/**
		 * point围绕origin旋转一定弧度
		 * 
		 */
		public static function rotate($point:Point, $radian:Number, $origin:Point = null):void
		{
			if(!$origin) $origin = origin;
			var vector:Point = $point.subtract($origin);
			var cos:Number = Math.cos($radian);
			var sin:Number = Math.sin($radian);
			$point.setTo(vector.x * cos - vector.y * sin + $origin.x, vector.x * sin + vector.y * cos + $origin.y);
		}
		/**
		 * point乘以一个数值，会改变该点的坐标
		 * 
		 */
		public static function multiply(point:Point, scale:Number):void
		{
			point.x *= scale;
			point.y *= scale;
		}
		
		public static const origin:Point = new Point;
	}
}