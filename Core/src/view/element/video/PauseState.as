package view.element.video
{
	public class PauseState extends VideoStateBase
	{
		public function PauseState(videoElement:VideoElement)
		{
			super(videoElement);
		}
		
		/**
		 */		
		override public function play():void
		{
			
			//videoEle.data.position = 0;
			//videoEle.ns.appendBytes(videoEle.data);
			videoEle.ns.resume();
			videoEle.videoState = videoEle.playState;
		}
	}
}