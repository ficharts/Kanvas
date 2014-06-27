package view.ui
{
	import com.greensock.TweenMax;
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import view.screenState.FullScreenState;
	import view.screenState.NormalScreenState;
	import view.screenState.ScreenStateBase;
	
	/**
	 */	
	public class MainUIBase extends Sprite
	{
		public function MainUIBase()
		{
			super();
			
			normalState     = new NormalScreenState(this);
			fullscreenState = new FullScreenState(this);
			curScreenState  = normalState;
			
			// 背景颜色
			addChild(bgColorCanvas = new Sprite);
			addChild(bgImageCanvas = new Sprite);
			bgImageCanvas.mouseEnabled = bgImageCanvas.mouseChildren = false;
			
			addChild(canvas = new Canvas(this));
		}
		
		
		/**
		 */		
		public var curScreenState:ScreenStateBase; 
		
		/**
		 */		
		public var normalState:ScreenStateBase;
		
		/**
		 */		
		public var fullscreenState:ScreenStateBase;
		
		
		
		/**
		 * 画布, 绘制背景图片，图形，文字，线条的地方
		 */
		public function get canvas():Canvas
		{
			return __canvas;
		}
		
		/**
		 * @private
		 */
		public function set canvas(value:Canvas):void
		{
			__canvas = value;
		}
		
		/**
		 */		
		private var __canvas:Canvas;
		
		
		
		/**
		 * 画布自动缩放的范围(剔除工具条，面板等)
		 */
		public function get bound():Rectangle
		{
			return __bound;
		}
		
		/**
		 * @private
		 */
		public function set bound(value:Rectangle):void
		{
			__bound = value;
			
			__boundDiagonalDistance = RectangleUtil.getDiagonalDistance(bound);
			
			fitBgContentToBound();
			synBgContentToCanvas();
			dispatchEvent(new KVSEvent(KVSEvent.UPATE_BOUND));
		}
		
		/**
		 */		
		private var __bound:Rectangle;
		
		/**
		 */		
		public function get stageBound():Rectangle
		{
			return __stageBound;
		}
		
		/**
		 */		
		public function set stageBound(value:Rectangle):void
		{
			lastBound = __stageBound;
			__stageBound = value;
			
			updateCanvasCenter();
			synBgContentToCanvas();
		}
		
		private var __stageBound:Rectangle;
		
		private var lastBound:Rectangle;
		
		public function get boundDiagonalDistance():Number
		{
			return  __boundDiagonalDistance;
		}
		
		private var __boundDiagonalDistance:Number;
		
		
		/**
		 * 用来绘制背景色, 接收鼠标交互，控制画布行为
		 */
		public function get bgColorCanvas():Sprite
		{
			return __bgColorCanvas;
		}
		
		/**
		 * @private
		 */
		public function set bgColorCanvas(value:Sprite):void
		{
			__bgColorCanvas = value;
		}
		
		/**
		 */		
		private var __bgColorCanvas:Sprite;
		
		
		
		
		/**
		 * 在画布的正中心绘制背景图片
		 */		
		public function drawBGImg(data:Object):void
		{
			// 图片数据为空时，仅删除背景图
			if (bgImageContent && bgImageCanvas.contains(bgImageContent))
				bgImageCanvas.removeChild(bgImageContent);
			
			if (data)
			{
				if (data is BitmapData)
				{
					var bitmap:Bitmap = new Bitmap(BitmapData(data));
					bitmap.smoothing = true;
					bgImageCanvas.addChild(bgImageContent = bitmap);
					
				}
				else if (data is DisplayObject)
					bgImageCanvas.addChild(bgImageContent = DisplayObject(data));
				
				fitBgContentToBound(false);
				synBgContentToCanvas();
			}
		}
		
		/**
		 */		
		private function fitBgContentToBound(tween:Boolean = true):void
		{
			if (bgImageContent)
			{
				var vw:Number = bound.width;
				var vh:Number = bound.height;
				var ow:Number = bgImageContent.width  / bgImageContent.scaleX;
				var oh:Number = bgImageContent.height / bgImageContent.scaleY;
				var sa:Number = ((ow / oh > vw / vh) ? vw / ow : vh / oh) * 32;
				var xa:Number = ow * sa * -.5;
				var ya:Number = oh * sa * -.5;
				if (tween)
				{
					TweenMax.to(bgImageContent, .3, {
						scaleX: sa, 
						scaleY: sa, 
						x: xa, y: ya});
				}
				else
				{
					bgImageContent.scaleX = bgImageContent.scaleY = sa;
					bgImageContent.x = xa;
					bgImageContent.y = ya;
				}
			}
		}
		
		/**
		 * 同步canvas与背景图片的比例位置关系， 此方法在初始化， 插入背景图和画布缩放
		 * 
		 * 及移动时需要被调用
		 */		
		public function synBgContentToCanvas():void
		{
			bgImageCanvas.rotation = canvas.rotation;
			if (canvas.scaleX > 1)
			{
				bgImageCanvas.scaleX = bgImageCanvas.scaleY = Math.pow(canvas.scaleX, .1);
				var wc:Number = bound.x + bound.width  * .5;
				var hc:Number = bound.y + bound.height * .5;
				var wo:Number = canvas.x - wc;
				var ho:Number = canvas.y - hc;
				var si:Number = bgImageCanvas.scaleX / canvas.scaleX;
				bgImageCanvas.x = wc + wo * si;
				bgImageCanvas.y = hc + ho * si;
			}
			else
			{
				bgImageCanvas.scaleX = bgImageCanvas.scaleY = canvas.scaleX;
				bgImageCanvas.x = canvas.x;
				bgImageCanvas.y = canvas.y;
			}
			
			if (bgImageContent && bgImageContent is Bitmap)
			{
				Bitmap(bgImageContent).smoothing = ! ((bgImageCanvas.width < bound.width * 2) && 
					(bgImageContent.width / bgImageContent.scaleX > bound.width));
			}
			//trace("scale:", bgImageCanvas.scaleX, canvas.scaleX);
			//trace("x:", bgImageCanvas.x, canvas.x);
			//trace("y:", bgImageCanvas.y, canvas.y);
		}
		
		/**
		 */		
		private function updateCanvasCenter():void
		{
			if (lastBound)
			{
				var lastCenter:Point = new Point((lastBound.left + lastBound.right) * .5, (lastBound.top + lastBound.bottom) * .5);
				var center:Point = new Point((stageBound.left + stageBound.right) * .5, (stageBound.top + stageBound.bottom) * .5);
				var vector:Point = center.subtract(lastCenter);
				canvas.x += vector.x;
				canvas.y += vector.y;
			}
			else
			{
				canvas.x = (bound.left + bound.right) * .5;
				canvas.y = (bound.top + bound.bottom) * .5;
			}
		}
		
		/**
		 */		
		public var bgImageCanvas:Sprite;
		
		private var bgImageContent:DisplayObject;
	}
}