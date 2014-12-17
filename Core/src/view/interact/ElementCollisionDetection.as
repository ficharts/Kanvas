package view.interact
{
	//import com.kvs.utils.HitTest;
	
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.PageElement;
	import view.element.shapes.LineElement;
	import view.element.text.TextEditField;
	import view.interact.autoGroup.AutoGroupController;
	import view.interact.autoGroup.IAutoGroupElement;
	import view.ui.IMainUIMediator;
	
	/**
	 * 碰撞检测，辅助智能组合，画布缩放过程中的的图形交互失效，隐藏等
	 */	
	public class ElementCollisionDetection
	{
		/**
		 * 控制智能群组的移动，缩放和大图形是否可以被点击
		 */		
		public function ElementCollisionDetection(mdt:IMainUIMediator, elements:Vector.<ElementBase>, hitObject:DisplayObject)
		{
			this.coreMdt = mdt;
			this.elements = elements;
			this.hitObject = hitObject;
		}
		
		/**
		 */		
		private var coreMdt:IMainUIMediator;
		
		/**
		 */		
		private var hitObject:DisplayObject;
		
		/**
		 * 检测智能组合；
		 * 
		 * ifAll 是否包含非智能组合元素，多选时用到
		 */		
		public function checkAutoGroup(current:ElementBase, autoGroupControl:AutoGroupController, ifAll:Boolean = false):void
		{
			if (autoGroupControl.enabled == false) return;
			
			//当前选择是文本的话不进行智能组合
			if (current is IAutoGroupElement && !(current is TextEditField))
			{
				for each (var element:ElementBase in elements)
				{
					//确保元素非组合内容，被碰撞，并且是可以智能组合的元素
					if (element.canAutoGrouped && (element is IAutoGroupElement || ifAll) && element != current)
					{
						//要确保被检测元件的中心点与参考元件实际性碰撞，而非仅与其轮廓矩形相碰撞
						var ele:ElementBase = ifElementIn(element, current);
						
						//碰撞
						if (ele)
							autoGroupControl.pushElement(ele as IAutoGroupElement);
					}
				}
			}
		}
		
		/**
		 * 如果小的元素在大的元素内，则返回小的元素
		 */		
		public function ifElementIn(small:ElementBase, large:ElementBase):ElementBase
		{
			var ifHit:Boolean = (large is PageElement)
				? RectangleUtil.rectWithin(
					LayoutUtil.getItemRect(coreMdt.canvas, small, false, false, false), 
					LayoutUtil.getItemRect(coreMdt.canvas, large, false, false, false))
				: ifHitElement(small, large.graphicShape);
			
			if (ifHit)
			{
				if (small is LineElement)
				{
					if (small.scaledWidth / 2 < large.scaledWidth && small.scaledHeight < large.scaledHeight)
						return small;
				}
				else if (small.scaledWidth < large.scaledWidth && small.scaledHeight < large.scaledHeight)
				{
					return small;
				}
			}
			
			return null;
		}
		
		/**
		 * 是否图形与元件碰撞，这里的碰撞是指元件的中心与图形碰撞
		 */		
		public function ifHitElement(element:ElementBase, hitElement:DisplayObject):Boolean
		{
			var point:Point = LayoutUtil.elementPointToStagePoint(element.vo.x, element.vo.y, coreMdt.canvas);
			return hitElement.hitTestPoint(point.x, point.y, true);
		}
		
		/**
		 *
		 * 判断某个原件是否在可视范围内
		 */		
		public function ifElementInView(element:ElementBase):Boolean
		{
			var point:Point = LayoutUtil.elementPointToStagePoint(element.vo.x, element.vo.y, coreMdt.canvas);
			
			return coreMdt.mainUI.autofitRect.containsPoint(point);
		}
		
		/**
		 * 
		 * 显示区域内的元件，尺寸超出区域大小时会被禁止交互;
		 * 
		 * 显示区域 内的元件，尺寸过小时也会被禁止交互, 并且隐藏
		 */		
		public function checkElementEnable():void
		{
			var stage:Rectangle = coreMdt.mainUI.autofitRect, w:Number = stage.width, h:Number = stage.height;
			//minLineInteractSizeSquare, maxLineInteractSizeSquare
			var minLineSquare:Number = minInteractSize * minInteractSize * .25, maxLineSquare:Number = w * w;
			
			var element:ElementBase, bound:Rectangle, size:Number;
			for each (element in elements)
			{
				if (element.visible)
				{
					bound = getItemRect(coreMdt.canvas, element);
					if (element is LineElement)
					{
						size = (bound.width * bound.width + bound.height * bound.height) >> 1;
						if (size > maxLineSquare || size < minLineSquare)
							element.disable();//过小禁止交互
						else
							element.enable();
					}
					else if (element is TextEditField)
					{
						if (bound.width > w || bound.height > h || bound.width < 15 || bound.height < 5)
							element.disable();
						else
							element.enable();
					}
					else if (element.enableChangable && (bound.width >= w || bound.width < minInteractSize || bound.height >= h || bound.height < minInteractSize))
					{
						element.disable();
					}
					else
					{
						element.enable();
					}
				}
			}
			
		}
		
		/**
		 */		
		private var minInteractSize:uint = 5;
		
		/**
		 */		
		private var minVisibleSize:uint = 1;
		
		/**
		 */		
		public var elements:Vector.<ElementBase>;
		
		/**
		 */		
		private static var getItemRect:Function = LayoutUtil.getItemRect;
	}
}