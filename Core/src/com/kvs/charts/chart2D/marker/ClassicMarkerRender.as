package com.kvs.charts.chart2D.marker
{
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;

	public class ClassicMarkerRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function ClassicMarkerRender(marker:MarkerSeries)
		{
			this.marker = marker;
		}
		
		/**
		 */		
		private var marker:MarkerSeries;
		
		/**
		 */		
		public function render():void
		{
			if (marker.ifDataChanged || marker.ifSizeChanged)
			{
				marker.applyDataFeature();
				
				//创建新数据点
				if (marker.ifDataChanged)
				{
					marker.initData();
					marker.createItemRenders();
					marker.clearCanvas();
				}
				
				//更新尺寸信息
				marker.layoutDataItems(0, marker.maxDataItemIndex);
				marker.ifSizeChanged = marker.ifDataChanged = false;
			}
		}
	}
}