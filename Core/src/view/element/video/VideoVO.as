package view.element.video
{
	import flash.utils.ByteArray;
	
	import model.vo.ElementVO;
	
	/**
	 */	
	public class VideoVO extends ElementVO
	{
		public function VideoVO()
		{
			super();
		}
		
		/**
		 */		
		public var source:ByteArray;
		
		/**
		 */		
		public var videoID:uint = 0;
	}
}