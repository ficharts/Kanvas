package view.interact.zoomMove
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.gestouch.core.GestureState;
	import org.gestouch.core.gestouch_internal;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.MultiTransformGesture;
	import org.gestouch.gestures.TransformGesture;
	
	import util.CoreUtil;
	
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;
	
	public final class NewGestureControl
	{
		public function NewGestureControl($mediator:IMainUIMediator, $control:ZoomMoveControl)
		{
			mediator = $mediator;
			mainUI = mediator.mainUI;
			canvas = mediator.mainUI.canvas;
			
			control = $control;
			
			gesture = new MultiTransformGesture(mainUI);
			gesture.addEventListener(GestureEvent.GESTURE_BEGAN, onGestureBegin);
			gesture.addEventListener(GestureEvent.GESTURE_CHANGED, onGestureChange);
		}
		
		private function onGestureBegin(e:GestureEvent):void
		{
			
			
		}
		
		private function onGestureChange(e:GestureEvent):void
		{
			trace(e.newState, gesture.touchesCount)
			if (e.newState.gestouch_internal::isEndState)
			{
				flashStop();
			}
			else
			{
				if (gesture.touchesCount >= 2)
				{
					flashPlay();
					if (gesture.touchesCount == 2)
					{
						CoreUtil.clear();
						CoreUtil.drawCircle(0xFF0000, gesture.touch1.location, 2);
						CoreUtil.drawCircle(0x0000FF, gesture.touch2.location, 2);
						
						
						//enable scale rotate
						temp.x = canvas.x;
						temp.y = canvas.y;
						temp.scaleX = temp.scaleY = canvas.scaleX;
						temp.rotation = canvas.rotation;
						
						var matrix:Matrix = temp.transform.matrix;
						matrix.translate(gesture.offsetX, gesture.offsetY);
						
						if (gesture.scale != 1 || gesture.rotation != 0)
						{
							// Scale and rotation.
							var transformPoint:Point = matrix.transformPoint(temp.globalToLocal(gesture.location));
							matrix.translate(-transformPoint.x, -transformPoint.y);
							matrix.rotate(gesture.rotation);
							matrix.scale(gesture.scale, gesture.scale);
							matrix.translate(transformPoint.x, transformPoint.y);
						}
						
						temp.transform.matrix = matrix;
						
						canvas.x = temp.x;
						canvas.y = temp.y;
						canvas.scaleX = canvas.scaleY = temp.scaleX;
						canvas.rotation = temp.rotation;
						
						//trace(gesture.offsetX, gesture.offsetY, gesture.scale, gesture.rotation);
						//trace("touch-canvas:", canvas.x, canvas.y, canvas.scaleX, canvas.rotation);
						
						flashTrek();
					}
					else
					{
						moveX += gesture.offsetX;
						moveY += gesture.offsetY;
						if (moveX > 100 || moveX < -100)
						{
							//翻页
							//trace("touch-move-x:", moveX);
							//flashStop();
						}
						else
						{
							if (moveY > 100 || moveY < -100)
							{
								//trace("touch-move-y:",moveY);
								//flashStop();
							}
						}
					}
				}
				else
				{
					flashStop();
				}
			}
		}
		
		private function flashPlay():void
		{
			if(!control.isTweening)
			{
				trace("flashPlay")
				control.isTweening = true;
				//2点以上触控模式下，禁用鼠标的拖动交互。
				control.disableBgInteract();
				control.mainUI.curScreenState.disableCanvas();
				mediator.flashPlay();
				moveX = moveY = 0;
			}
		}
		
		private function flashTrek():void
		{
			mainUI.synBgImageToCanvas();
			mediator.flashTrek();
		}
		
		private function flashStop():void
		{
			if (control.isTweening)
			{
				trace("flashStop")
				control.isTweening = false;
				//gesture.removeEventListener(GestureEvent.GESTURE_CHANGED, onGestureChange);
				control.enableBGInteract();
				control.mainUI.curScreenState.enableCanvas();
				gesture.reset();
				mediator.flashStop();
			}
		}
		
		private var mainUI:MainUIBase;
		
		private var canvas:Canvas;
		
		private var mediator:IMainUIMediator;
		
		private var gesture:MultiTransformGesture;
		
		private var control:ZoomMoveControl;
		
		private var temp:Sprite;
		
		private var transforming:Boolean;
		
		private var moveX:Number;
		private var moveY:Number;
	}
}