package com.kvs.charts.chart2D.column2D.stack
{
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	
	public class SimpleStackedColumnRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function SimpleStackedColumnRender(series:StackedColumnSeries)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:StackedColumnSeries;
		
		/**
		 */		
		public function render():void
		{
		}
	}
}