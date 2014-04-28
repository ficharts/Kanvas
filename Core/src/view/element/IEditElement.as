package view.element
{
	/**
	 * 复杂的元件比通用元件多一个编辑状态，
	 * 
	 * 进入到编辑模式后，会开启特有的编辑面板
	 */	
	public interface IEditElement
	{
		/**
		 * 进入到编辑状态 
		 */		
		function toEditState():void;
		
	}
}