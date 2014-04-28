package com.kvs.ui.colorPanel
{
	import view.elementSelector.toolBar.StyleBtn;

	/**
	 * 使用到颜色面板的对象，颜色面板的交互会
	 * 
	 * 调用host对象上的方法
	 */	
	public interface IColorPanelHost
	{
		/**
		 * 鼠标滑过非选择颜色时
		 */		
		function previewColor(colorBtn:StyleBtn):void;
			
		/**
		 * 鼠标移出颜色面板时触发
		 */			
		function panelRollOut(curColorBtn:StyleBtn):void;
		
		/**
		 * 选择了某个颜色后触发
		 */		
		function colorSelected(curColorBtn:StyleBtn):void
			
	}
}