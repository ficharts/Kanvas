package view.element.state
{
	/**
	 * 有些复杂元件具有编辑状态，
	 * 
	 * 其非选择和选择两个状态与标准元件兼容
	 * 
	 */	
	public interface IEditShapeState
	{
		function toSelected():void;
		function toUnSelected():void;
		function toEditState():void;
	}
}