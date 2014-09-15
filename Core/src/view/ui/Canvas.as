package view.ui
{
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import util.LayoutUtil;
	
	/**
	 * 核心画布，
	 */	
	public class Canvas extends Sprite
	{
		public function Canvas($mainUI:MainUIBase)
		{
			super();
			
			mainUI = $mainUI;
			
			items  = new Vector.<ICanvasLayout>;
			
			addChild(interactorBG);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			addEventListener(MouseEvent.CLICK, doubleClickRetriver);
		}
		
		private function doubleClickRetriver(e:MouseEvent):void
		{
			if (doubleClickActived)
			{
				doubleClickActived = false;
				dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
			}
			else
			{
				doubleClickActived = true;
				var timer:Timer = new Timer(300, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void{
					doubleClickActived = false;
					timer = null;
				}, false, 0, true);
				timer.start();
			}
		}
		private var doubleClickActived:Boolean;
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RENDER, renderHandler);
		}
		
		private function renderHandler(e:Event):void
		{
			if (renderable)
			{
				renderable = false;
				var item:ICanvasLayout;
				for each (item in items)
					item.updateView();
			}
		}
		
		/**
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.updateView();
				items[items.length] = item;
			}
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.updateView();
				items[items.length] = item;
			}
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				var index:int = items.indexOf(item);
				if (index > -1) items.splice(index, 1);
			}
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				var index:int = items.indexOf(item);
				if (index > -1) items.splice(index, 1);
			}
			return child;
		}
		
		override public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			endIndex = Math.min(numChildren, endIndex);
			for (var i:int = endIndex - 1; i >= beginIndex ; i--)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is ICanvasLayout)
				{
					var item:ICanvasLayout = ICanvasLayout(child);
					var index:int = items.indexOf(item);
					if (index > -1) items.splice(index, 1);
				}
			}
			super.removeChildren(beginIndex, endIndex);
		}
		
		/**
		 */		
		public function toShotcutState($x:Number, $y:Number, $scale:Number, $rotation:Number, page:Rectangle = null):void
		{
			if(!previewState)
			{
				previewState = true;
				previewX = x;
				previewY = y;
				previewScale = scaleX;
				previewRotation = rotation;
				
				__x = $x;
				__y = $y;
				__scaleX = __scaleY = $scale;
				__rotation = $rotation;
				
				var renderable:Boolean, vector:Vector.<ICanvasLayout>, rect:Rectangle, item:ICanvasLayout;
				
				for each (item in items)
				{
					renderable = false;
					if (page)
					{
						rect = getItemRect(this, item);
						if (rect.width > 1 && rect.height > 1)
							renderable = rectOverlapping(page, rect);
					}
					else
					{
						renderable = true;
					}
					vector = (renderable) ? previewItems : visibleItems;
					vector.push(item);
					item.toShotcut(renderable);
				}
			}
		}
		
		/**
		 */		
		public function toPreviewState():void
		{
			if( previewState)
			{
				previewState = false;
				__x = previewX;
				__y = previewY;
				__scaleX = __scaleY = previewScale;
				__rotation = previewRotation;
				
				var item:ICanvasLayout;
				for each (item in previewItems)
					item.toPreview(true);
				for each (item in visibleItems)
					item.toPreview(false);
					
				previewItems.length = 0;
				visibleItems.length = 0;
			}
		}
		
		/**
		 */		
		private var previewState:Boolean;
		private var previewX:Number;
		private var previewY:Number;
		private var previewScale:Number;
		private var previewRotation:Number;
		private var previewItems:Vector.<ICanvasLayout> = new Vector.<ICanvasLayout>;
		private var visibleItems:Vector.<ICanvasLayout> = new Vector.<ICanvasLayout>;
		
		/**
		 */		
		private var mainUI:MainUIBase;
		
		/**
		 * 是否含有元件
		 */		
		public function get ifHasElements():Boolean
		{
			return (numChildren > 1);
		}
		
		/**
		 */		
		public function drawBG(rect:Rectangle):void
		{
			interactorBG.graphics.clear();
			interactorBG.graphics.beginFill(0x666666, 0);
			interactorBG.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			interactorBG.graphics.endFill();
		}
		
		private function updateView():void
		{
			renderable = true;
			if (stage) stage.invalidate();
		}
		
		private var renderable:Boolean = false;
		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			if (__scaleX!= value) 
			{
				__scaleX = value;
				updateView();
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
				updateView();
			}
		}
		
		private var __scaleY:Number = 1;
		
		public function get scale():Number
		{
			return __scale;
		}
		
		public function set scale(value:Number):void
		{
			if (__scale!= value) 
			{
				__scale = value;
				updateView();
			}
		}
		
		private var __scale:Number = 1;
		
		override public function get rotation():Number
		{
			return __rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			if (__rotation!= value) 
			{
				__rotation = value;
				updateView();
			}
		}
		
		private var __rotation:Number = 0;
		
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
		
		/**
		 */		
		public function get elements():Vector.<ICanvasLayout>
		{
			return items.concat();
		}
		
		/**
		 */		
		public var interactorBG:Sprite = new Sprite;
		
		/**
		 */		
		private var items:Vector.<ICanvasLayout>;
		
		private static var getItemRect:Function = LayoutUtil.getItemRect;
		
		private static var rectOverlapping:Function = RectangleUtil.rectOverlapping;
	}
}