package com.kvs.ui.clickMove
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 控制元素的拖动，当元件被拖动后，鼠标释放时，告知原件被点击；
	 */	
	public class ClickMoveControl
	{
		/**
		 *
		 * @moveTarget 被拖动的对象
		 *  
		 * @param target 实拖动接口的对象；
		 * 
		 */		
		public function ClickMoveControl(target:IClickMove, moveTarget:Sprite)
		{
			this.target = target;
			this.moveTarget = moveTarget;
			
			this.moveTarget.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		}
		
		/**
		 */		
		private var moveTarget:Sprite;
		
		/**
		 * 开始移动屏幕
		 */		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			ifMoving = false;
			
			mouseDownX = startX = moveTarget.stage.mouseX;
			mouseDownY = startY = moveTarget.stage.mouseY;
			
			moveTarget.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, 0, true);
			moveTarget.stage.addEventListener(MouseEvent.MOUSE_UP, stopMoveCanvas, false, 0, true);
			
			clickTarget = evt.target;
		}
		
		//鼠标点下时当前的触碰对象
		public var clickTarget:Object;
		
		/**
		 * 屏幕移动过程
		 */		
		private function moveHandler(evt:MouseEvent):void
		{
			if(!ifMoving)
			{
				ifMoving = (Math.pow(moveTarget.stage.mouseX - mouseDownX, 2) + Math.pow(moveTarget.stage.mouseY - mouseDownY, 2) > dragPreventClickDistance * dragPreventClickDistance);
				if (ifMoving)
					target.startDragMove();
			}
			
			if (ifMoving)
			{
				var disX:Number = moveTarget.stage.mouseX - startX;
				var disY:Number = moveTarget.stage.mouseY - startY;
				
				target.moveOff(disX, disY);
				
				startX = moveTarget.stage.mouseX;
				startY = moveTarget.stage.mouseY;
				
				// 让移动更平滑
				evt.updateAfterEvent();
			}
			
		}
		
		/**
		 * 停止移动屏幕
		 */		
		public function stopMoveCanvas(evt:MouseEvent = null):void
		{
			moveTarget.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			moveTarget.stage.removeEventListener(MouseEvent.MOUSE_UP, stopMoveCanvas);
			
			if (ifMoving)
			{
				ifMoving = false;
				target.stopDragMove();
			}
			else
			{
				target.clicked();
			}
		}
		
		/**
		 * 被移动过的原件不会触发  clicked 方法
		 */		
		private var ifMoving:Boolean = false;
		
		/**
		 * 鼠标拖动影响点击事件的距离
		 */
		public var dragPreventClickDistance:Number = 3;
		
		/**
		 */		
		private var startX:Number = 0;
		
		/**
		 */		
		private var startY:Number = 0;
		
		private var mouseDownX:Number;
		
		private var mouseDownY:Number;
		
		/**
		 */		
		private var target:IClickMove;
	}
}