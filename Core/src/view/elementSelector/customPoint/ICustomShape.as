package view.elementSelector.customPoint
{
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import view.elementSelector.ElementSelector;

	/**
	 * 有些图形需要更精确的形状控制，例如五角星的内半径；
	 * 
	 * 矩形的圆角
	 */	
	public interface ICustomShape
	{
		/**
		 * 拖动自定义控制点后，渲染图形
		 * 
		 * 同一个图形可能有多个自定义控制点, control用来区分控制点
		 */		
		function customRender(selector:ElementSelector, control:CustomPointControl):void;
		
		/**
		 * 更新定位自定义控制点的位置，跟新选择器布局时调用
		 */		
		function layoutCustomPoint(selector:ElementSelector, style:Style):void;
		
		/**
		 */		
		function get propertyNameArray():Array
	}
}