package com.kvs.charts.chart2D.core.events
{
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.charts.legend.model.LegendVO;
	
	import flash.events.Event;
	
	/**
	 * @author wallen
	 */	
	public class FiChartsEvent extends Event
	{
		
		/**
		 * 图例数据改变事件
		 */		
		public static const LEGEND_DATA_CHANGED:String="legendDataChanged";
		
		/**
		 * 图表创建完成事件
		 */		
		public static const CHART_READY:String = "chartReady";
		
		/**
		 * 配置文件发生改变时触发 
		 */		
		public static const CONFIG_CHANGED:String = 'configChanged';
		
		/**
		 * 图表节点被点击后触发； 
		 */		
		public static const ITEM_CLICKED:String = 'itemClicked';
		
		/**
		 */		
		public static const ITEM_OVER:String = "itemOver";
		
		/**
		 */		
		public static const ITEM_OUT:String = "itemOut";
		
		/**
		 * 图表渲染完成
		 */		
		public static const RENDERED:String = 'renderd';
		
		/**
		 * 坐标轴标签被点击后触发的事件
		 */		
		public static const AXIS_LABEL_CLICKED:String = 'axisLabelClicked';
		
		/**
		 * 开启或者关闭渲染节点的鼠标交互， 柱状图等需要用到此特性； 
		 */		
		//public static const ENABLE_ITEM_RENDER_INTERACTION:String = 'enableItemRenderInteraction';
		//public static const DISABLE_ITEM_RENDER_INTERACTION:String = 'disableItemRenderInteraction';
		
		/**
		 */
		public function FiChartsEvent(type:String)
		{
			super(type, true);
		}
		
		/**
		 * 图例数据
		 */		
		private var _legendData:Vector.<LegendVO>;
		
		/**
		 *  setter and getter 
		 */		
		public function get legendData():Vector.<LegendVO>
		{
			return _legendData;
		}
		
		public function set legendData(value:Vector.<LegendVO>):void
		{
			_legendData = value;
		}
		
		/**
		 */		
		public var label:String = '';
		
		/**
		 */		
		public var labelIndex:uint = 0;
		
		/**
		 * 图表节点数据 
		 */		
		public var dataItem:SeriesDataPoint;
	}
}