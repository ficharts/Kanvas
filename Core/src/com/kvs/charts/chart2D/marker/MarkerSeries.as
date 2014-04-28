package com.kvs.charts.chart2D.marker
{
	import com.kvs.charts.chart2D.core.itemRender.PointRenderBace;
	import com.kvs.charts.chart2D.core.model.Chart2DModel;
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.kvs.charts.chart2D.encry.SB;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;

	/**
	 */	
	public class MarkerSeries extends SB
	{
		/**
		 * 散点图序�
		 */
		public function MarkerSeries()
		{
			super();
		}
		
		/**
		 */		
		override protected function getClassicPattern():ISeriesRenderPattern
		{
			return new ClassicMarkerRender(this);	
		}
		
		/**
		 */		
		override protected function getSimplePattern():ISeriesRenderPattern
		{
			return new SimpleMarkerRender(this);
		}
		
		
		
		//----------------------------------------------
		//
		//
		//
		// 三点类型计算
		//
		//
		//
		//------------------------------------------------
		
		
		private function getMarkerType():String
		{
			var len:uint = makerType.length;
				
			if (markerSeriesIndex < len)
			{
				return makerType[markerSeriesIndex];
			}
			else
			{
				return makerType[(markerSeriesIndex + 1) % len - 1]
			}
		}
		
		/**
		 * 全局控制散点序列排位, 每次序列重建时需刷新
		 */
		public static var markerSeriesIndex:uint = 0;
		
		/**
		 */		
		private static var makerType:Array = ['Diamond', 'Square', 'Circle', 'Triangle'];
		
		/**
		 */		
		override protected function get type():String
		{
			return "marker";
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			super.beforeUpdateProperties(xml);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.MARKER_SERIES, Model.SYSTEM), this);
			
			dataRender = new DataRender;
			XMLVOMapper.fuck(XMLVOLib.getXML(getMarkerType(), Model.DATA_RENDER), this.dataRender);
			markerSeriesIndex += 1;
		}
		/**
		 */		
		override public function created():void
		{
			chartColorManager = new ChartColors;
		}
		
		/**
		 */		
		override public function setPercent(value:Number):void
		{
			canvas.alpha = value;
		}
		
		/**
		 * Render PlotChart.
		 */
		override protected function draw():void
		{
			this.canvas.graphics.clear();	
			canvas.graphics.beginFill(0, 0);
			
			for each (var item:SeriesDataPoint in this.dataItemVOs)
				canvas.graphics.drawCircle(item.x, item.y, 10);// TODO
		}
		
		/**
		 * 更新数据节点的布局信息�
		 */		
		override public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{   
			var item:SeriesDataPoint;
			for (var i:uint = startIndex; i <= endIndex; i += step)
			{	
				item = dataItemVOs[i];
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xVerifyValue, i);
				item.dataItemY = (verticalAxis.valueToY(item.yVerifyValue));
				item.offset = this.baseLine;
				item.y = item.dataItemY - this.baseLine;
			}
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
			itemRender.valueLabel = valueLabel;
			this.updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			initTipString(item, itemRender.xTipLabel, 
				itemRender.yTipLabel,itemRender.zTipLabel,itemRender.isHorizontal);
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 * 构造节点渲染器
		 */		
		override protected function get itemRender():PointRenderBace
		{
			return new MarkerPointRender;
		}

	}
}