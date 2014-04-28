package com.kvs.charts.chart2D.bubble
{
	import com.kvs.charts.common.SeriesDataPoint;
	
	public class BubbleDataPoint extends SeriesDataPoint
	{
		public function BubbleDataPoint()
		{
			super();
		}
		
		private var _percent:Number;

		/**
		 */
		public function get percent():Number
		{
			return _percent;
		}

		/**
		 * @private
		 */
		public function set percent(value:Number):void
		{
			_percent = value;
		}

	}
}