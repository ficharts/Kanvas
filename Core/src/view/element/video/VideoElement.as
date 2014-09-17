package view.element.video
{
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import model.vo.ElementVO;
	
	import modules.pages.PageEvent;
	
	import util.img.ImgLib;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.element.ISource;
	import view.element.state.ElementGroupState;
	import view.element.state.ElementMultiSelected;
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
			
			playState = new PlayState(this);
			pauseState = new PauseState(this);
			
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK, resetVideoHandler);
		}
		
		/**
		 */		
		override public function flashStart():void
		{
			this.pause();
		}
		
		/**
		 */		
		private function resetVideoHandler(evt:MouseEvent):void
		{
			this.reset();
		}
		
		/**
		 */		
		internal var playState:VideoStateBase;
		internal var pauseState:VideoStateBase;
		
		/**
		 */		
		internal var videoState:VideoStateBase;
		
		/**
		 */		
		override public function play():void
		{
			videoState.play();
		}
		
		/**
		 */		
		public function pause():void
		{
			videoState.pause();
		}
		
		/**
		 */		
		public function stop():void
		{
			videoState.stop();
		}
		
		/**
		 */		
		override public function clickedForPreview(cmt:IMainUIMediator):void
		{
			cmt.zoomElement(vo);
			
			play();
		}
		
		/**
		 */		
		override protected function initState():void
		{
			selectedState = new VideoSelectedState(this);
			unSelectedState = new VideoUnselected(this);
			multiSelectedState = new ElementMultiSelected(this);
			groupState = new ElementGroupState(this);
			prevState = new VideoPrevState(this);
			
			currentState = unSelectedState;
		}
		
		/**
		 */		
		override protected function init():void
		{
			preRender();
			
			if (!data && ImgLib.ifHasData(videoVO.videoID))
				videoVO.source = ImgLib.getData(videoVO.videoID);
			
			video = new Video(vo.width, vo.height);
			addChild(video);
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			
			ns = new NetStream(nc);
			ns.client = {};
			ns.backBufferTime = 0;
			
			ns.addEventListener(NetStatusEvent.NET_STATUS, status);
			video.attachNetStream(ns);
			
			reset();
			render();
		}
		
		/**
		 */		
		public function reset():void
		{
			ns.close();
			
			if (data)
			{
				ns.play(null);
				ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);	
				
				data.position = 0;
				ns.appendBytes(data);
			}
			else
			{
				ns.play("file://" + videoVO.url); 
			}
			
			videoState = pauseState;
			ns.pause();
		}
		
		/**
		 */		
		override public function del():void
		{
			super.del();
			
			ns.close();
		}
		
		/**
		 */		
		public var isPlaying:Boolean = false;
		
		/**
		 */		
		private function status(evt:NetStatusEvent):void
		{
			if (evt.info.code == "NetStream.Play.Stop") 
			{
				//url加载方式播放时，此处会报错,所以先注释掉
				//ns.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
			}
			else if (evt.info.code == "NetStream.Play.Start") 
			{
				render();
				this.dispatchEvent(new ElementEvent(ElementEvent.UPDATE_SELECTOR));
			}
			else if (evt.info.code == "NetStream.Buffer.Full") 
			{
				//含有视频的文件再次打开时视频开始播放时才可以截图给页面
				if (isPage)
					vo.pageVO.dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, vo.pageVO));
			}
		}
		
		/**
		 */		
		internal function get data():ByteArray
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
		internal var ns:NetStream;
		
		/**
		 */		
		private var video:Video;
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			if(video.videoWidth > 0)
			{
				vo.width = video.width = video.videoWidth;
				vo.height = video.height = video.videoHeight;
				
				video.x = - vo.width / 2;
				video.y = - vo.height / 2;
				
				super.render();
			}
		}
		
		/**
		 */		
		public function get dataID():String
		{
			return videoVO.videoID.toString();
		}
	}
}