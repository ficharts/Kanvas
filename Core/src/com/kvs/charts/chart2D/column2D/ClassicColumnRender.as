package com.kvs.charts.chart2D.column2D
{
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.kvs.charts.common.SeriesDataPoint;
	
	/**
	 * 经典柱状图渲染
	 */	
	public class ClassicColumnRender implements ISeriesRenderPattern
	{
		public function ClassicColumnRender(series:ColumnSeries2D)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:ColumnSeries2D;
		
		/**
		 */		
		public function render():void
		{
			if (series.ifDataChanged || series.ifSizeChanged)
			{
				series.applyDataFeature();
				
				//创建新数据点
				if (series.ifDataChanged)
				{
					series.initData();
					series.createItemRenders();
					series.clearCanvas();
					
					var columnItemUI:Column2DUI;
					series.columnUIs = new Vector.<Column2DUI>;
					for each (var itemDataVO:SeriesDataPoint in series.dataItemVOs)
					{
						//draw column or bar
						columnItemUI = new Column2DUI(itemDataVO);
						columnItemUI.states = series.states;
						columnItemUI.mdata = itemDataVO.metaData;
						series.canvas.addChild(columnItemUI);
						series.columnUIs.push(columnItemUI);
					}
				}
				
				//更新尺寸信息
				series.layoutDataItems(0, series.maxDataItemIndex);
				
				// 渲染
				series.layoutAndRenderUIs();
				series.ifSizeChanged = series.ifDataChanged = false;
			}
		}
	}
}