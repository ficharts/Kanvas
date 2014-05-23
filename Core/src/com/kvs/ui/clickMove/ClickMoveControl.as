package com.kvs.ui.clickMove
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.gestouch.core.GestureState;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TransformGesture;

	/**
	 * 控制元素的拖动，当元件被拖动后，鼠标释放时，告知原件被点击；
	 */	
	public class ClickMoveControl
	{
		/**
		 * 构造一个可点击移动的控制，支持多点触控.
		 * 
		 * @param target 实拖动接口的对象；
		 * @param moveTarget 被拖动的对象
		 */		
		public function ClickMoveControl($target:IClickMove, $moveTarget:Sprite)
		{
			target = $target;
			moveTarget = $moveTarget;
			
			//添加鼠标控制
			moveTarget.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			
			//添加手势控制
			//gesture = new TransformGesture(moveTarget);
			//gesture.addEventListener(GestureEvent.GESTURE_BEGAN, gestureBeginHandler);
		}
		
		
		//------------------------------------------------------------
		//
		// 鼠标控制
		//
		//------------------------------------------------------------
		
		/**
		 * 开始移动屏幕
		 */		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			//if (useGesture) return;
			
			//useMouse = true;
			ifMoving = false;
			
			mouseDownX = startX = moveTarget.stage.mouseX;
			mouseDownY = startY = moveTarget.stage.mouseY;
			
			moveTarget.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			moveTarget.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			
			clickTarget = evt.target;
		}
		
		/**
		 * 屏幕移动过程
		 */		
		private function mouseMoveHandler(evt:MouseEvent):void
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
		private function mouseUpHandler(evt:MouseEvent):void
		{
			moveTarget.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			moveTarget.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			if (ifMoving)
			{
				ifMoving = false;
				target.stopDragMove();
			}
			else
			{
				target.clicked();
			}
			
			//useGesture = useMouse = false;
		}
		
		//------------------------------------------------------------
		//
		// 手势控制
		//
		//------------------------------------------------------------
		
		/*
		private function gestureBeginHandler(evt:GestureEvent):void
		{
			if (useMouse) return;
			trace("gestureBegin")
			useGesture = true;
			ifMoving = false;
			
			if (gesture.touchesCount == 1)
			{
				clickTarget = gesture.touch1.target;
				
				startX = gesture.touch1.location.x;
				startY = gesture.touch1.location.y;
					
				gesture.addEventListener(GestureEvent.GESTURE_CHANGED, gestureChangeHandler);
			}
			
		}
		
		private function gestureChangeHandler(evt:GestureEvent):void
		{
			if (evt.newState == GestureState.CANCELLED || 
				evt.newState == GestureState.FAILED || 
				evt.newState == GestureState.ENDED || 
				evt.newState == GestureState.POSSIBLE)
			{
				trace("gestureEnd")
				gesture.removeEventListener(GestureEvent.GESTURE_CHANGED, gestureChangeHandler);
				
				if (ifMoving)
				{
					ifMoving = false;
					target.stopDragMove();
				}
				else
				{
					target.clicked();
				}
				
				useGesture = useMouse = false;
				
			}
			else
			{
				if (gesture.touchesCount == 1)
				{
					trace("gestureMove")
					if(!ifMoving)
					{
						ifMoving = true;
						target.startDragMove();
					}
					
					target.moveOff(gesture.offsetX, gesture.offsetY);
				}
			}
		}
		*/
		
		/**
		 * 鼠标拖动影响点击事件的距离
		 */
		public var dragPreventClickDistance:Number = 3;
		
		/**
		 * 鼠标点下时当前的响应对象
		 */
		public var clickTarget:Object;
		
		/**
		 */		
		private var startX:Number = 0;
		
		/**
		 */		
		private var startY:Number = 0;
		
		private var mouseDownX:Number;
		
		private var mouseDownY:Number;
		
		//private var useMouse:Boolean;
		
		//private var useGesture:Boolean;
		
		/**
		 * 被移动过的原件不会触发  clicked 方法
		 */		
		private var ifMoving:Boolean = false;
		
		/**
		 */		
		private var moveTarget:Sprite;
		
		/**
		 * 拖动手势
		 */	
		//private var gesture:TransformGesture;
		
		/**
		 */		
		private var target:IClickMove;
	}
}