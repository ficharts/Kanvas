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
		 * 获取序列的label，柱状图，条形图，饼图的label获取方式各不相同
		 * 
		 */			
		function get labels():Vector.<String>
			
		/**
		 * 
		 * 序列名称
		 * 
		 */			
		function get seriesName():String;
	}
}