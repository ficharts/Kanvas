package view.element
{
	/**
	 */	
	public interface IText
	{
		function get visible():Boolean;
		
		/**
		 * 用位图方式显示文字，这种模式下性能较好； 
		 */		
		function useBitmap():void;
		
		/**
		 * 文字放大后，必须以适量方式渲染 
		 */		
		function useText():void;
	}
}