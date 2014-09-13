package view.element.video
{
	import view.element.ElementBase;
	import view.element.state.ElementSelected;
	
	/**
	 * 
	 */	
	public class VideoSelectedState extends ElementSelected
	{
		public function VideoSelectedState(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 * 再次click已处于选择状态下的图形会，取消选择，然后创建文本框
		 */
		override public function clicked():void
		{
			videoElement.play();
		}
		
		/**
		 */		
		private function get videoElement():VideoElement
		{
			return element as VideoElement;
		}
		
		/**
		 */		
		override public function toPrevState():void
		{
			super.toPrevState();
			
			videoElement.reset();
		}
	}
}