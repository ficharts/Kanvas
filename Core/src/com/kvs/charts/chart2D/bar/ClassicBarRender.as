package com.kvs.charts.chart2D.bar
{
	import com.kvs.charts.chart2D.column2D.Column2DUI;
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.kvs.charts.common.SeriesDataPoint;
	
	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public class ClassicBarRender implements ISeriesRenderPattern
	{
		/**
		 */		
		public function ClassicBarRender(series:BarSeries)
		{
			this.series = series;
		}
		
		/**
		 */		
		private var series:BarSeries;
		
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
						columnItemUI = new BarItemUI(itemDataVO);
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