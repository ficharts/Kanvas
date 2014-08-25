package com.kvs.charts.chart2D.encry
{
	import com.kvs.charts.common.SeriesDataPoint;

	/**
	 *
	 * 序列的统一接口
	 *  
	 * @author wanglei
	 * 
	 */	
	public interface ISeries
	{
		/**
		 * 
		 * 获取序列的节点数据，节点数据包含了详细的信息
		 * 
		 */		
		function get dataItemVOs():Vector.<SeriesDataPoint>
			
		/**
		 * 
		 * 获取序列的字段，柱状图，条形图，饼图的label获取方式各不相同
		 * 
		 */			
		function get labels():Vector.<String>
			
		/**
		 * 
		 * 获取序列的值，柱状图，条形图，饼图的label获取方式各不相同
		 * 
		 */			
		function exportValues(split:String):String
			
		/**
		 * 
		 * 序列名称
		 * 
		 */			
		function get seriesName():String;
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get type():String;
		
		/**
		 */		
		function get xField():String;
		
		/**
		 */		
		function get yField():String;
		
		/**
		 */		
		function set xField(value:String):void;
		
		/**
		 */		
		function set yField(value:String):void;
	}
}