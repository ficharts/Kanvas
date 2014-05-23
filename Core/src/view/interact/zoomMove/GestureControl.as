package view.interact.zoomMove
{
	import com.greensock.easing.Linear;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import modules.pages.PageManager;
	
	import util.LayoutUtil;
	
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;
	
	public final class GestureControl
	{
		public function GestureControl($mediator:IMainUIMediator, $control:ZoomMoveControl, $page:PageManager)
		{
			mediator = $mediator;
			mainUI = mediator.mainUI;
			canvas = mediator.mainUI.canvas;
			
			control = $control;
			
			page = $page;
			
			/*
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			mainUI.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			mainUI.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			mainUI.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			*/
		}
		
		private function onTouchBegin(e:TouchEvent):void
		{
			//trace("onTouchBegin: ", e.touchPointID, touchesCount + 1);
			//update touches
			if(!touchesMap[e.touchPointID])
			{
				var touch:Touch = new Touch;
				touch.id = e.touchPointID;
				touch.location.x = e.stageX;
				touch.location.y = e.stageY;
				touchesMap[e.touchPointID] = touch;
				touchesCount++;
				updateCenter();
			}
			if(!enabled) return;
			if (touchesCount > 1)
			{
				//disable mouse interact
				//trace("onTouchBegin: disable mouse interact");
				setCanvasInteract(false);
				if (touchesCount == 2)
				{
					//scale rotate mode
					//trace("onTouchBegin: scale rotate mode");
					recordStartCanvasLayout();
				}
				else
				{
					//swip mode
					//trace("onTouchBegin: swipe mode");
					startSwipe = center.clone();
				}
			}
		}
		
		private function onTouchMove(e:TouchEvent):void
		{
			//trace("onTouchMove: ", e.touchPointID, touchesCount);
			//update touches
			if (touchesMap[e.touchPointID])
			{
				var touch:Touch = touchesMap[e.touchPointID];
				touch.prevLocation.setTo(touch.location.x, touch.location.y);
				touch.location.x = e.stageX;
				touch.location.y = e.stageY;
				updateCenter();
			}
			if(!enabled) return;
			if (touchesCount == 2)
			{
				//scale rotate mode
				//trace("onTouchMove: scale rotate mode");
				var touches:Vector.<Touch> = new Vector.<Touch>;
				for each(touch in touchesMap)
					touches[touches.length] = touch;
				
				var currtVector:Point = touches[1].location.subtract(touches[0].location);
				//CoreUtil.clear();
				//CoreUtil.drawLine(0x0000FF, touches[1].prevLocation, touches[0].prevLocation);
				//CoreUtil.drawLine(0xFF0000, touches[1].location, touches[0].location);
				var scale:Number = currtVector.length / startVector.length;
				//trace("onTouchMove: ", scale)
				var s:Number = startScale * scale;
				var r:Number = startRotation + MathUtil.radianToAngle(Math.atan2(currtVector.y, currtVector.x) - Math.atan2(startVector.y, startVector.x));
				//move canvasCenter to new center of touches
				var temp:Point = canvasCenter.clone();
				PointUtil.multiply(temp, s);
				PointUtil.rotate(temp, MathUtil.angleToRadian(r));
				var x:Number = center.x - temp.x;
				var y:Number = center.y - temp.y;
				canvas.x = x;
				canvas.y = y;
				canvas.scaleX = canvas.scaleY = s;
				canvas.rotation = r;
				//control.zoomRotateMoveTo(s, r, x, y, Linear.easeOut, .15);
			}
			else if (touchesCount > 2)
			{
				//swipe mode
				if(!swipePageStared)
				{
					setCanvasInteract(false);
					if(!startSwipe)
						startSwipe = center.clone();
					var swipe:Point = center.subtract(startSwipe);
					//trace("onTouchMove: swipe mode", swipe);
					if (swipe.x >= 5 || swipe.x <= -5)
					{
						enabled = false;
						if (swipe.x < 0) 
							page.next();
						else
							page.prev();
						startSwipe = null;
						swipePageStared = true;
					}
					else if (swipe.y >= 5 || swipe.y <= -5)
					{
						enabled = false;
						if (swipe.y < 0)
							page.next();
						else
							page.prev();
						startSwipe = null;
						swipePageStared = true;
					}
				}
			}
		}
		
		private function onTouchEnd(e:TouchEvent):void
		{
			//trace("onTouchEnd:", e.touchPointID, touchesCount - 1)
			//update touches
			if (touchesMap[e.touchPointID])
			{
				delete touchesMap[e.touchPointID];
				touchesCount--;
				updateCenter();
			}
			//trace("onTouchEnd: enabled", enabled)
			if(!enabled)
			{
				swipePageStared = false;
				return;
			}
			if (touchesCount > 2)
			{
				startSwipe = center.clone();
			}
			else if (touchesCount == 2)
			{
				//from swipe mode to scale rotate mode
				//trace("onTouchEnd: from swipe to scale rotate mode");
				recordStartCanvasLayout();
			}
			else if (touchesCount <= 1)
			{
				//use mouse interact
				
				if(!swipePageStared)
				{
					setCanvasInteract(true);
				}
				else
				{
					swipePageStared = false;
				}
			}
		}
		
		private function updateCenter():void
		{
			center.x = center.y = 0;
			for each (var touch:Touch in touchesMap)
			{
				center.x += touch.location.x;
				center.y += touch.location.y;
			}
			center.x /= touchesCount;
			center.y /= touchesCount;
		}
		
		/**
		 * 记录变换前的canvas起始相对于手势的中心位置。
		 */
		private function recordStartCanvasLayout():void
		{
			canvasCenter = LayoutUtil.stagePointToElementPoint(center.x, center.y, canvas);
			startScale = canvas.scaleX;
			startRotation = canvas.rotation;
			
			var touches:Vector.<Touch> = new Vector.<Touch>;
			for each(var touch:Touch in touchesMap)
				touches[touches.length] = touch;
			startVector = touches[1].location.subtract(touches[0].location);
		}
		
		private function setCanvasInteract(value:Boolean):void
		{
			//trace("setCanvasInteract:", value);
			canvasInterract = value;
			if (canvasInterract)
			{
				control.enableBGInteract();
				control.mainUI.curScreenState.enableCanvas();
			}
			else
			{
				control.disableBgInteract();
				control.mainUI.curScreenState.disableCanvas();
			}
		}
		private var canvasInterract:Boolean = true;
		
		public var enabled:Boolean = true;
		
		private var mainUI:MainUIBase;
		
		private var canvas:Canvas;
		
		private var mediator:IMainUIMediator;
		
		private var control:ZoomMoveControl;
		
		/**
		 * 当前手势的中心点
		 */
		private var center:Point = new Point;
		
		/**
		 * 上一次移动的手势中心点
		 */
		
		/**
		 * 开始scale,rotate时手势中心点对应的canvas画布上的点
		 */
		private var canvasCenter:Point;
		
		private var startScale:Number;
		
		private var startRotation:Number;
		
		private var startVector:Point;
		
		private var startSwipe:Point = new Point;
		
		private var swipePageStared:Boolean;
		
		/**
		 * 存储触控点的字典
		 */
		private var touchesMap:Object = {};
		
		/**
		 * 当前触摸点的数目
		 */
		private var touchesCount:uint = 0;
		
		private var page:PageManager;
	}
}
import flash.geom.Point;

class Touch
{
	public var id:uint;
	public var location:Point = new Point;
	public var prevLocation:Point = new Point;
}