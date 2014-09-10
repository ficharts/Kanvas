package view.element.video
{
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.ByteArray;
	
	import model.vo.ElementVO;
	
	import util.img.ImgLib;
	
	import view.element.ElementBase;
	import view.element.ISource;
	import view.ui.IMainUIMediator;
	
	/**
	 *
	 * 视频原件
	 *  
	 * @author wanglei
	 * 
	 */	
	public class VideoElement extends ElementBase implements ISource
	{
		public function VideoElement(vo:ElementVO)
		{
			super(vo);
		}
		
		/**
		 */		
		override public function play():void
		{
			
		}
		
		/**
		 */		
		public function pause():void
		{
			
		}
		
		/**
		 */		
		public function stop():void
		{
			
		}
		
		/**
		 */		
		override public function clickedForPreview(cmt:IMainUIMediator):void
		{
			
		}
		
		/**
		 */		
		override protected function init():void
		{
			preRender();
			
			if (data)
			{
				videoVO.videoID = ImgLib.imgID;
				ImgLib.register(videoVO.videoID.toString(), data, videoVO.videoType);
			}
			else
			{
				if (ImgLib.ifHasData(videoVO.videoID))
					videoVO.source = ImgLib.getData(videoVO.videoID);
			}
			
			video = new Video(vo.width, vo.height);
			addChild(video);
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			
			ns = new NetStream(nc);
			ns.client = {};
			video.attachNetStream(ns);
			
			ns.backBufferTime = 3;
			ns.play(null);
			ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
			ns.addEventListener(NetStatusEvent.NET_STATUS, status);
			
			data.position = 0;
			ns.appendBytes(data);
			
			ns.pause();
			
			render();
		}
		
		/**
		 */		
		public var isPlaying:Boolean = false;
		
		/**
		 */		
		private function status(evt:NetStatusEvent):void
		{
			trace(evt.info);
			
			if (evt.info.code == "NetStream.Play.Stop") {
				ns.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
			}
		}
		
		/**
		 */		
		private function get data():ByteArray
		{
			return (vo as VideoVO).source;
		}
		
		/**
		 */		
		private function get url():String
		{
			return (vo as VideoVO).url;
		}
		
		/**
		 */		
		private function get videoVO():VideoVO
		{
			return vo as VideoVO;
		}
		
		/**
		 */		
		private var ns:NetStream;
		
		/**
		 */		
		private var video:Video;
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			vo.width = video.width = video.videoWidth;
			vo.height = video.height = video.videoHeight;
			
			video.x = - vo.width / 2;
			video.y = - vo.height / 2;
			
			super.render();
			
		}
		
		/**
		 */		
		public function get dataID():String
		{
			return videoVO.videoID.toString();
		}
	}
}