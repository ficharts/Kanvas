package landray.kp.components
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.elements.Element;
	import landray.kp.view.Viewer;
	
	import util.LayoutUtil;
	
	import view.ui.Canvas;
	
	/**
	 * 选择框
	 */
	public final class Selector extends Sprite
	{
		public function Selector()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			config = KPConfig.instance;
			visible = false;
		}
		
		public function render($element:Element = null):void
		{
			if ($element)
			{
				element = $element;
				visible = true;
			}
			if (visible)
			{
				var rect:Rectangle = LayoutUtil.getItemRect(canvas, element, true, true, false);
				var point:Point = LayoutUtil.elementPointToStagePoint(element.x, element.y, canvas);
				rect.width  *= canvas.scaleX;
				rect.height *= canvas.scaleX;
				x = point.x;
				y = point.y;
				rect.x = -.5 * rect.width;
				rect.y = -.5 * rect.height;
				
				drawRect(rect, 5);
				
				rotation = element.rotation + canvas.rotation;
			}
		}
		
		/**
		 * @private
		 */
		private function drawRect(rect:Rectangle, padding:Number):void
		{
			var x:Number = rect.x - padding;
			var y:Number = rect.y - padding;
			var w:Number = rect.width  + padding * 2;
			var h:Number = rect.height + padding * 2;
			
			graphics.clear();
			graphics.lineStyle(3, 0x00AFFF);
			graphics.drawRect(x, y, w, h);
			graphics.lineStyle(1, 0xEEEEEE);
			graphics.drawRect(x, y, w, h);
		}
		
		private function get canvas():Canvas
		{
			return config.kp_internal::viewer.canvas;
		}
		
		/**
		 * @private
		 */
		private var element:Element;
		
		/**
		 * @private
		 */
		private var padding:Number = 5;
		
		private var config:KPConfig;
	}
}