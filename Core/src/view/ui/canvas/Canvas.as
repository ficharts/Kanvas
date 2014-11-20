package view.ui.canvas
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.RectangleUtil;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import util.LayoutUtil;
	
	import view.element.IElement;
	import view.ui.ICanvasLayout;
	import view.ui.MainUIBase;
	import view.ui.PageNum;
	
	/**
	 * 核心画布，
	 */	
	public class Canvas extends Sprite
	{
		public function Canvas($mainUI:MainUIBase)
		{
			super();
			
			mainUI = $mainUI;
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		private function init():void
		{
			renderState = new RenderState(this);
			drawState = new DrawState(this);
			curRenderState = renderState;
			
			addChild(interactorBG);
			
			stage.addEventListener(Event.RENDER, renderHandler);
			addEventListener(MouseEvent.CLICK, doubleClickRetriver);
		}
		
		/**
		 */		
		public function toRenderState():void
		{
			curRenderState.toRenderState();
			
			trace(rateSum / rate.length, "平均帧频");
		}
		
		/**
		 */		
		public function toDrawState():void
		{
			curRenderState.toDrawState();
			
			rateSum = 0;
			rate.length = 0;
		}
		
		/**
		 * 渲染模式，播放动画时，采用画布渲染模式，所有原件绘制到统一张画布上
		 */		
		internal var curRenderState:CanvasStateBase;
		internal var renderState:RenderState;
		internal var drawState:DrawState;
		
		/**
		 * 画布渲染
		 */		
		public function renderHandler(e:Event = null):void
		{
			var cur:Number = getTimer();
			//trace(1000 /(cur - prevT), cur - prevT);
			
			var i:Number = 1000 /(cur - prevT);
			rateSum += i;
			rate.push(i);
			
			prevT = cur;
			
			curRenderState.upate();
		}
		
		private var rate:Array = new Array;
		private var rateSum:Number = 0;;
		
		/**
		 */		
		private var prevT:Number = getTimer();
		
		/**
		 */		
		private function updateView():void
		{
			if (stage) stage.invalidate();
		}
		
		/**
		 * 检测远见是否在窗口可见范围内
		 */		
		public function checkVisible(element:ICanvasLayout):Boolean
		{
			var result:Boolean = false;
			
			
			
			//不在显示窗口里的原件和过小的原件均不显示, 不用绘制
			if (stage)
			{
				var rect:Rectangle = LayoutUtil.getItemRect(this, element);
				
				if (rect.width < 1 || rect.height < 1)
				{
					result = false;
				}
				else 
				{
					var boud:Rectangle = LayoutUtil.getStageRect(stage);
					result = RectangleUtil.rectOverlapping(rect, boud);
				}
			}
			
			return result;
		}
		
		/**
		 * 检测元件是否比显示区域大，如果超过显示区域则需要实体渲染
		 * 
		 * 应用了动画的元件永远都是实体显示
		 */		
		public function isLargeThanView(element:ICanvasLayout):Boolean
		{
			if (element.ifInViewRect)
			{
				//应用了动画效果的原件不显示
				if ((element as IElement).flashShape.alpha < 1)
					return true;
				
				var rect:Rectangle = LayoutUtil.getItemRect(this, element);
				
				if (rect.width > stage.stageWidth || rect.height > stage.stageHeight)
					return true;
			}
			
			return false;
		}
		
		/**
		 * 获取显示对象的位图数据，这里获取到的是放大原矢量图后得到的位图数据，
		 * 
		 * 每次原件渲染时获取到截图数据，用于缩放动画时
		 */		
		public function getElemetBmd(ele:DisplayObject):BitmapData
		{
			var s:Number;
			if (ele.width > ele.height)
				s = stage.stageWidth / ele.width;
			else
				s = stage.stageHeight / ele.height;
			
			PerformaceTest.start("draw");
			var textBMD:BitmapData = BitmapUtil.getBitmapData(ele, true, s);
			PerformaceTest.end("draw");
			
			return textBMD;
		}
		
		/**
		 * 获取原件的布局信息
		 * 
		 */		
		public function getElementLayout(element:Sprite):ElementLayoutModel
		{
			var layout:ElementLayoutModel = new ElementLayoutModel; 
			
			var prtScale :Number = this.scale, prtRadian:Number = MathUtil.angleToRadian(this.rotation);
			var prtCos:Number = Math.cos(prtRadian), prtSin:Number = Math.sin(prtRadian);
			
			//scale
			var tmpX:Number = element.x * prtScale;
			var tmpY:Number = element.y * prtScale;
			
			//rotate, move
			layout.rotation = this.rotation + element.rotation;
			layout.scaleX = prtScale * element.scaleX;
			layout.scaleY = prtScale * element.scaleY;
			layout.x = tmpX * prtCos - tmpY * prtSin + this.x;
			layout.y = tmpX * prtSin + tmpY * prtCos + this.y;
			
			return layout;
		}
		
		/**
		 * 页面编号刷新时
		 */		
		public function getPageNumBmd(index:uint):BitmapData
		{
			pageNumCreator.render(index);
			
			return BitmapUtil.getBitmapData(pageNumCreator);
		}
		
		/**
		 */		
		private var pageNumCreator:PageNum = new PageNum
		
			
		/**
		 *
		 * 把元素上的渲染点转换为全局绝对坐标的点
		 *  
		 * @param points
		 * 
		 */			
		public function transformRenderPoints(points:Vector.<Point>, layout:ElementLayoutModel):void
		{
			var p:Point;
			for each (p in points)
				getNewPos(p.x * layout.scaleX + layout.x, p.y * layout.scaleY + layout.y, layout.x, layout.y, layout.rotation, p);
		}
			
		/**
		 * 点(x, y)绕原点(ox, oy)转了角度r，求点(x, y)的新坐标 
		 */		
		public function getNewPos(x:Number, y:Number, ox:Number, oy:Number, r:Number, point:Point):void
		{
			var prtRadian:Number = MathUtil.angleToRadian(r);
			var prtCos:Number = Math.cos(prtRadian), prtSin:Number = Math.sin(prtRadian);
			
			point.x = (x-ox) * prtCos - (y-oy) * prtSin + ox;
			point.y = (y-oy) * prtCos + (x-ox) * prtSin + oy;
				
		}
		
		/**
		 */		
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
		
		/**
		 */		
		private var doubleClickActived:Boolean;
		
		/**
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.renderView();
				items[items.length] = item;
			}
			
			return child;
		}
		
		/**
		 * 
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.renderView();
				items[items.length] = item;
			}
			
			return child;
		}
		
		/**
		 */		
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
		
		/**
		 */		
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
		
		/**
		 */		
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
		 * 页面截图时调用
		 */		
		public function toShotcutState($x:Number, $y:Number, $scale:Number, $rotation:Number, page:Rectangle = null):void
		{
			if(!previewState)
			{
				previewState = true;
				previewX = x;
				previewY = y;
				previewScale = scale;
				previewRotation = rotation;
				
				__x = $x;
				__y = $y;
				__scale = $scale;
				__rotation = $rotation;
				
				var renderable:Boolean, vector:Vector.<ICanvasLayout>, rect:Rectangle, item:ICanvasLayout;
				
				for each (item in items)
				{
					renderable = false;
					if (page)
					{
						rect = LayoutUtil.getItemRect(this, item);
						if (rect.width > 1 && rect.height > 1)
							renderable = RectangleUtil.rectOverlapping(page, rect);
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
		 * 
		 * 页面截图完毕时调用
		 */		
		public function toPreviewState():void
		{
			if( previewState)
			{
				previewState = false;
				__x = previewX;
				__y = previewY;
				__scale = previewScale;
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
		
		/**
		 */		
		override public function get scaleX():Number
		{
			return __scale;
		}
		
		/**
		 */		
		override public function get scaleY():Number
		{
			return __scale;
		}
		
		/**
		 */		
		public function get scale():Number
		{
			return __scale;
		}
		
		public function set scale(value:Number):void
		{
			if (__scale!= value) 
				__scale = value;
			
			updateView();
		}
		
		private var __scale:Number = 1;
		
		override public function get rotation():Number
		{
			return __rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			if (__rotation!= value) 
				__rotation = value;
			
			updateView();
		}
		
		private var __rotation:Number = 0;
		
		override public function get x():Number
		{
			return __x;
		}
		
		override public function set x(value:Number):void
		{
			if (__x!= value) 
				__x = value;
			
			updateView();
		}
		
		private var __x:Number = 0;
		
		override public function get y():Number
		{
			return __y;
		}
		
		override public function set y(value:Number):void
		{
			if (__y!= value) 
				__y = value;
			
			updateView();
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
		internal var items:Vector.<ICanvasLayout> = new Vector.<ICanvasLayout>;;
		
	}
}