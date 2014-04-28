package view.element.text
{
	import view.element.ElementBase;
	import view.element.state.ElementUnSelected;
	import view.element.state.IEditShapeState;

	/**
	 * 文字未选择状态
	 */	
	public class TextUnselectedState extends ElementUnSelected implements IEditShapeState
	{
		public function TextUnselectedState(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 */		
		public function toEditState():void
		{
		}
		
	}
}