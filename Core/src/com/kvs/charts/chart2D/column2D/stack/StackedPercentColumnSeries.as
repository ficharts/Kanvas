package com.kvs.charts.chart2D.column2D.stack
{
	import com.kvs.charts.chart2D.core.axis.LinearAxis;
	import com.kvs.charts.chart2D.core.itemRender.PointRenderBace;
	import com.kvs.charts.chart2D.core.model.Chart2DModel;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;

	/**
	 */	
	public class StackedPercentColumnSeries extends StackedColumnSeries
	{
		public function StackedPercentColumnSeries()
		{
			super();
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.STACKED_COLUMN_SERIES, Model.SYSTEM), this);
			
			this.stacks = new Vector.<StackedSeries>;
		}
		
		/**
		 */		
		override public function configed(colorMananger:ChartColors):void
		{
			super.configed(colorMananger);
			
			(this.verticalAxis as LinearAxis).ifExpend = false;
			(this.verticalAxis as LinearAxis).maximum = 100;
			
			//设置Y轴和数值标签的单位设置
			verticalAxis.dataFormatter.ySuffix = '%';
			verticalAxis.dataFormatter.zSuffix = '%';
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.zLabel;
			itemRender.value = value;
			
			itemRender.valueLabel = this.innerValueLabel;
			this.updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			itemRender.tooltip = this.tooltip;
			
			itemRender.initToolTips();
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		override protected function get itemRender():PointRenderBace
		{
			return new StackedPercentColumnPointRender(false);
		}
		
		/**
		 */			
		override protected function preInitData():void
		{
			var xValue:Object, yValue:Number, positiveValue:Number, fullValue:Number, percent:Number;
			var length:uint = dataProvider.length;
			var stack:StackedSeries;
			var seriesDataItem:StackedSeriesDataPoint;
			
			dataItemVOs.length = 0;
			horizontalValues.length = 0;
			verticalValues.length = 0;
			
			// 将子序列的数据节点合并到一起；
			for each (stack in stacks)
			{
				stack.dataProvider = this.dataProvider;
				stack.initData();
				dataItemVOs = dataItemVOs.concat(stack.dataItemVOs);
			}
			
			// 将子序列的数值叠加， 因坐标轴的数值显示的是总量�
			for (var i:uint = 0; i < length; i++)
			{
				fullValue = 0;
				for each (stack in stacks) // 求和
				{
					seriesDataItem = stack.dataItemVOs[i] as StackedSeriesDataPoint;
					seriesDataItem.index = i;
					xValue = seriesDataItem.xVerifyValue;
					yValue = Number(seriesDataItem.yVerifyValue);
					fullValue += yValue;
				}
				
				positiveValue = percent = 0;
				for each (stack in stacks)
				{
					seriesDataItem = stack.dataItemVOs[i] as StackedSeriesDataPoint;
					
					yValue = Number(seriesDataItem.yValue);
					seriesDataItem.startValue = positiveValue / fullValue * 100;
					positiveValue += yValue;
					seriesDataItem.endValue = positiveValue / fullValue * 100;
					percent = seriesDataItem.endValue - seriesDataItem.startValue;
					
					seriesDataItem.zValue = percent;
					seriesDataItem.zLabel = this.verticalAxis.getZLabel(percent);
					seriesDataItem.zDisplayName = this.zDisplayName;
					
					XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
						['zValue', 'zLabel', 'zDisplayName']);
				}
				
				horizontalValues.push(xValue);
				verticalValues.push(positiveValue / fullValue * 100);
			}
			
			dataOffsetter.maxIndex = maxDataItemIndex = length - 1;
		}
		
		/**
		 */		
		private var _percentLabel:String

		/**
		 * 百分比数值之前的标签; � toolTip 中会用到;
		 */
		public function get zDisplayName():String
		{
			return _percentLabel;
		}

		/**
		 * @private
		 */
		public function set zDisplayName(value:String):void
		{
			_percentLabel = value;
		}

	}
}