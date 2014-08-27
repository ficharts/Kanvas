package com.kvs.charts.chart2D.column2D
{
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
	import com.kvs.charts.chart2D.core.series.SeriesItemUIBase;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	/**
	 * @author wallen
	 */	
	public class Column2DUI extends SeriesItemUIBase 
	{
		public function Column2DUI(dataItem:SeriesDataPoint)
		{
			super(dataItem);
		}
		
		/**
		 */		
		public function resize():void
		{
			this.width = columnWidth;
			this.height = Math.abs(columnHeight);
		}
		
		/**
		 */		
		override public function render():void
		{
			this.graphics.clear();
			
			currState.tx = 0;
			currState.width = this.columnWidth;
			
			currState.ty = columnHeight;
			currState.height = - columnHeight;
				
			StyleManager.drawRect(this, currState, mdata);
		}
		
		/**
		 */		
		private var _columnWidth:int;

		/**
		 */
		public function get columnWidth():int
		{
			return _columnWidth;
		}

		/**
		 * @private
		 */
		public function set columnWidth(value:int):void
		{
			_columnWidth = value;
		}
		
		private var _columnHeight:int;

		/**
		 */
		public function get columnHeight():int
		{
			return _columnHeight;
		}

		/**
		 * @private
		 */
		public function set columnHeight(value:int):void
		{
			_columnHeight = value;
		}

	}
}