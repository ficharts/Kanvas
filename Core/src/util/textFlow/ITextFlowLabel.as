package util.textFlow
{
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.formats.TextLayoutFormat;

	/**
	 * 采用文本引擎的label
	 */	
	public interface ITextFlowLabel 
	{
		
		function get text():String;
		function set text(value:String):void;
		
		/**
		 * 
		 */		
		function get textLayoutFormat():TextLayoutFormat
			
		/**
		 */		
		function get textManager():TextContainerManager;
		
		/**
		 */
		function get ifMutiLine():Boolean
		
		/**
		 */
		function set ifMutiLine(value:Boolean):void;
		
		/**
		 */		
		function get fixWidth():Number
		
		/**
		 */
		function set fixWidth(value:Number):void
		
		/**
		 * 字体加载完成后重绘, 然后同时field
		 * 
		 * field 需要进行布局调整
		 */		
		function afterReRender():void
				
	}
}