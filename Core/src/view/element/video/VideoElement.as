package view.element.video
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import model.vo.ElementVO;
	
	import modules.pages.PageEvent;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.element.state.ElementGroupState;
	import view.element.state.ElementMultiSelected;
	import view.ui.IMainUIMediator;
	import view.ui.canvas.Canvas;
	
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
			
			playState = new PlayState(this);
			pauseState = new PauseState(this);
			
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK, resetVideoHandler);
		}
		
		/**
		 */		
		override public function startDraw(canvas:Canvas):void
		{
			this.pause();
		}
		
		/**
		 */		
		override public function checkTrueRender():Boolean
		{
			return true;
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
			
			if (videoVO.url)
			{
				ns.play("file://" + videoVO.url); 
				videoState = pauseState;
				ns.pause();
				
			}
			else
			{
				var evt:KVSEvent = new KVSEvent(KVSEvent.SET_VIDEO_URL);
				evt.element = this;
				this.dispatchEvent(evt);
			}
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
				videoState = pauseState;
				ns.pause();
				
				ns.seek(0);//将播放头置于视频开始处
				
			}
			else if (evt.info.code == "NetStream.Play.Start") 
			{
				render();
				
				this.dispatchEvent(new ElementEvent(ElementEvent.UPDATE_SELECTOR));
				
				if (isPage)
					vo.pageVO.dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB));
			}
		}
		
		/**
		 */		
		public function get data():ByteArray
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
		public function get videoVO():VideoVO
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
		override protected function get graphicRect():Rectangle
		{
			return new Rectangle(video.x, video.y, video.videoWidth, video.videoHeight);
		}
		
		/**
		 * 视频文件的完整名称
		 */		
		public function get fileName():String
		{
			return dataID + "." + videoVO.videoType;
		}
		
		/**
		 */		
		public function get dataID():String
		{
			return videoVO.videoID.toString();
		}
	}
}