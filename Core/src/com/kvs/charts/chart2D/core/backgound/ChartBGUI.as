package com.kvs.charts.chart2D.core.backgound
{
	import com.kvs.charts.chart2D.core.model.ChartBGStyle;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Sprite;
	
	public class ChartBGUI extends Sprite
	{
		public function ChartBGUI()
		{
			super();
		}
		
		/**
		 *  Draw chart background.
		 */		
		public function render(style:ChartBGStyle) : void
		{
			graphics.clear();
			
			if (style.enable)
			{
				var thikness:Number = style.border.thikness;
				//StyleManager.setShapeStyle(style, this.graphics);
				
				this.graphics.beginFill(0, 0);
				graphics.drawRoundRect(thikness / 2, thikness / 2, style.width - thikness, 
					style.height - thikness, style.radius, style.radius);
				graphics.endFill();
				
				//StyleManager.setEffects(this, style);
			}
			
		}
		
	}
}