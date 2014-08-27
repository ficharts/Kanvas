package com.kvs.charts.chart2D.core.axis
{
	import com.kvs.charts.chart2D.core.model.SeriesDataFeature;
	import com.kvs.utils.ArrayUtil;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;

	/**
	 * 
	 * 字符类型的坐标轴�数据节点均匀分部
	 * 
	 * @author wallen
	 * 
	 */	
	public class FieldAxis extends AxisBase
	{
		public function FieldAxis()
		{
			super();
			
			curPattern = new FieldAxis_Normal(this);
		}
		
		/**
		 */		
		override public function clone():AxisBase
		{
			var axis:AxisBase = new FieldAxis;
			initClone(axis);
			
			return axis;
		}
		
		
		/**
		 */		
		override public function getXLabel(value:Object):String
		{
			return dataFormatter.formatXString(value);
		}
		
		override public function getYLabel(value:Object):String
		{
			return dataFormatter.formatYString(value);
		}

		/**
		 */
		override public function valueToX(value:Object, index:int):Number
		{
			return valueToSize(value, index);
		}

		/**
		 */
		override public function valueToY(value:Object):Number
		{
			return - valueToSize(value, - 1);
		}
		
		/**
		 */		
		override internal function adjustHoriTicks():void
		{
			var start:Number = ticks[0];
			var end:Number = ticks[ticks.length - 1];
				
			if (ifTickCenter)
			{
				ticks.unshift(start);
//				/ticks.push(end);
			}
			else
			{
				if (this.inverse)
					ticks.forEach(shiftRight);
				else
					ticks.forEach(shiftLeft);
				
				//ticks.push(end);
			}
		}
		
		/**
		 */		
		internal function shiftLeft(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item - unitSize * .5;
		}
		
		/**
		 */		
		internal function shiftRight(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item + unitSize * .5;
		}
		
		/**
		 */		
		override protected function adjustVertiTicks():void
		{
			if (ifTickCenter)
			{
				ticks.unshift(0);
				//ticks.push(- size);
			}
			else
			{
				if (this.inverse)
					ticks.forEach(shiftUp);
				else
					ticks.forEach(shiftDown);
				
				//ticks.push(- size);
			}
		}
		
		/**
		 */		
		private function shiftDown(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item + unitSize * .5;
		}
		
		/**
		 */		
		private function shiftUp(item:Number, index:uint, array:Vector.<Number>):void
		{
			array[index] = item - unitSize * .5;
		}
		
		/**
		 * 标签是否与刻度线对齐，默认不对齐，标签位于两个刻度线的中间；
		 */		
		private var _ifTickCenter:Boolean = false;

		/**
		 */
		public function get ifTickCenter():Object
		{
			return _ifTickCenter;
		}	

		/**
		 * @private
		 */
		public function set ifTickCenter(value:Object):void
		{
			_ifTickCenter = XMLVOMapper.boolean(value);
		}
		
		/**
		 * 关闭后，边缘的单元宽度会少去一半
		 */		
		private var _ifEdgeSpace:Boolean = true;

		/**
		 */
		public function get ifEdgeSpace():Object
		{
			return _ifEdgeSpace;
		}

		/**
		 * @private
		 */
		public function set ifEdgeSpace(value:Object):void
		{
			_ifEdgeSpace = XMLVOMapper.boolean(value);;
		}

		/**
		 */		
		override public function getSeriesDataFeature(seriesData:Vector.<Object>):SeriesDataFeature
		{
			var seriesDataFeature:SeriesDataFeature = new SeriesDataFeature;
			
			// 单值的情况�
			if (seriesData.length == 1)
			{
				seriesDataFeature.maxValue = seriesDataFeature.minValue = seriesData.pop();
			}
			else // 多值的情况
			{
				seriesDataFeature.minValue = seriesData.shift();
				seriesDataFeature.maxValue = seriesData.pop();
			}
			
			return seriesDataFeature;
		}
		
		/**
		 */
		override public function pushValues(values:Vector.<Object>):void
		{
			var item:String, i:uint = sourceValues.length;
			for each (item in values)
			{
				sourceValues[i] = item;
				i ++;				
			}
		}
		
		/**
		 */		
		override public function dataUpdated():void
		{
			ArrayUtil.removeDubItem(this.sourceValues);
			super.dataUpdated();
		}
		
	}
}