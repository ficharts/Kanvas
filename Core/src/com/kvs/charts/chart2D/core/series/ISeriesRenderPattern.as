package com.kvs.charts.chart2D.core.series
{
	

	/**
	 * 两种序列渲染模式，经典模式和数据缩放模式；
	 * 
	 * 真正的渲染都是在模式中，不同类型的序列采取自己的两种模式
	 */	
	public interface ISeriesRenderPattern
	{
		/**
		 * 缩放模式下：样式，尺寸，数值分布特性的设定，但不渲染图表，
		 * 
		 * 图表渲染是由坐标轴驱动的
		 * 
		 * 
		 * 经典模式下：创建节点UI, 渲染节点UI；；
		 */		
		function render():void;
		
	}
}