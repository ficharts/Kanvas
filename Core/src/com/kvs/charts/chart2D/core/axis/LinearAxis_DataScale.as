package com.kvs.charts.chart2D.core.axis
{
	import com.kvs.charts.chart2D.core.events.DataResizeEvent;
	import com.kvs.charts.chart2D.core.model.Zoom;
	import com.kvs.charts.chart2D.core.series.DataIndexOffseter;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PerformaceTest;

	/**
	 */	
	public class LinearAxis_DataScale implements IAxisPattern
	{
		/**
		 */		
		public function LinearAxis_DataScale(axis:AxisBase)
		{
			this._axis = axis;
		}
		
		
		/**
		 */		
		public function hideDataRender():void
		{
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.HIDE_DATA_RENDER));
		}
		
		/**
		 * 先缩小数值范围，然后寻求最近点来锁定tooltips
		 */		
		public function updateTipsData():void
		{
			var data:Number = getDataByPerc(posToPercent(axis.mouseX));
			
			var evt:DataResizeEvent = new DataResizeEvent(DataResizeEvent.UPDATE_TIPS_BY_DATA);
			evt.start = data - axis.interval;
			evt.end = data + axis.interval;
			evt.data = data;
			
			axis.dispatchEvent(evt);
		}
		
		/**
		 */		
		public function dataResized(dataRange:DataRange):void
		{
			ifScrolling = false;
			
			hideDataRender();
			
			//筛分数据节点
			dataScaleProxy.updateCurDataItems(dataRange.min, dataRange.max, axis, this);
			
			getCurrentDataRange(dataRange.min, dataRange.max);
		
			createLabelsData();// 数据缩放时才重新创建label数据, 数据范围决定label数据
			
			dataScaleProxy.setFullSizeAndOffsize(axis);
			
			axis.renderHoriticalAxis();
			
			renderYAxisAndSeries(dataScaleProxy.currentDataRange.min, dataScaleProxy.currentDataRange.max);
			
			updateTipsData();
			
			axis.updateScrollBarSize(dataRange.min, dataRange.max);
			
			ifLabelOddPattern = MathUtil.ifOddNumber(dataIndexActor.minIndex)
		}
		
		
		/**
		 *  为了让数据滚动更加平滑，被渲染label的位置序号奇偶不同会出现
		 * 
		 *  跳跃现象， 滚动过程中的奇偶特性要与缩放后相同；
		 */		
		private var ifLabelOddPattern:Boolean = false;
		
		/**
		 */		
		protected function getCurrentDataRange(start:Number, end:Number):void
		{
			//要根据    internal 重新构建 labels, 调整最值
			var min:Number, max:Number;
			min = start * axis.sourceValueDis + axis.sourceMin;
			max = end * axis.sourceValueDis + axis.sourceMin;
			
			axis.preMaxMin(max, min);
			axis.confirmMaxMin(axis.size);
			
			dataScaleProxy.currentDataRange.min = dataScaleProxy.sourceDataRange.min + 
				dataScaleProxy.confirmedSrcValueDis * start;
			
			dataScaleProxy.currentDataRange.max = dataScaleProxy.sourceDataRange.min + 
				dataScaleProxy.confirmedSrcValueDis * end;
		}
		
		
		/**
		 */		
		public function scrollByDataBar(sourceOff:Number):void
		{
			
		}
		
		/**
		 */		
		public function scrollingByChartCanvas(offset:Number):void
		{
			ifScrolling = true;
			
			if (axis.direction == AxisBase.HORIZONTAL_AXIS)
				dataScaleProxy.scrollData(offset);
			
			this.scrollingLabelsAndTicks();
			
			renderYAxisAndSeries(this.scrollMinData, this.scrollMaxData);
			
			axis.updateScrollBarPos(dataScaleProxy.getPercentByData(scrollMinData));
		}
		
		/**
		 * 根据当前数值范围，划定序列节点范围，y轴数据范围，然后渲染Y轴和序列 
		 */		
		protected function renderYAxisAndSeries(minData:Number, maxData:Number):void
		{
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.GET_SERIES_DATA_INDEX_RANGE_BY_DATA, minData, maxData));
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.UPDATE_Y_AXIS_DATA_RANGE));
			axis.dispatchEvent(new DataResizeEvent(DataResizeEvent.RENDER_DATA_RESIZED_SERIES));
			//trace("----------------------------------------------------------------------")
		}
		
		/**
		 */		
		public function dataScrolled(dataRange:DataRange):void
		{
			var offPerc:Number = dataScaleProxy.currentScrollPos / dataScaleProxy.fullSize;
			var min:Number = dataScaleProxy.currentDataRange.min - offPerc * dataScaleProxy.confirmedSrcValueDis;
			var max:Number = dataScaleProxy.currentDataRange.max - offPerc * dataScaleProxy.confirmedSrcValueDis;
			
			dataRange.min = getPercentByData(min);
			dataRange.max = getPercentByData(max);
		}
		
		/**
		 */		
		public function udpateIndexOfCurSourceData(step:uint):void
		{
			dataScaleProxy.maxIndex = Math.ceil(dataScaleProxy.sourceDataLen / step);
		}
		
		/**
		 */		
		public function adjustZoomFactor(model:Zoom):void
		{
			dataScaleProxy.adjustZoomFactor(model, axis.size);
		}
		
		/**
		 */		
		protected var dataScaleProxy:DataScaleProxy = new DataScaleProxy;
		
		/**
		 */		
		protected var _axis:AxisBase;
		
		/**
		 */		
		protected function get axis():LinearAxis
		{
			return _axis as LinearAxis;
		}
		
		/**
		 */		
		public function toNormalPattern():void
		{
			if (axis.normalPattern)
				axis.curPattern = axis.normalPattern;
			else
				axis.curPattern = axis.getNormalPatter();
		}
		
		/**
		 */		
		public function toZoomPattern():void
		{
		}
		
		/**
		 */		
		public function beforeRender():void
		{
			axis.preMaxMin(axis.sourceMax, axis.sourceMin);
			axis.confirmMaxMin(axis.size);
			
			if(axis.ifCeilEdgeValue)
			{
				dataScaleProxy.currentDataRange.min = dataScaleProxy.sourceDataRange.min = axis.minimum;
				dataScaleProxy.currentDataRange.max = dataScaleProxy.sourceDataRange.max = axis.maximum;
			}
			else
			{
				dataScaleProxy.currentDataRange.min = dataScaleProxy.sourceDataRange.min = axis.sourceMin;
				dataScaleProxy.currentDataRange.max = dataScaleProxy.sourceDataRange.max = axis.sourceMax;
			}
			
			//获得最值差，供后继频繁计算用
			dataScaleProxy.confirmedSrcValueDis = dataScaleProxy.sourceDataRange.max - dataScaleProxy.sourceDataRange.min;
			
			dataScaleProxy.updateCurDataItems(0, 1, axis, this);
			this.createLabelsData();
			dataScaleProxy.setFullSizeAndOffsize(axis);
		}
		
		/**
		 */		
		public function dataUpdated():void
		{
			dataScaleProxy.setSourceData(axis.sourceValues);
		}
		
		
		
		
		
		//--------------------------------------------------------------
		//
		//
		// 显示区域刻度绘制
		//
		//
		//---------------------------------------------------------------
		
		/**
		 * 数据滚动时， 刷新当前显示区域内的label
		 */		
		protected function scrollingLabelsAndTicks():void
		{
			this.renderHorLabelUIs();
			if (axis.enable && axis.tickMark.enable)
				axis.drawHoriTicks();
		}
		
		/**
		 */		
		private var ifScrolling:Boolean = false;
		
		/**
		 * 根据当前数据范围确定label范围，渲染这些label；
		 * 
		 * 已经被渲染的label不用重复渲染，之渲染需要渲染的；
		 * 
		 * 同时更新ticks信息，供背景网格实时绘制
		 */		
		public function renderHorLabelUIs():void
		{
			axis.clearLabels();
			getLabelIndexRangeForRender();
			
			var min:uint, max:uint, len:uint;
			if (ifScrolling)
			{
				if (MathUtil.ifOddNumber(dataIndexActor.minIndex) != this.ifLabelOddPattern)
				{
					min = dataIndexActor.minIndex - 1;
					max = dataIndexActor.maxIndex + 1;
					len = dataIndexActor.length + 2;
				}
				else
				{
					min = dataIndexActor.minIndex;
					max = dataIndexActor.maxIndex;
					len = dataIndexActor.length;
				}
			}
			else
			{
				min = dataIndexActor.minIndex;
				max = dataIndexActor.maxIndex;
				len = dataIndexActor.length;
			}
			
			axis.renderHoriLabelUIs(min, max, len);
		}
		
		/**
		 * 获取当前坐标轴显示区域label的数据位置范围
		 */		
		protected function getLabelIndexRangeForRender():void
		{
			scrollMinData = getDataByPerc(posToPercent(0));
			scrollMaxData = getDataByPerc(posToPercent(axis.size))
			
			dataIndexActor.minIndex = 0;
			var maxIndex:uint = dataIndexActor.maxIndex = axis.labelVOes.length - 1;
			
			dataIndexActor.getDataIndexRange(scrollMinData, scrollMaxData, axis.labelValues);
			
			if (axis.ifHideEdgeLabel)
				dataIndexActor.offSet(1, maxIndex - 1);
			else
				dataIndexActor.offSet(0, maxIndex);// 多取两个数据位，丰满一些
		}
		
		/**
		 */		
		protected var scrollMinData:Number = 0;
		protected var scrollMaxData:Number = 0;
		
		/**
		 */		
		protected function createLabelsData():void
		{
			axis.createLabelsData(dataScaleProxy.sourceDataRange.max, dataScaleProxy.sourceDataRange.min);
		}
		
		/**
		 * 辅助Y轴数据刷新和X轴的刻度渲染划定index范围
		 */		
		protected var dataIndexActor:DataIndexOffseter = new DataIndexOffseter;
		
		/**
		 * 根据百分比位置，得出数据值
		 */		
		protected function getDataByPerc(perc:Number):Number
		{
			return perc * dataScaleProxy.confirmedSrcValueDis + dataScaleProxy.sourceDataRange.min;
		}
		
		/**
		 */		
		public function getPercentBySourceData(value:Object):Number
		{
			return getPercentByData(value);
		}
		
		/**
		 */		
		public function getPercentByData(data:Object):Number
		{
			return dataScaleProxy.getPercentByData(Number(data));
		}
		
		/**
		 */		
		public function valueToSize(value:Object, index:int):Number
		{
			return percentToPos(getPercentByData(value));
		}
		
		/**
		 */		
		public function percentToPos(perc:Number):Number
		{
			return dataScaleProxy.percentToPos(perc, axis);
		}
		
		/**
		 */		
		public function posToPercent(pos:Number):Number
		{
			return dataScaleProxy.posToPercent(pos, axis);
		}
		
	}
}