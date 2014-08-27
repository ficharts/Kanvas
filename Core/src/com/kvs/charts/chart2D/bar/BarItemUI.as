package com.kvs.charts.chart2D.bar
{
	import com.kvs.charts.chart2D.column2D.Column2DUI;
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
	import com.kvs.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class BarItemUI extends Column2DUI
	{
		public function BarItemUI(dataItem:SeriesDataPoint)
		{
			super(dataItem);
		}
		
		/**
		 */		
		override public function render():void
		{
			this.graphics.clear();
			
			currState.ty = 0;
			currState.height = this.columnHeight;
			
			currState.tx = 0;
			currState.width = this.columnWidth;
			
			StyleManager.drawRect(this, currState, mdata);
		}
		
	}
}