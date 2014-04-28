package view.elementSelector.lineControl
{
	import fl.controls.SelectableList;
	
	import flash.geom.Point;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 */	
	public class StartPointControl extends StartEndControlBase
	{
		public function StartPointControl(selector:ElementSelector, ui:ControlPointBase)
		{
			super(selector, ui);
		}
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			startX += xOff;
			startY += yOff;
			//CoreUtil.drawCircle(0xFF0000, new Point(startX, startY), 2);
			
			super.moveOff(xOff, yOff);
			
			
			return;
			var rotation:Number = selector.coreMdt.autoAlignController.checkRotation(selector.element, selector.element.rotation);
			if (! isNaN(rotation))
			{
				vo.rotation = rotation;
				var rad:Number = vo.rotation / 180 * Math.PI;
				var r:Number = vo.width / 2 * vo.scale;
				
				var point:Point = LayoutUtil.stagePointToElementPoint(endX, endY, selector.coreMdt.canvas);
				vo.x = point.x - r * Math.cos(rad);
				vo.y = point.y - r * Math.sin(rad);
				
				selector.element.render();
				selector.update();
			}
		
		}
	}
	
}