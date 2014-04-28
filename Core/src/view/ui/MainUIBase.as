package view.ui
{
	import com.greensock.TweenMax;
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
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
			
			fitBgBitmapToBound();
			synBgImageToCanvas();
			dispatchEvent(new KVSEvent(KVSEvent.UPATE_BOUND));
		}
		
		/**
		 */		
		private var __bound:Rectangle;
		
		public function get stageBound():Rectangle
		{
			return null;
		}
		
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
		 * 同步canvas与背景图片的比例位置关系， 此方法在初始化， 插入背景图和画布缩放
		 * 
		 * 及移动时需要被调用
		 */		
		public function synBgImageToCanvas():void
		{
			bgImageCanvas.scaleX = bgImageCanvas.scaleY = Math.pow(canvas.scaleX, .1);
			bgImageCanvas.rotation = canvas.rotation;
			var p:Number =  Math.pow(1 / (1 + canvas.scaleX), 2);
			var hw:Number = stage.stageWidth  * .5;
			var hh:Number = stage.stageHeight * .5;
			bgImageCanvas.x = hw + (canvas.x - hw) * p;
			bgImageCanvas.y = hh + (canvas.y - hh) * p;
		}
		
		
		/**
		 * 在画布的正中心绘制背景图片
		 */		
		public function drawBGImg(bmd:BitmapData):void
		{
			// 图片数据为空时，仅删除背景图
			if (bgImageBitmap && bgImageCanvas.contains(bgImageBitmap))
				bgImageCanvas.removeChild(bgImageBitmap);
			
			if (bmd)
			{
				bgImageBitmap = new Bitmap(bmd);
				bgImageBitmap.x = -.5 * bgImageBitmap.width;
				bgImageBitmap.y = -.5 * bgImageBitmap.height;
				bgImageCanvas.addChild(bgImageBitmap);
				fitBgBitmapToBound();
				synBgImageToCanvas();
			}
		}
		
		private function fitBgBitmapToBound():void
		{
			if (bgImageBitmap && bound)
			{
				var vw:Number = bound.width;
				var vh:Number = bound.height;
				var bw:Number = bgImageBitmap.width  / bgImageBitmap.scaleX;
				var bh:Number = bgImageBitmap.height / bgImageBitmap.scaleY;
				var ss:Number = 1.5 * ((vw / vh > bw / bh) ? vw / bw : vh / bh);
				TweenMax.to(bgImageBitmap, 1, {scaleX:ss, scaleY:ss, x:-.5 * bw * ss, y:-.5 * bh * ss});
			}
		}
		
		/**
		 */		
		public var bgImageCanvas:Sprite;
		private var bgImageBitmap:Bitmap;
	}
}