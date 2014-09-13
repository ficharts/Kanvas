package view.element.video
{
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.element.state.ElementUnSelected;
	
	/**
	 */	
	public class VideoUnselected extends ElementUnSelected
	{
		public function VideoUnselected(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 */		
		override public function clicked():void
		{
			element.dispatchEvent(new ElementEvent(ElementEvent.FIRST_CLICKED, element));
			
			(element as VideoElement).play();
		}
		
		/**
		 */		
		override public function toPrevState():void
		{
			super.toPrevState();
			
			(element as VideoElement).reset();
		}
	}
}