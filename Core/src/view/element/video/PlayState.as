package view.element.video
{
	/**
	 */	
	public class PlayState extends VideoStateBase
	{
		public function PlayState(videoElement:VideoElement)
		{
			super(videoElement);
		}
		
		/**
		 */		
		override public function play():void
		{
			videoEle.ns.pause();
			
			videoEle.videoState = videoEle.pauseState;
		}
		
		/**
		 */		
		override public function pause():void
		{
			videoEle.ns.pause();
			
			videoEle.videoState = videoEle.pauseState;
		}
	}
}