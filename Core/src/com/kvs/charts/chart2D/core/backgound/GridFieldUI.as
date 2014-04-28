package com.kvs.charts.chart2D.core.backgound
{
	import com.kvs.charts.chart2D.core.model.GridFieldStyle;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	/**
	 */
	public class GridFieldUI extends Sprite
	{
		public static const HORITICAL:String = 'horitical';
		public static const VERTICAL:String = 'vartical';
		public static const BOTH:String = 'both';

		/**
		 *  Construcator.
		 */
		public function GridFieldUI()
		{
			super();
			
			this.mouseChildren = this.mouseEnabled = false;
			
			vGrid.mask = hGridMask;
			hGrid.mask =  vGridMask
				
			addChild(vGrid);
			addChild(hGrid);
			addChild(vGridMask);
			addChild(hGridMask);
			addChild(border);
			
		}
		
		/**
		 *  Draw series BG.
		 */
		public function render(horiTicks:Vector.<Number>, vertiTicks:Vector.<Number>, 
							   style:GridFieldStyle):void
		{
			
			if (style.enable)
			{
				drawVGidLine(vertiTicks, style);
				drawHGidLine(horiTicks, style);
				
				graphics.clear();
				StyleManager.setFillStyle(graphics, style);
				graphics.drawRoundRect(0, 0, style.width, style.height, style.radius, style.radius);
				
				border.graphics.clear();
				StyleManager.setLineStyle(border.graphics, style.getBorder);
				border.graphics.drawRoundRect(0, 0, style.width, style.height, style.radius, style.radius);
				
				var borderThikness:Number = 0;
				
				if (style.vGrid.border)
					borderThikness = Number(style.vGrid.getBorder.thikness);
				else
					borderThikness = 0;
				
				vGridMask.graphics.clear();
				vGridMask.graphics.beginFill(0, 0);
				vGridMask.graphics.drawRoundRect( - borderThikness, 0, 
					style.width + borderThikness * 2, style.height, style.radius, style.radius);
				
				if (style.hGrid.border)
					borderThikness = Number(style.hGrid.getBorder.thikness);
				else
					borderThikness = 0;
				
				hGridMask.graphics.clear();
				hGridMask.graphics.beginFill(0,0);
				hGridMask.graphics.drawRoundRect(0, - borderThikness, 
					style.width, style.height + borderThikness * 2, style.radius, style.radius);
			}
			
		}

		/**
		 * 绘制横向分隔条
		 */
		public function drawVGidLine(ticks:Vector.<Number>, style:GridFieldStyle):void
		{
			var i:uint;
			var departs:int = ticks.length - 1;
			var lineY:Number;
			var partHeight:Number = style.height / departs;
			
			vGrid.graphics.clear();
			
			// 绘制填充
			for (i = 0; i <= departs; i++)
			{
				lineY = style.height + ticks[i];
				
				if (i % 2 != 0 && i <= departs)
				{
					vGrid.graphics.lineStyle(0, 0, 0);
					
					style.hGrid.width = style.width;
					style.hGrid.height = partHeight;
					StyleManager.setFillStyle(vGrid.graphics, style.hGrid);
					vGrid.graphics.drawRect(0, lineY, style.width, partHeight);
					vGrid.graphics.endFill();
				}
			}
			
			// 绘制网格
			StyleManager.setLineStyle(vGrid.graphics, style.hGrid.getBorder);
			for (i = 0; i <= departs; i++)
			{
				lineY = style.height + ticks[i];
				
				vGrid.graphics.moveTo(0, lineY);
				vGrid.graphics.lineTo(style.width, lineY);
			}
			
			StyleManager.setEffects(vGrid, style.hGrid);
		}

		/**
		 * 绘制纵向分隔条
		 */
		public function drawHGidLine(ticks:Vector.<Number>, style:GridFieldStyle):void
		{
			var i:uint;
			var departs:int = ticks.length - 1;
			var partLength:Number = style.width / departs;
			var lineX:Number;
			
			hGrid.graphics.clear();
			
			if (style.vGrid && style.vGrid.fill)
			{
				for (i = 0; i <= departs; i++)
				{
					lineX = ticks[i];
					
					if (i % 2 != 0 && i <= departs)
					{
						hGrid.graphics.lineStyle(0, 0, 0);
						
						style.vGrid.width = partLength;
						style.vGrid.height = style.height;
						StyleManager.setFillStyle(hGrid.graphics, style.vGrid);
						hGrid.graphics.drawRect(lineX, 0, partLength, style.height);
						hGrid.graphics.endFill();
					}
				}
			}
			
			StyleManager.setLineStyle(hGrid.graphics, style.vGrid.getBorder);
			
			var cmds:Vector.<int> = new Vector.<int>;
			var data:Vector.<Number> = new Vector.<Number>;
			for (i = 0; i <= departs; i++)
			{
				lineX = ticks[i];
				cmds.push(1, 2);
				data.push(lineX, 0, lineX, style.height);
			}
			
			hGrid.graphics.drawPath(cmds, data);
			StyleManager.setEffects(hGrid, style.vGrid);
		}
		
		/**
		 */		
		private var vGrid:Shape = new Shape();
		private var hGrid:Shape = new Shape();
		private var vGridMask:Shape = new Shape;
		private var hGridMask:Shape = new Shape;
		private var border:Shape = new Shape;
		
	}
}