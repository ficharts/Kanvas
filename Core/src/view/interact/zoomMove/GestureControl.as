package view.interact.zoomMove
{
	import com.kvs.utils.PointUtil;
	
	import flash.geom.Point;
	
	import org.gestouch.core.gestouch_internal;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TransformGesture;
	
	import util.LayoutUtil;
	
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;
	
	public final class GestureControl
	{
		public function GestureControl($mediator:IMainUIMediator, $control:ZoomMoveControl)
		{
			mediator = $mediator;
			mainUI = mediator.mainUI;
			canvas = mediator.mainUI.canvas;
			
			control = $control;
			
			gesture = new TransformGesture(mainUI);
			gesture.addEventListener(GestureEvent.GESTURE_BEGAN, onBegin);
			gesture.addEventListener(GestureEvent.GESTURE_POSSIBLE, onPossible);
		}
		
		private function onBegin(e:GestureEvent):void
		{
			
			gesture.addEventListener(GestureEvent.GESTURE_CHANGED, onChange);
			gesture.addEventListener(GestureEvent.GESTURE_POSSIBLE, onPossible);
			
		}
		
		private function onPossible(e:GestureEvent):void
		{
			gesture.removeEventListener(GestureEvent.GESTURE_CHANGED, onChange);
			gesture.removeEventListener(GestureEvent.GESTURE_POSSIBLE, onPossible);
			if (started)
			{
				trace("onEnd:possible")
				setCanvasInteract(true);
				started = false;
			}
		}
		
		private function onChange(e:GestureEvent):void
		{
			if (e.newState.gestouch_internal::isEndState)
			{
				gesture.removeEventListener(GestureEvent.GESTURE_CHANGED, onChange);
				gesture.removeEventListener(GestureEvent.GESTURE_POSSIBLE, onPossible);
				setCanvasInteract(true);
				started = false;
				trace("onEnd:end state")
			}
			else
			{
				if (gesture.touchesCount == 2)
				{
					if(!started)
					{
						trace("onBegin:2 p")
						started = true;
						setCanvasInteract(false);
						canvasCenter = LayoutUtil.stagePointToElementPoint(gesture.location.x, gesture.location.y, canvas);
						offsetScale = canvas.scaleX;
						offsetRotation = canvas.rotation;
					}
					else
					{
						offsetScale *= gesture.scale;
						offsetRotation += gesture.rotation;
						
						var temp:Point = canvasCenter.clone();
						PointUtil.multiply(temp, offsetScale);
						//PointUtil.rotate(temp, MathUtil.angleToRadian(r));
						canvas.scaleX = canvas.scaleY = offsetScale;
						canvas.x = gesture.location.x - temp.x;
						canvas.y = gesture.location.y - temp.y;
						mediator.mainUI.synBgImageToCanvas();
						mediator.flashTrek();
						//control.zoomRotateMoveTo(offsetScale, canvas.rotation, gesture.location.x - temp.x, gesture.location.y - temp.y, null, 0);
					}
				}
				else
				{
					if (started)
					{
						trace("onEnd:1 p")
						setCanvasInteract(true);
						started = false;
					}
				}
			}
		}
		
		private var gesture:TransformGesture;
		private var started:Boolean;
		private var offsetScale:Number;
		private var offsetRotation:Number;
		
		private function setCanvasInteract(value:Boolean):void
		{
			if (value)
			{
				gesture.reset();
				gestureControl = false;
				control.enableBGInteract();
				control.mainUI.curScreenState.enableCanvas();
				mediator.flashStop();
			}
			else
			{
				gestureControl = true;
				control.disableBgInteract();
				control.mainUI.curScreenState.disableCanvas();
				mediator.flashPlay();
			}
		}
		
		
		private var mainUI:MainUIBase;
		
		private var canvas:Canvas;
		
		private var mediator:IMainUIMediator;
		
		private var control:ZoomMoveControl;
		
		private var canvasCenter:Point;
		
		public static var gestureControl:Boolean = false;
	}
}