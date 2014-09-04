package com.kvs.charts.chart2D.column2D.stack
{
	import com.kvs.charts.chart2D.column2D.Column2DUI;
	import com.kvs.charts.chart2D.column2D.ColumnSeries2D;
	import com.kvs.charts.chart2D.core.axis.LinearAxis;
	import com.kvs.charts.chart2D.core.itemRender.PointRenderBace;
	import com.kvs.charts.chart2D.core.model.Chart2DModel;
	import com.kvs.charts.chart2D.encry.SB;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.charts.legend.model.LegendVO;
	import com.kvs.charts.legend.view.LegendEvent;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	
	import view.editor.chart.SeriesProxy;
	import view.editor.chart.StackedColumnProxy;
	
	/**
	 * 堆积序列群组类；
	 * 
	 * 堆积序列的子序列是个仅拥有数据的空壳，样式定义，样式渲染全部�code>StackedColumnSeries</code>中进行， 
	 * 
	 */	
	public class StackedColumnSeries extends ColumnSeries2D
	{
		public function StackedColumnSeries()
		{
			super();
			
			curRenderPattern = new ClassicStackedColumnRender(this);
		}
		
		/**
		 */		
		override public function get proxy():SeriesProxy
		{
			var proxy:SeriesProxy = new StackedColumnProxy;
			proxy.type = this.type;
			
			return proxy;
		}
		
		/**
		 */		
		override public function get labels():Vector.<String>
		{
			var labels:Vector.<String> = new Vector.<String>
			var dataItemVOs:Vector.<SeriesDataPoint> = stacks[0].dataItemVOs;
			
			for each (var data:SeriesDataPoint in dataItemVOs)
				labels.push(data.xLabel);
			
			return labels;
		}
		
		/**
		 */		
		override public function exportValues(split:String):String
		{
			var s:String = "";
			
			for each (var stack:StackedSeries in stacks)
			{
				s += stack.exportValues(split);
				s += '\n\n';
			}
			
			return s;
		}
		
		
		/**
		 */		
		override public function get type():String
		{
			return "stackedColumn";
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
		override protected function draw():void
		{
			
		}
		
		/**
		 */		
		override public function setColor(colorMng:ChartColors):void
		{
		}
		
		/**
		 */		
		override public function layoutAndRenderUIs():void
		{
			var index:uint;
			for each (var columnUI:Column2DUI in this.columnUIs)
			{
				columnUI.x = columnUI.dataItem.x - partColumnWidth / 2;
				columnUI.y = columnUI.dataItem.y//verticalAxis.valueToY((columnUI.dataItem as StackedSeriesDataItem).startValue) - baseLine;
				setColumnUISize(columnUI);
				columnUI.render();
			}
		}
		
		/**
		 */		
		override protected function setColumnUISize(columnUI:Column2DUI):void
		{
			(columnUI.dataItem as StackedSeriesDataPoint).width = columnUI.columnWidth = partColumnWidth;
			(columnUI.dataItem as StackedSeriesDataPoint).height = columnUI.columnHeight = 
			
				verticalAxis.valueToY((columnUI.dataItem as StackedSeriesDataPoint).endValue) -
				verticalAxis.valueToY((columnUI.dataItem as StackedSeriesDataPoint).startValue);
		}
		
		/**
		 */		
		override protected function getSeriesItemUI(dataItem:SeriesDataPoint):Column2DUI
		{
			return new StackedColumnUI(dataItem);
		}
		
		/**
		 */		
		override public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			adjustColumnWidth();
			
			var item:SeriesDataPoint;
			var i:int;
			var len:uint = dataItemVOs.length;
			
			for (i = 0; i < len; i += step)
			{
				item = dataItemVOs[i];
				
				item.x = horizontalAxis.valueToX(item.xVerifyValue, - 1) - columnGoupWidth / 2 +
					this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint) + partColumnWidth / 2;
				item.dataItemX = item.x;
				
				// 数据节点的坐标系与渲染节点不同， 两者相�值为 baseLine
				item.y = verticalAxis.valueToY((item as StackedSeriesDataPoint).startValue) - baseLine;
				item.dataItemY = verticalAxis.valueToY((item as StackedSeriesDataPoint).endValue);
				item.offset = baseLine;
			}
		}
		
		/**
		 * 创建汇总数据节点的渲染器， 这里创建的渲染器只是用于汇总数据的显示�
		 */		
		override public function createItemRenders():void
		{
			super.createItemRenders();
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			if (ifNullData(item))
				return;
			
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
			// 整体数值样式与独立数值样式有分别
			if (itemRender is StackedColumnCombiePointRender)
			{
				itemRender.valueLabel = this.valueLabel;
				this.updateLabelDisplay(itemRender);
			}
			else
			{
				itemRender.valueLabel = this.innerValueLabel;
				this.updateLabelDisplay(itemRender);
			}
			
			itemRender.dataRender = this.dataRender;
			
			itemRenders.push(itemRender);
		}
		
		/**
		 * 序列数据�坐标轴数据的创建
		 * 
		 * 这里把原始的数据节点与计算得出的汇总数据节点分离；
		 */		
		override protected function preInitData():void
		{
			if (this.curRenderPattern is SimpleStackedColumnRender) return;
				
			var xVerifyValue:Object, yVerifyValue:Number, xValue:Object, yValue:Object, positiveValue:Number, negativeValue:Number;
			var length:uint = dataProvider.length;
			var stack:StackedSeries;
			var stackedSeriesDataItem:StackedSeriesDataPoint;
			
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
			
			if (dataItemVOs.length == 0) return;
			
			// 将子序列的数值叠加， 因坐标轴的数值显示的是总量�
			for (var i:uint = 0; i < length; i++)
			{
				positiveValue = negativeValue = 0;
				for each (stack in stacks)
				{
					if (stack.dataItemVOs.length <= i)
						continue;
						
					stackedSeriesDataItem = (stack.dataItemVOs[i] as StackedSeriesDataPoint);
					stackedSeriesDataItem.index = i;
					
					xVerifyValue = stackedSeriesDataItem.xVerifyValue;
					yVerifyValue = Number(stackedSeriesDataItem.yVerifyValue);
					
					if (yVerifyValue >= 0)
					{
						stackedSeriesDataItem.startValue = Number(positiveValue);
						positiveValue += yVerifyValue;
						stackedSeriesDataItem.endValue = Number(positiveValue);
					}
					else
					{
						stackedSeriesDataItem.startValue = Number(negativeValue);
						negativeValue += yVerifyValue;
						stackedSeriesDataItem.endValue = Number(negativeValue);
					}
					
					XMLVOMapper.pushAttributesToObject(stackedSeriesDataItem, stackedSeriesDataItem.metaData, 
						['startValue', 'endValue']);
				}
				
				horizontalValues.push(xVerifyValue);
				verticalValues.push(positiveValue);
				verticalValues.push(negativeValue);
			}
			
			dataOffsetter.maxIndex = maxDataItemIndex = length - 1;
		}
		
		/**
		 */		
		override public function get legendData():Vector.<LegendVO>
		{
			var legendVOes:Vector.<LegendVO> = new Vector.<LegendVO>;
			var legendVO:LegendVO;
			
			for each(var item:StackedSeries in stacks)
			{
				legendVO = new LegendVO();
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, item.seriesLegendOverHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, item.seriesLegendOutHandler, false, 0, true);
				
				legendVO.addEventListener(LegendEvent.HIDE_LEGEND, item.seriesHideLegendHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.SHOW_LEGEND, item.seriesShowLegendHandler, false, 0, true);
				
				legendVO.metaData = item;
				legendVOes.push(legendVO);
			}
				
			return legendVOes;
		}
		
		/**
		 */		
		override public function initSeriesName(index:uint):uint
		{
			var seriesIndex:uint = index;
			
			for each(var item:SB in stacks)
				seriesIndex = item.initSeriesName(seriesIndex)
				
			return seriesIndex;
		}
		
		/**
		 * 
		 */
		public function get stack():StackedSeries
		{
			return null;
		}

		public function set stack(value:StackedSeries):void
		{
			stacks.push(value);
		}

		/**
		 * 堆积序列的创建与配置
		 */		
		override public function configed(colorMananger:ChartColors):void
		{
			for each (var series:StackedSeries in this.stacks)
			{
				if (!series.color)// 如果未指�序列颜色则采用自动分配颜�
					series.color = colorMananger.chartColor.toString(16);
				
				series.horizontalAxis = this.horizontalAxis;
				series.verticalAxis = this.verticalAxis;
			}
			
		}
		
		/**
		 */		
		override protected function get itemRender():PointRenderBace
		{
			return new StackedColumnPointRender(false);
		}
		
		/**
		 */		
		public var stacks:Vector.<StackedSeries>; 
		
	}
}