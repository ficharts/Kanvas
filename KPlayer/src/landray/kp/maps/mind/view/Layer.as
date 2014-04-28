package landray.kp.maps.mind.view
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
	import view.ui.Canvas;
	import view.ui.ICanvasLayout;
	
	public final class Layer extends Sprite implements ICanvasLayout
	{
		public function Layer()
		{
			super();
		}
		
		public function updateView(check:Boolean = true):void
		{
			if (check && stage)
			{
				var rect:Rectangle = LayoutUtil.getItemRect(canvas, this);
				if (rect.width < 1 || rect.height < 1)
				{
					super.visible = false;
				}
				else 
				{
					var boud:Rectangle = LayoutUtil.getStageRect(stage);
					super.visible = RectangleUtil.rectOverlapping(rect, boud);
				}
			}
			if (parent && visible)
			{
				var prtScale :Number = parent.scaleX;
				var prtRadian:Number = MathUtil.angleToRadian(parent.rotation);
				var prtCos:Number = Math.cos(prtRadian);
				var prtSin:Number = Math.sin(prtRadian);
				//scale
				var tmpX:Number = x * prtScale;
				var tmpY:Number = y * prtScale;
				//rotate, move
				super.rotation = parent.rotation + rotation;
				super.scaleX = prtScale * scaleX;
				super.scaleY = prtScale * scaleY;
				super.x = tmpX * prtCos - tmpY * prtSin + parent.x;
				super.y = tmpX * prtSin + tmpY * prtCos + parent.y;
			}
		}
		
		public function toShotcut(renderable:Boolean = false):void
		{
			
		}
		public function toPreview(renderable:Boolean = false):void
		{
			
		}
		
		public function get index():int
		{
			return (parent) ? parent.getChildIndex(this) : -1;
		}
		
		public function get scaledWidth():Number
		{
			return getRect(this).width;
		}
		
		public function get scaledHeight():Number
		{
			return getRect(this).height;
		}
		
		public function get topLeft():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(rect.left, rect.top));
		}
		
		public function get topCenter():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(0, rect.top));
		}
		
		public function get topRight():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(rect.right, rect.top));
		}
		
		public function get middleLeft():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(rect.left, 0));
		}
		
		public function get middleCenter():Point
		{
			var rect:Rectangle = getRect(this);
			return new Point(0, 0);
		}
		
		public function get middleRight():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(rect.right, 0));
		}
		
		public function get bottomLeft():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(rect.left, rect.bottom));
		}
		
		public function get bottomCenter():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(0, rect.bottom));
		}
		
		public function get bottomRight():Point
		{
			var rect:Rectangle = getRect(this);
			return caculateTransform(new Point(rect.right, rect.bottom));
		}
		
		public function get left():Number
		{
			var rect:Rectangle = getRect(this);
			return rect.left;
		}
		
		public function get right():Number
		{
			var rect:Rectangle = getRect(this);
			return rect.right;
		}
		
		public function get top():Number
		{
			var rect:Rectangle = getRect(this);
			return rect.top;
		}
		
		public function get bottom():Number
		{
			var rect:Rectangle = getRect(this);
			return rect.bottom;
		}
		
		public function get screenshot():Boolean
		{
			return false;
		}
		
		protected function caculateTransform(point:Point):Point
		{
			var rx:Number = point.x * cos - point.y * sin;
			var ry:Number = point.x * sin + point.y * cos;
			point.x = rx + x;
			point.y = ry + y;
			return point;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if (visible) updateView();
		}
		
		override public function get rotation():Number
		{
			return __rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			if (__rotation!= value)
			{
				__rotation = value;
				cos = Math.cos(MathUtil.angleToRadian(rotation));
				
				sin = Math.sin(MathUtil.angleToRadian(rotation));
				if (parent)
					value += parent.rotation;
				super.rotation = value;
			}
		}
		private var __rotation:Number = 0;
		
		private var cos:Number = Math.cos(0);
		private var sin:Number = Math.sin(0);
		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			if (__scaleX!= value)
			{
				__scaleX = value;
				if (parent)
					value *= parent.scaleX;
				super.scaleX = value;
			}
		}
		
		private var __scaleX:Number = 1;
		
		override public function get scaleY():Number
		{
			return __scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			if (__scaleY!= value)
			{
				__scaleY = value;
				if (parent)
					value *= parent.scaleY;
				super.scaleY = value;
			}
		}
		
		private var __scaleY:Number = 1;
		
		override public function get x():Number
		{
			return __x;
		}
		
		override public function set x(value:Number):void
		{
			if (__x!= value)
			{
				__x = value;
				updateView();
			}
		}
		
		private var __x:Number = 0;
		
		override public function get y():Number
		{
			return __y;
		}
		
		override public function set y(value:Number):void
		{
			if (__y!= value)
			{
				__y = value;
				updateView();
			}
		}
		
		private var __y:Number = 0;
		
		private function get canvas():Canvas
		{
			return (parent is Canvas) ? parent as Canvas : null;
		}
	}
}