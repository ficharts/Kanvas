package com.kvs.charts.chart2D.core.axis
{
	import flash.text.TextField;
	
	/**
	 * 字符坐标轴正常模式
	 */	
	public class FieldAxis_Normal implements IAxisPattern
	{
		public function FieldAxis_Normal(axis:FieldAxis)
		{
			this.axis = axis;
		}
		
		/**
		 */		
		public function hideDataRender():void
		{
			
		}
		
		/**
		 */		
		public function updateTipsData():void
		{
			
		}
		
		/**
		 */		
		public function udpateIndexOfCurSourceData(step:uint):void
		{
			
		}
		
		/**
		 */		
		public function dataUpdated():void
		{
			
		}
		
		/**
		 */		
		private var axis:FieldAxis;
		
		/**
		 */		
		public function valueToSize(value:Object, index:int):Number
		{
			// 有些节点为空，不能仅根据index信息计算
			//if (index == - 1)
				index = axis.sourceValues.indexOf(value.toString())
					
			var result:Number;
			
			if (axis.ifEdgeSpace)
				result = axis.unitSize * .5 + index * axis.unitSize;
			else
				result = axis.unitSize * index;
			
			if (axis.inverse)
				return axis.size - result;
			
			return result;
		}
		
		/**
		 */		
		public function beforeRender():void
		{
			var labelData:AxisLabelData;
			axis.labelVOes.length = axis.labelUIs.length = 0;
			
			for each (var value:String in axis.sourceValues)
			{
				labelData = new AxisLabelData();
				labelData.value = value;
				axis.labelVOes.push(labelData);
			}
			
			if (axis.ifEdgeSpace)
				axis.unitSize = axis.size / axis.sourceValues.length;
			else
				axis.unitSize = axis.size / (axis.sourceValues.length - 1);
		}
		
		/**
		 */		
		public function scrollingByChartCanvas(offset:Number):void
		{
		}
		
		public function dataScrolled(dataRange:DataRange):void
		{
		}
		
		public function get currentScrollPos():Number
		{
			return 0;
		}
		
		public function dataResized(dataRange:DataRange):void
		{
		}
		
		public function renderSeries(startPerc:Number, endPerc:Number):void
		{
		}
		
		public function getPercentByData(data:Object):Number
		{
			return 0;
		}
		
		public function getPercentBySourceData(data:Object):Number
		{
			return 0;
		}
		
		public function percentToPos(perc:Number):Number
		{
			return 0;
		}
		
		public function posToPercent(pos:Number):Number
		{
			return 0;
		}
		
		/**
		 */		
		public function renderHorLabelUIs():void
		{
			axis.clearLabels();
			var length:int = axis.labelVOes.length;
			
			if (axis.ifHideEdgeLabel)
				axis.renderHoriLabelUIs(1, length - 2, length - 2);
			else
				axis.renderHoriLabelUIs(0, length - 1, length);
		}
		
		
	}
}