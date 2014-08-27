package com.kvs.charts.chart2D.line
{
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	/**
	 */	
	public class SimpleLineRender implements ISeriesRenderPattern
	{
		public function SimpleLineRender(series:LineSeries)
		{
			this.series = series;
			
			series.stateControl = new StatesControl(series, series.states);
		}
		
		/**
		 */		
		private var series:LineSeries;
		
		/**
		 */		
		public function render():void
		{
			if (series.ifSizeChanged || series.ifDataChanged)
			{
				series.applyDataFeature();
				
				series.states.width = series.seriesWidth;
				series.states.height = series.seriesHeight;
				
				series.ifSizeChanged = series.ifDataChanged = false;
			}
			else
			{
				series.clearCanvas();
				
				StyleManager.setLineStyle(series.canvas.graphics, series.currState.getBorder, series.currState, series);
				
				series.renderSimleLine(series.canvas.graphics, 
					series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex);
				
				if (series.currState.cover && series.currState.cover.border)
				{
					StyleManager.setLineStyle(series.canvas.graphics, series.currState.cover.border, series.currState, series);
					series.renderSimleLine(series.canvas.graphics, 
					series.dataOffsetter.minIndex, series.dataOffsetter.maxIndex, series.currState.cover.offset);
				}
				
				StyleManager.setEffects(series.canvas, series.currState, series);
			}
		}
	}
}