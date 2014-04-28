package view.element.text
{
	import view.element.ElementBase;
	import view.element.state.ElementPrevState;
	import view.element.state.IEditShapeState;
	
	/**
	 */	
	public class TextPrevState extends ElementPrevState implements IEditShapeState
	{
		public function TextPrevState(element:ElementBase)
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