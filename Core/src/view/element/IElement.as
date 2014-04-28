package view.element
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	import model.vo.ElementVO;

	/**
	 * 原件的公共接口
	 */	
	public interface IElement
	{
		function get vo():ElementVO;
		function set vo(value:ElementVO):void;
		
		/**
		 * 绘制内容的容器
		 */		
		function get shape():DisplayObject
	}
}