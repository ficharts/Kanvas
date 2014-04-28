package util
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import view.ui.Canvas;
	import view.ui.ICanvasLayout;

	public final class LayoutUtil
	{
		/**
		 * canvas中的坐标点转换为stage场景的坐标点，返回一个新point。
		 * 
		 * @param x
		 * @param y
		 * @param canvas
		 * @param ignoreRotation
		 * @return 
		 * 
		 */
		public static function elementPointToStagePoint(x:Number, y:Number, canvas:Sprite, ignoreRotation:Boolean = false):Point
		{
			var result:Point = new Point(x, y);
			//缩放
			PointUtil.multiply(result, canvas.scaleX);
			//旋转
			if(!ignoreRotation)
				PointUtil.rotate(result, MathUtil.angleToRadian(canvas.rotation));
			//平移
			result.offset(canvas.x, canvas.y);
			
			return result;
		}
		
		/**
		 * stage场景的坐标点转换为canvas的坐标点， 返回一个新point。
		 * 
		 * @param x
		 * @param y
		 * @param canvas
		 * @param ignoreRotation
		 * @return 
		 * 
		 */
		public static function stagePointToElementPoint(x:Number, y:Number, canvas:Sprite, ignoreRotation:Boolean = false):Point
		{
			var result:Point = new Point(x, y);
			
			//平移
			result.offset(- canvas.x, - canvas.y);
			
			//旋转
			if(!ignoreRotation)
				PointUtil.rotate(result, MathUtil.angleToRadian(- canvas.rotation));
			
			//缩放
			PointUtil.multiply(result, 1 / canvas.scaleX);
			
			return result;
		}
		
		/**
		 * canvas中的坐标点转换为stage场景的坐标点，直接操作传入的参数point 
		 * @param point
		 * @param x
		 * @param y
		 * @param scale
		 * @param rotation
		 * 
		 */
		public static function convertPointCanvas2Stage(point:Point, x:Number, y:Number, scale:Number, rotation:Number):void
		{
			PointUtil.multiply(point, scale);
			PointUtil.rotate(point, MathUtil.angleToRadian(rotation));
			point.offset(x, y);
		}
		
		/**
		 * stage场景的坐标点转换为canvas的坐标点， 直接操作传入的参数point 
		 * @param point
		 * @param x
		 * @param y
		 * @param scale
		 * @param rotation
		 * 
		 */
		public static function convertPointStage2Canvas(point:Point, x:Number, y:Number, scale:Number, rotation:Number):void
		{
			point.offset(-x, -y);
			PointUtil.rotate(point, MathUtil.angleToRadian(-rotation));
			PointUtil.multiply(point, 1 / scale);
		}
		
		/**
		 * 获取canvas的宽高，toStage为是否针对舞台。
		 * 
		 * @param canvas
		 * @param toStage
		 * @return 
		 * 
		 */
		public static function getContentRect(canvas:Canvas, toStage:Boolean = true):Rectangle
		{
			var left  :Number = 0;
			var right :Number = 0;
			var top   :Number = 0;
			var bottom:Number = 0;
			var xArr:Array = [];
			var yArr:Array = [];
			var elements:Vector.<ICanvasLayout> = canvas.elements;
			if (elements && elements.length)
			{
				for each (var element:ICanvasLayout in elements)
				{
					var topLeft    :Point = element.topLeft    .clone();
					var topRight   :Point = element.topRight   .clone();
					var bottomLeft :Point = element.bottomLeft .clone();
					var bottomRight:Point = element.bottomRight.clone();
					if (toStage)
					{
						topLeft     = elementPointToStagePoint(topLeft    .x, topLeft    .y, canvas);
						topRight    = elementPointToStagePoint(topRight   .x, topRight   .y, canvas);
						bottomLeft  = elementPointToStagePoint(bottomLeft .x, bottomLeft .y, canvas);
						bottomRight = elementPointToStagePoint(bottomRight.x, bottomRight.y, canvas);
					}
					xArr.push(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
					yArr.push(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
				}
				left   = Math.min.apply(null, xArr);
				right  = Math.max.apply(null, xArr);
				top    = Math.min.apply(null, yArr);
				bottom = Math.max.apply(null, yArr);
			}
			return new Rectangle(left, top, right - left, bottom - top);
		}
		
		/**
		 * 获取item占位矩形。 
		 * 
		 * @param canvas
		 * @param item
		 * @param ignoreItemRotate 是否忽略item的旋转角度。
		 * @param ignoreCanvasRotate 是否忽略canvas的旋转角度。
		 * @param toStage 是否相对于舞台。
		 * @return Rectangle
		 * 
		 */
		public static function getItemRect(canvas:Canvas, 
										   item:ICanvasLayout, 
										   ignoreItemRotate  :Boolean = false, 
										   ignoreCanvasRotate:Boolean = false, 
										   toStage:Boolean = true):Rectangle
		{
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = 0;
			var h:Number = 0;
			var offsetX:Number = (toStage && canvas) ? canvas.x : 0;
			var offsetY:Number = (toStage && canvas) ? canvas.y : 0;
			var offsetScale   :Number = (toStage && canvas) ? canvas.scaleX : 1;
			var offsetRotation:Number = (toStage && canvas && !ignoreCanvasRotate) ? canvas.rotation : 0;
			if (!ignoreItemRotate)
			{
				var p1:Point = item.topLeft;
				var p2:Point = item.topRight;
				var p3:Point = item.bottomLeft;
				var p4:Point = item.bottomRight;
				LayoutUtil.convertPointCanvas2Stage(p1, offsetX, offsetY, offsetScale, offsetRotation);
				LayoutUtil.convertPointCanvas2Stage(p2, offsetX, offsetY, offsetScale, offsetRotation);
				LayoutUtil.convertPointCanvas2Stage(p3, offsetX, offsetY, offsetScale, offsetRotation);
				LayoutUtil.convertPointCanvas2Stage(p4, offsetX, offsetY, offsetScale, offsetRotation);
				var minX:Number = Math.min(p1.x, p2.x, p3.x, p4.x);
				var maxX:Number = Math.max(p1.x, p2.x, p3.x, p4.x);
				var minY:Number = Math.min(p1.y, p2.y, p3.y, p4.y);
				var maxY:Number = Math.max(p1.y, p2.y, p3.y, p4.y);
				x = minX;
				y = minY;
				w = maxX - minX;
				h = maxY - minY;
			}
			else
			{
				var point:Point = new Point(item.left, item.top);
				LayoutUtil.convertPointCanvas2Stage(point, offsetX, offsetY, offsetScale, offsetRotation);
				x = point.x;
				y = point.y;
				w = offsetScale * item.scaledWidth;
				h = offsetScale * item.scaledHeight;
			}
			return new Rectangle(x, y, w, h);
		}
		
		public static function getStageRect(stage:Stage):Rectangle
		{
			return (stage) ? new Rectangle(0, 0, stage.stageWidth, stage.stageHeight) : new Rectangle;
		}
	}
}