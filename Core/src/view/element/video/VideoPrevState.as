package view.element.video
{
	import view.element.ElementBase;
	import view.element.state.ElementPrevState;
	
	/**
	 */	
	public class VideoPrevState extends ElementPrevState
	{
		public function VideoPrevState(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 */		
		override public function clicked():void
		{
			(element as VideoElement).play();
		}
		
		
	}
}