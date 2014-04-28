package util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.interact.CoreMediator;
	import view.interact.autoGroup.IAutoGroupElement;
	import view.interact.multiSelect.TemGroupElement;

	public final class CoreUtil
	{
		public static function drawRect(color:uint, rect:Rectangle):void
		{
			coreMdt.coreApp.autoAlignUI.graphics.lineStyle(1, color);
			coreMdt.coreApp.autoAlignUI.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		}

		public static function drawFrame(color:uint, points:Array):void
		{
			coreMdt.coreApp.autoAlignUI.graphics.lineStyle(1, color);
			coreMdt.coreApp.autoAlignUI.graphics.moveTo(points[0].x, points[0].y);
			for (var i:int = 1; i < points.length; i++)
			{
				coreMdt.coreApp.autoAlignUI.graphics.lineTo(points[i].x, points[i].y);
			}
			coreMdt.coreApp.autoAlignUI.graphics.lineTo(points[0].x, points[0].y);
		}
		
		public static function drawCircle(color:uint, point:Point, r:Number):void
		{
			coreMdt.coreApp.autoAlignUI.graphics.lineStyle(0, 0, 0);
			coreMdt.coreApp.autoAlignUI.graphics.beginFill(color);
			coreMdt.coreApp.autoAlignUI.graphics.drawCircle(point.x, point.y, r);
			coreMdt.coreApp.autoAlignUI.graphics.endFill();
		}
		
		public static function drawLine(color:uint, point1:Point, point2:Point):void
		{
			clear();
			
			coreMdt.coreApp.autoAlignUI.graphics.lineStyle(1, color);
			coreMdt.coreApp.autoAlignUI.graphics.moveTo(point1.x, point1.y);
			coreMdt.coreApp.autoAlignUI.graphics.lineTo(point2.x, point2.y);
			coreMdt.coreApp.autoAlignUI.graphics.endFill();
		}

		/**
		 */		
		public static function clear():void
		{
			coreMdt.coreApp.autoAlignUI.graphics.clear();
		}
		
		/**
		 * element 不在可交互范围内
		 * 有两种情况，一为element尺寸太大，超过了stage尺寸
		 */
		public static function elementOutOfInteract(element:ElementBase):Boolean
		{
			var bound:Rectangle = LayoutUtil.getItemRect (coreMdt.canvas, element);
			var stage:Rectangle = LayoutUtil.getStageRect(coreMdt.canvas.stage);
			return (bound.width  > stage.width  || 
					bound.height > stage.height ||
					bound.left   > stage.right  || 
					bound.right  < stage.left   || 
					bound.top    > stage.bottom || 
					bound.bottom < stage.top);
		}
		
		/**
		 * 检测element是否在自动群组内
		 * 检测element是否在current群组内
		 */
		public static function inGroup(current:ElementBase, element:ElementBase):Boolean
		{
			var result:Boolean;
			//检测element是否在current临时组合内
			if (current is TemGroupElement)
				result = (coreMdt.multiSelectControl.childElements.indexOf(element) != -1);
			//检测element是否在current群组
			else if (current is GroupElement)
				result = (GroupElement(current).childElements.indexOf(element) != -1);
			//检测element是否在智能组合内
			else if (element is IAutoGroupElement)
				result = coreMdt.autoGroupController.hasElement(element);
			else
			{
				
			}
			
			return result;
		}
		
		private static function get coreMdt():CoreMediator
		{
			return CoreFacade.coreMediator;
		}
	}
}