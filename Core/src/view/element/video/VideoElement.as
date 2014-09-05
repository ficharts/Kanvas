package view.element.video
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import model.vo.ElementVO;
	
	import view.element.ElementBase;
	
	/**
	 *
	 * 视频原件
	 *  
	 * @author wanglei
	 * 
	 */	
	public class VideoElement extends ElementBase
	{
		public function VideoElement(vo:ElementVO)
		{
			super(vo);
		}
		
		/**
		 */		
		override protected function init():void
		{
			preRender();
			
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			
			stream = new NetStream(nc);
			stream.client = this;
			stream.play(null);
			
			data.position = 0;
			stream.appendBytes(data);
			video.attachNetStream(stream);
			
			video.width = vo.width;
			video.height = vo.height;
			
			
			addChild(video);
			
			render();
		}
		
		/**
		 */		
		private function get data():ByteArray
		{
			return (vo as VideoVO).source;
		}
		
		/**
		 */		
		private var stream:NetStream;
		
		/**
		 */		
		private var video:Video = new Video;
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
		}
	}
}