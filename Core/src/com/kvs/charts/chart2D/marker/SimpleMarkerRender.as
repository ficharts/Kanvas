package com.kvs.charts.chart2D.marker
{
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	/**
	 */	
	public class SimpleMarkerRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function SimpleMarkerRender(marker:MarkerSeries)
		{
			this.marker = marker;
			marker.stateControl = new StatesControl(marker, marker.states);
		}
		
		/**
		 */		
		private var marker:MarkerSeries;
		
		/**
		 */		
		public function render():void
		{
			if (marker.ifSizeChanged || marker.ifDataChanged)
			{
				marker.applyDataFeature();
				marker.ifSizeChanged = marker.ifDataChanged = false;
			}
			else
			{
				marker.clearCanvas();
				
				for (var i:uint = marker.dataOffsetter.minIndex; i < marker.dataOffsetter.maxIndex; i ++)
				{
					//marker.dataRender.render(marker.canvas, marker.dataItemVOs[i]);
				}
				
			}
		}
	}
}