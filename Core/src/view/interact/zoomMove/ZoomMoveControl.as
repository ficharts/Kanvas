package view.interact.zoomMove
{
	import com.greensock.easing.*;
	
	import model.vo.ElementVO;
	import model.vo.PageVO;
	
	import modules.pages.PageUtil;
	import modules.pages.Scene;
	
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;

	/**
	 * 
	 */	
	public class ZoomMoveControl
	{
		public function ZoomMoveControl(uiMediator:IMainUIMediator)
		{
			this.mainUI = uiMediator.mainUI;
			this.uiMediator = uiMediator;
			
			flasher = new Flasher(this);
			zoomer = new Zoommer(this);
			mover = new Mover(this);
		}
		
		/**
		 * 开启滚动拖放 
		 */		
		public function enable():void
		{
			_enable = true;
			enableBGInteract();
		}
		
		/**
		 * 关闭滚动拖放, 此时画布不可以被拖动，缩放 
		 */		
		public function disable():void
		{
			_enable = false;
			disableBgInteract();
		}
		
		/**
		 */		
		private var _enable:Boolean = true;
		
		/**
		 * 将镜头对焦到元素上
		 */		
		public function zoomElement(elementVO:ElementVO,yOff:uint = 0):void
		{
			if (elementVO)
			{
				var scene:Scene = PageUtil.getSceneFromVO(elementVO, mainUI);
				zoomRotateMoveTo(scene.scale, scene.rotation, scene.x, scene.y + yOff);
			}
		}
		
		
		/**
		 * 画布缩放偏移一定的scale, x, y
		 *  
		 * @param scale
		 * @param x
		 * @param y
		 * @param time
		 * @param ease
		 * 
		 */		
		public function zoomMoveOff(scale:Number, x:Number, y:Number, time:Number = 1, ease:Object = null):void
		{
			if (ease == null)
				ease = Cubic.easeInOut;
			
			zoomer.zoomMoveOff(scale, x, y, time, ease);
		}
		
		
		/**
		 * 画布缩放，旋转，移动 页面播放时的镜头动画
		 * 
		 * @param scale
		 * @param rotation
		 * @param x
		 * @param y
		 * @param ease
		 * 
		 */
		public function zoomRotateMoveTo(scale:Number, rotation:Number, x:Number, y:Number, ease:Object = null, time:Number = NaN):void
		{
			if (ease == null)
				ease = Cubic.easeInOut;
			
			zoomer.zoomRotateMoveTo(scale, rotation, x, y, ease, time);
		}
		
		/**
		 */		
		public function zoomIn(center:* = false):void
		{
			if (_enable)
				zoomer.zoomIn(center);
		}
		
		/**
		 */		
		public function zoomOut(center:* = false):void
		{
			if (_enable)
				zoomer.zoomOut(center);
		}
		
		/**
		 */		
		public function zoomAuto(originalScale:Boolean = false):void
		{
			if (_enable)
				zoomer.zoomAuto(originalScale);
		}
		
		/**
		 * 生效背景交互
		 */		
		public function enableBGInteract():void
		{
			mover.ifEnable = true;
		}
		
		/**
		 * 禁止背景交互
		 */		
		public function disableBgInteract():void
		{
			mover.ifEnable = false;
		}
		
		public function get isTweening():Boolean
		{
			return flasher.isFlashing;
		}
		
		public function set isTweening(value:Boolean):void
		{
			flasher.isFlashing = value;
		}
		
		/**
		 */		
		private function get canvas():Canvas
		{
			return mainUI.canvas;
		}
		
		/**
		 * 鼠标滚轮滑动时的倍数
		 */		
		public var zoomScale:Number = 1.5;
		
		/**
		 * 每秒缩放倍数 
		 */		
		public var speedScale:Number = 2;
		
		/**
		 * 每秒旋转90度 
		 */		
		public var speedRotation:Number = 90;
		
		/**
		 * 
		 */		
		public var maxTweenTime:Number = 10;
		
		/**
		 * 
		 */		
		public var minTweenTime:Number = 1.3;
		
		/**
		 * 
		 */		
		public var gestureControl:Boolean = false;
		
		/**
		 * 默认不管画布中的元素有多大都自动对焦， 关闭后则
		 * 
		 * 大于1:1下画布尺寸时才自动对焦，缩小画布比例适应内容；
		 * 
		 * 小于画布默认尺寸时仅居中对齐
		 */		
		public var ifAutoZoom:Boolean = true;
		
		/**
		 * 移动画布时，吃属性会开启；用来判断防止按下Control时进入多选状态 
		 */		
		public var isMoving:Boolean = false;
		
		/**
		 */		
		internal var flasher:Flasher;
		
		/**
		 */		
		private var zoomer:Zoommer;
		
		/**
		 */		
		private var mover:Mover;
		
		/**
		 */		
		internal var mainUI:MainUIBase;
		
		/**
		 */		
		internal var uiMediator:IMainUIMediator;
	}
}