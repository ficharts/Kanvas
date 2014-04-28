package landray.kp.maps.main.elements
{
	import com.kvs.ui.toolTips.ITipsSender;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	
	import util.LayoutUtil;
	
	import view.element.IElement;
	import view.ui.Canvas;
	import view.ui.ICanvasLayout;
	
	/**
	 * 
	 * @author wallenMac
	 * 
	 * 元素的基类
	 * 
	 */	
	public class Element extends Sprite implements ITipsSender, ICanvasLayout, IElement
	{
		public function Element($vo:ElementVO)
		{
			super();
			vo = $vo;
			init();
		}
		
		/**
		 */		
		private function init():void
		{
			addChild(_shape = new Shape);
			
			mouseChildren = false;
			
			if (vo.style) 
				render();
		}
		
		public function render():void
		{
			if(!rendered)
			{
				rendered = true;
				mouseEnabled = buttonMode = related;
				updateLayout();
				
				if (vo.style) 
				{
					// 中心点为注册点
					vo.style.tx =　-　vo.width  * .5;
					vo.style.ty =　-　vo.height * .5;
					vo.style.width  = vo.width;
					vo.style.height = vo.height;
				}
				graphics.clear();
			}
		}
		
		/**
		 * 更新布局范围。
		 */
		public function updateLayout():void
		{
			x = vo.x;
			y = vo.y;
			
			rotation = vo.rotation;
			scaleX = scaleY = vo.scale;
		}
		
		public function toShotcut(renderable:Boolean = false):void
		{
			
		}
		
		public function toPreview(renderable:Boolean = false):void
		{
			
		}
		
		public function get related():Boolean
		{
			return vo.property.toLocaleLowerCase() == "true";
		}
		
		
		
		
		//-----------------------------------------------------------
		//
		// CanvasLayout
		//
		//-----------------------------------------------------------
		
		public function get index():int
		{
			return (parent) ? parent.getChildIndex(this) : -1;
		}
		
		public function get scaledWidth ():Number
		{
			var w:Number = vo.width * vo.scale;
			if(vo.style && vo.style.getBorder)
				w += vo.thickness * vo.scale;
			return 	w;
		}
		
		public function get scaledHeight():Number
		{
			var h:Number = vo.height * vo.scale;
			if(vo.style && vo.style.getBorder)
				h += vo.thickness * vo.scale;
			return h;	
		}
			
		protected function caculateTransform(point:Point):Point
		{
			var rx:Number = point.x * cos - point.y * sin;
			var ry:Number = point.x * sin + point.y * cos;
			point.x = rx + x;
			point.y = ry + y;
			return point;
		}
			
		public function get topLeft():Point
		{
			tlPoint.x = - .5 * vo.scale * vo.width;
			tlPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tlPoint);
		}
		protected var tlPoint:Point = new Point;
		
		public function get topCenter():Point
		{
			tcPoint.x = 0;
			tcPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tcPoint);
		}
		protected var tcPoint:Point = new Point;
		
		public function get topRight():Point
		{
			trPoint.x =   .5 * vo.scale * vo.width;
			trPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(trPoint);
		}
		protected var trPoint:Point = new Point;
		
		public function get middleLeft():Point
		{
			mlPoint.x = - .5 * vo.scale * vo.width;
			mlPoint.y = 0;
			return caculateTransform(mlPoint);
		}
		protected var mlPoint:Point = new Point;
		
		public function get middleCenter():Point
		{
			mcPoint.x = x;
			mcPoint.y = y;
			return mcPoint;
		}
		protected var mcPoint:Point = new Point;
		
		public function get middleRight():Point
		{
			mrPoint.x = .5 * vo.scale * vo.width;
			mrPoint.y = 0;
			return caculateTransform(mrPoint);
		}
		protected var mrPoint:Point = new Point;
		
		public function get bottomLeft():Point
		{
			blPoint.x = - .5 * vo.scale * vo.width;
			blPoint.y =   .5 * vo.scale * vo.height;
			return caculateTransform(blPoint);
		}
		protected var blPoint:Point = new Point;
		
		public function get bottomCenter():Point
		{
			bcPoint.x = 0;
			bcPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(bcPoint);
		}
		protected var bcPoint:Point = new Point;
		
		public function get bottomRight():Point
		{
			brPoint.x = .5 * vo.scale * vo.width;
			brPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(brPoint);
		}
		protected var brPoint:Point = new Point;
			
		public function get left():Number
		{
			return x - .5 * vo.scale * vo.width;
		}
		
		public function get right():Number
		{
			return x + .5 * vo.scale * vo.width;
		}
		
		public function get top():Number
		{
			return y - .5 * vo.scale * vo.height;
		}
		
		public function get bottom():Number
		{
			return y + .5 * vo.scale * vo.height;
		}
		
		public function get screenshot():Boolean
		{
			return false;
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
		
		
		
		
		
		//-----------------------------------------------------------
		//
		// Tip
		//
		//-----------------------------------------------------------
		
		public function get tips():String
		{
			return __tips;
		}
		
		public function set tips(value:String):void
		{
			__tips = value;
		}
		
		private var __tips:String;
		
		public function get tipWidth():Number
		{
			return __tipWidth;
		}
		
		public function set tipWidth(value:Number):void
		{
			__tipWidth = value;
		}
		
		private var __tipWidth:Number;
		
		override public function get graphics():Graphics
		{
			return _shape.graphics;
		}
		
		private function get canvas():Canvas
		{
			return (parent is Canvas) ? parent as Canvas : null;
		}
		
		/**
		 */		
		private var _vo:ElementVO;

		/**
		 * 对应的ＶＯ结构体。
		 */
		public function get vo():ElementVO
		{
			return _vo;
		}

		/**
		 * @private
		 */
		public function set vo(value:ElementVO):void
		{
			_vo = value;
		}
		
		/**
		 */		
		public function get shape():DisplayObject
		{
			return _shape;
		}
		
		private var _shape:Shape;
		
		protected var rendered:Boolean;
	}
}