package com.kvs.charts.chart2D.core.model
{
	import com.kvs.charts.chart2D.bar.stack.StackedBarSeries;
	import com.kvs.charts.chart2D.column2D.ColumnSeries2D;
	import com.kvs.charts.chart2D.column2D.stack.StackedColumnSeries;
	import com.kvs.charts.chart2D.encry.SB;
	import com.kvs.charts.chart2D.marker.MarkerSeries;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.IEditableObject;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;

	/**
	 */	
	public class Series implements IEditableObject
	{
		/**
		 */		
		public static const CHART2D_SERIES_CREATED:String = 'chart2dSeriesCreated';
		
		/**
		 */		
		public function Series()
		{
		}
		
		/**
		 */
		public function get line():SB
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set line(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get area():SB
		{
			return null;
		}

		public function set area(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get bar():SB
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set bar(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get stackedBar():SB
		{
			return null;
		}

		public function set stackedBar(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get stackedPercentBar():SB
		{
			return null;
		}

		public function set stackedPercentBar(value:SB):void
		{
			_items.push(value);
		}

		/**
		 */		
		public function get column():SB
		{
			return null;
		}
		
		/**
		 */		
		public function set column(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */		
		public function get stackedColumn():SB
		{
			return null;
		}

		public function set stackedColumn(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */		
		public function get stackedPercentColumn():SB
		{
			return null;
		}

		public function set stackedPercentColumn(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 * 
		 */
		public function get bubble():SB
		{
			return null;
		}

		/**
		 * @private
		 */
		public function set bubble(value:SB):void
		{
			_items.push(value);
		}
		
		/**
		 */
		public function get marker():SB
		{
			return null;
		}

		public function set marker(value:SB):void
		{
			_items.push(value);
		}

		/**
		 */		
		private var _items:Vector.<SB>;

		/**
		 */
		public function get items():Vector.<SB>
		{
			return _items;
		}
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			_items = new Vector.<SB>;
			
			MarkerSeries.markerSeriesIndex = 0;
		}
		
		/**
		 * 在数据映射结束之后调用， 此时可以通知外部此对象已被创建；
		 */		
		public function propertiesUpdated(xml:* = null):void
		{
			
		}
		
		/**
		 * 对象已经被创建并且成为了父层的一个子对象 
		 */		
		public function created():void
		{
			var length:uint = _items.length;
			var index:uint = 0;
			var columnSereisIndex:uint = 0;
			var columnSeriesAmount:uint = 0;
			var seriesIndex:uint = 1;
			
			var seriesItem:SB;
			colorMananger = new ChartColors();
			for (var i:int = 0; i < length; i ++)
			{
				seriesItem = items[i];
				seriesItem.seriesIndex = index;
				seriesItem.seriesCount = length;
				
				// 设置序列的默认序列名称
				seriesIndex = seriesItem.initSeriesName(seriesIndex);
				
				// 按照序列的顺序指定序列颜色
				seriesItem.setColor(colorMananger);
				
				if (seriesItem is ColumnSeries2D)
					columnSeriesAmount += 1;
				
				index ++;
			}
			
			for each (var series:SB in _items)
			{
				if (series is ColumnSeries2D)
				{
					(series as ColumnSeries2D).columnSeriesAmount = columnSeriesAmount;
					(series as ColumnSeries2D).columnSeriesIndex = columnSereisIndex;
					
					columnSereisIndex ++;
				}
			}
			
			changed = true;
			XMLVOLib.dispatchCreation(Series.CHART2D_SERIES_CREATED, items);
		}
		
		/**
		 * 图表的颜色生成管理， 按顺序生成不同的颜色；
		 */		
		public var colorMananger:ChartColors;
		
		/**
		 */		
		public var changed:Boolean = false;
		
		/**
		 * 序列总数
		 */		
		public function get length():uint
		{
			return items.length;
		}
	}
}