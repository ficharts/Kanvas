package view.element.text
{
	import view.element.ElementBase;
	import view.element.state.ElementGroupState;
	import view.element.state.IEditShapeState;
	
	/**
	 * 
	 */	
	public class TextGroupState extends ElementGroupState implements IEditShapeState
	{
		public function TextGroupState(element:ElementBase)
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