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
			
			type = "video";
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			var xml:XML = super.exportData();
			
			xml.@videoID = videoID;
			xml.@videoType = videoType;
			
			return xml;
		}
		
		/**
		 */		
		override public function clone():ElementVO
		{
			var videoVO:VideoVO = super.clone() as VideoVO;
			
			videoVO.source = this.source;
			videoVO.videoID = videoID;
			videoVO.videoType = videoType;
			
			return videoVO;
		}
		
		/**
		 */		
		public var source:ByteArray;
		
		/**
		 */		
		public var url:String;
		
		/**
		 */		
		public var videoID:uint = 0;
		
		/**
		 */		
		public var videoType:String;
		
	}
}