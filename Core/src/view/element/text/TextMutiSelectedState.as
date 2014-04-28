package view.element.text
{
	import view.element.ElementBase;
	import view.element.state.ElementMultiSelected;
	import view.element.state.IEditShapeState;
	
	/**
	 */	
	public class TextMutiSelectedState extends ElementMultiSelected implements IEditShapeState
	{
		public function TextMutiSelectedState(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 * 
		 */		
		public function toEditState():void
		{
			
		}
	}
}