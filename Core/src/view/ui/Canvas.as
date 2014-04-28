package view.ui
{
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
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
				items.push(item);
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
				items.push(item);
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
			for (var i:int = beginIndex; i < endIndex; i++)
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
				
				page 
				
				for each (var item:ICanvasLayout in items)
				{
					var renderable:Boolean = false;
					if (page)
					{
						var rect:Rectangle = LayoutUtil.getItemRect(this, item);
						if (rect.width > 1 && rect.height > 1)
							renderable = RectangleUtil.rectOverlapping(page, rect);
					}
					else
					{
						renderable = true;
					}
					var vector:Vector.<ICanvasLayout> = (renderable) ? previewItems : visibleItems;
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
				
				for each (var item:ICanvasLayout in previewItems)
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
		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			if (__scaleX!= value) 
			{
				__scaleX = value;
				for each (var item:ICanvasLayout in items)
					item.updateView();
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
				for each (var item:ICanvasLayout in items)
					item.updateView();
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
				for each (var item:ICanvasLayout in items)
					item.updateView();
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
				for each (var item:ICanvasLayout in items)
					item.updateView();
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
				for each (var item:ICanvasLayout in items)
					item.updateView();
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
				for each (var item:ICanvasLayout in items)
					item.updateView();
			}
		}
		
		private var __y:Number = 0;
		
		/**
		 */		
		public function get elements():Vector.<ICanvasLayout>
		{
			return  items.concat();
		}
		
		/**
		 */		
		public var interactorBG:Sprite = new Sprite;
		
		/**
		 */		
		private var items:Vector.<ICanvasLayout>;
	}
}