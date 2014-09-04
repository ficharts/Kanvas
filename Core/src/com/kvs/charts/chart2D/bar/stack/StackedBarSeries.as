package com.kvs.charts.chart2D.bar.stack
{
	import com.kvs.charts.chart2D.bar.BarItemUI;
	import com.kvs.charts.chart2D.column2D.Column2DUI;
	import com.kvs.charts.chart2D.column2D.stack.StackedColumnSeries;
	import com.kvs.charts.chart2D.column2D.stack.StackedSeries;
	import com.kvs.charts.chart2D.column2D.stack.StackedSeriesDataPoint;
	import com.kvs.charts.chart2D.core.axis.AxisBase;
	import com.kvs.charts.chart2D.core.axis.LinearAxis;
	import com.kvs.charts.chart2D.core.itemRender.PointRenderBace;
	import com.kvs.charts.chart2D.core.model.Chart2DModel;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import view.editor.chart.SeriesProxy;
	import view.editor.chart.StackedBarProxy;
	
	/**
	 */	
	public class StackedBarSeries extends StackedColumnSeries
	{
		public function StackedBarSeries()
		{
			super();
			
			this.value = 'xValue';
		}
		
		/**
		 */		
		override public function get proxy():SeriesProxy
		{
			var proxy:SeriesProxy = new StackedBarProxy;
			proxy.type = this.type;
			
			return proxy;
		}
		
		/**
		 */		
		override public function resetAxisFormat():void
		{
			// 这里目前仅仅定义了数值方向上的格式
			if (RexUtil.ifHasText(yAxis))
				horizontalAxis.dataFormatter.xPrefix = valuePrefix;
			
			if (RexUtil.ifHasText(valueSuffix))
				horizontalAxis.dataFormatter.xSuffix = valueSuffix;
		}
		
		/**
		 */		
		override public function get labels():Vector.<String>
		{
			var labels:Vector.<String> = new Vector.<String>
			var dataItemVOs:Vector.<SeriesDataPoint> = stacks[0].dataItemVOs;
			
			for each (var data:SeriesDataPoint in dataItemVOs)
				labels.push(data.yLabel);
			
			return labels.reverse();
		}
		
		/**
		 */		
		override public function exportValues(split:String):String
		{
			var s:String = "";
			
			var labels:Vector.<String>;
			var dataItemVOs:Vector.<SeriesDataPoint>;
			for each (var stack:StackedSeries in stacks)
			{
				labels = new Vector.<String>;
				dataItemVOs = stack.dataItemVOs;
				
				for each (var data:SeriesDataPoint in dataItemVOs)
					labels.push(data.xLabel);
					
				s += stack.seriesName + ":\n" + labels.reverse().join(split);
				s += '\n\n';
			}
			
			return s;
		}
		
		/**
		 */		
		override protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			if (ifNullData(item))
				return;
			
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.xLabel;
			itemRender.value = value;
			
			// 整体数值样式与独立数值样式有分别
			if (itemRender is StackedBarCombilePointRender)
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
			
			initTipString(item, itemRender.xTipLabel, 
				itemRender.yTipLabel,itemRender.zTipLabel,itemRender.isHorizontal);
			
			itemRenders.push(itemRender);
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.STACKED_BAR_SERIES, Model.SYSTEM), this);
			
			this.stacks = new Vector.<StackedSeries>;
		}
		
		/**
		 */		
		override public function get type():String
		{
			return "stackedBar";
		}
		
		/**
		 */		
		override public function set percent(value:Number):void
		{
			canvas.scaleX = value;
		}
		
		/**
		 */		
		override public function get percent():Number
		{
			return canvas.scaleX;
		}
		
		/**
		 */		
		override public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			adjustColumnWidth();
			
			var item:SeriesDataPoint;
			for each (item in dataItemVOs)
			{
				item.x = this.horizontalAxis.valueToX((item as StackedSeriesDataPoint).startValue, NaN) - baseLine;
				item.dataItemX = horizontalAxis.valueToX((item as StackedSeriesDataPoint).endValue, NaN);
				
				// 数据节点的坐标系与渲染节点不同， 两者相�值为 baseLine
				item.y = verticalAxis.valueToY(item.yValue) - columnGoupWidth / 2 +
					this.columnSeriesIndex * (partColumnWidth + columnGroupInnerSpaceUint) //;
					
				item.dataItemY = item.y + partColumnWidth / 2;
				item.offset = baseLine;
			}
			
		}
		
		/**
		 */		
		override public function layoutAndRenderUIs():void
		{
			for each (var columnUI:Column2DUI in this.columnUIs)
			{
				columnUI.x = horizontalAxis.valueToX((columnUI.dataItem as StackedSeriesDataPoint).startValue, NaN) - baseLine;
				columnUI.y = columnUI.dataItem.y; //+ partColumnWidth / 2;
				
				(columnUI.dataItem as StackedSeriesDataPoint).width = 
				columnUI.columnWidth = horizontalAxis.valueToX((columnUI.dataItem as StackedSeriesDataPoint).endValue, NaN) -
					horizontalAxis.valueToX((columnUI.dataItem as StackedSeriesDataPoint).startValue, NaN);
				
				columnUI.columnHeight = partColumnWidth;
				columnUI.render();
			}
		}
		
		/**
		 */		
		override protected function getSeriesItemUI(dataItem:SeriesDataPoint):Column2DUI
		{
			return new BarItemUI(dataItem);
		}
		
		/**
		 */		
		override protected function get itemRender():PointRenderBace
		{
			return new StackedBarPointRender(false);
		}
		
		/**
		 */		
		override protected function preInitData():void
		{
			this.dataProvider.reverse();
			
			var xValue:Number, yValue:Object, positiveValue:Number, negativeValue:Number;
			var length:uint = dataProvider.length;
			var stack:StackedSeries;
			var stackedSeriesDataItem:StackedSeriesDataPoint;
			
			dataItemVOs.length = 0;
			horizontalValues.length = 0;
			verticalValues.length = 0;
			
			// 将子序列的数据节点合并到一起；
			for each (stack in stacks)
			{
				stack.value = "xValue"
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
					
					xValue = Number(stack.dataItemVOs[i].xVerifyValue);
					yValue = stack.dataItemVOs[i].yVerifyValue;
					stackedSeriesDataItem = (stack.dataItemVOs[i] as StackedSeriesDataPoint);
					
					if (xValue >= 0)
					{
						stackedSeriesDataItem.startValue = Number(positiveValue);
						positiveValue += xValue;
						stackedSeriesDataItem.endValue = Number(positiveValue);
					}
					else 
					{
						stackedSeriesDataItem.startValue = Number(negativeValue);
						negativeValue += xValue;
						stackedSeriesDataItem.endValue = Number(negativeValue);
					}
					
					XMLVOMapper.pushAttributesToObject(stackedSeriesDataItem, stackedSeriesDataItem.metaData, 
						['startValue', 'endValue']);
				}
				
				verticalValues.push(yValue);
				horizontalValues.push(positiveValue);
				horizontalValues.push(negativeValue);
			}
		}
		
		/**
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
		
		
		//---------------------------------------------
		//
		// 数值分布特�
		//
		//---------------------------------------------
		
		override public function applyDataFeature():void
		{
			this.directionControl.dataFeature = this.horizontalAxis.getSeriesDataFeature(
				this.horizontalValues.concat());
			
			directionControl.checkDirection(this);
			
			this.canvas.x = baseLine;
		}
		
		/**
		 */		
		override public function upBaseLine():void
		{
			if ((horizontalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = horizontalAxis.valueToX(0, NaN);
			else
				directionControl.baseLine = horizontalAxis.valueToX(directionControl.dataFeature.minValue, NaN);
		}
		
		/**
		 */		
		override public function centerBaseLine():void
		{
			directionControl.baseLine = horizontalAxis.valueToX(0, NaN);
		}
		
		/**
		 */		
		override public function downBaseLine():void
		{
			if ((horizontalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = horizontalAxis.valueToX(0, NaN);
			else
				directionControl.baseLine = horizontalAxis.valueToX(directionControl.dataFeature.maxValue, NaN);
		}
		
		/**
		 */		
		override public function get controlAxis():AxisBase
		{
			return this.horizontalAxis;
		}
		
		
		
		//-------------------------------------------------------
		//
		// 尺寸调整
		//
		//-------------------------------------------------------
		
		/**
		 * 根据最大允许的单个柱体宽度调整柱体群宽度和单个柱体实际宽度�
		 */		
		override protected function adjustColumnWidth():void
		{
			var temColumnGroupWidth:Number = verticalAxis.unitSize - columnGroupOuterSpaceUint * 2;
			var temColumnWidth:Number = (temColumnGroupWidth - columnGroupInnerSpace) / columnSeriesAmount;
			
			if (temColumnWidth <= maxItemSize)
			{
				_partColumnWidth = temColumnWidth;
				_columnGoupWidth = temColumnGroupWidth;
			}
			else
			{
				_partColumnWidth = maxItemSize;
				_columnGoupWidth = _partColumnWidth * columnSeriesAmount + columnGroupInnerSpace;
			}
		}
		
		/**
		 * 柱体群内部的单元间隙，个数为群柱体个�- 1�
		 */		
		override protected function get columnGroupInnerSpaceUint():Number
		{
			return  verticalAxis.unitSize * .05;
		}
		
		/**
		 * 柱体群外单元空隙，每个柱体群有两个此间隙�
		 */
		override public function get columnGroupOuterSpaceUint():Number
		{
			return verticalAxis.unitSize * .1;
		}
	}
}