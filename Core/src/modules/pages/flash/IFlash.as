package modules.pages.flash
{
	import view.element.ElementBase;
	import view.element.IElement;

	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public interface IFlash
	{
		function get index():uint
		function set index(value:uint):void
			
		function clone():IFlash
		function expertData():XML
		
		function start():void
		function end():void
		
		function next():void
		function prev():void

		function get element():IElement;
		function set element(value:IElement):void;
		
		function get elementID():uint
		function set elementID(value:uint):void
	}
}