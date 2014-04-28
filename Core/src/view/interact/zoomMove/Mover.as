package view.interact.zoomMove
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * 画布背景上的交互控制
	 * 
	 * 画布背景上的点击会引发3中可能：释放图形选择状态，创建文本，拖动画布；
	 * 
	 * 
	 * 此类配合画布编辑控制器实现画布缩放拖动，图形选择/释放，文字创建等交互动作
	 * 
	 * 
	 * 画布编辑控制器有两种状态，图形选择状态和未选择状态，画布上的点击会对其产生不同的效果：
	 * 
	 * 图形选择状态时，释放选择状态；图形未选择状态时，创建文本框；
	 * 
	 * 
	 * */
	public class Mover implements IClickMove
	{
		/**
		 * 记录坐标
		 */		
		private var startPoint:Point = new Point();
		
		/**
		 * 要移动的画布
		 */
		private var canvas:Sprite;
		
		/**
		 */		
		public function Mover(control:ZoomMoveControl)
		{
			this.control = control;
			
			clickMoveControl = new ClickMoveControl(this, control.mainUI.canvas.interactorBG);
			clickMoveControlForCanvasDisable = new ClickMoveControl(this, control.mainUI.bgColorCanvas);
		}
		
		/**
		 * 画布缩放的过程中是无法接收拖动控制的，所以增添了另一个拖动控制器，他只有在
		 * 
		 * 画布缩放的过程中才能发挥作用
		 */		
		private var clickMoveControlForCanvasDisable:ClickMoveControl;
		
		/**
		 */		
		private var control:ZoomMoveControl;
		
		/**
		 */		
		private function get flasher():Flasher
		{
			return control.flasher;
		}
		
		/**
		 */		
		public function startMove():void
		{
			if (ifEnable)
			{
				flasher.ready();
			}
			
			control.isMoving = true;
		}
		
		/**
		 */		
		public function stopMove():void
		{
			control.isMoving = false;
		}
		
		/**
		 * 屏幕移动过程
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			if (ifEnable)
			{
				flasher.canvasTargetX += xOff;
				flasher.canvasTargetY += yOff;
				flasher.flash(0.15);
			}
		}
		
		/**
		 */		
		public function clicked():void
		{
			if (ifEnable)
				control.mainUI.curScreenState.bgClicked(control.uiMediator);
		}
		
		/**
		 * 是否允许点击和拖动画布生效
		 * 
		 * 在多选模式下，框选与画布操作有冲突，
		 * 
		 * 需要临时关掉画布操作
		 */		
		public var ifEnable:Boolean = true;
		
		/**
		 */		
		private var clickMoveControl:ClickMoveControl;
		
		
	}
}