package model
{
	import flash.display.Loader;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 *
	 * 负责背景音乐的存储， 有着自己的数据模型
	 *  
	 * @author wanglei
	 * 
	 */	
	public class SoundElment
	{
		public function SoundElment()
		{
			fileR.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		/**
		 */		
		public function play():void
		{
			if (bgSound.length)
				bgSoundCh = bgSound.play(0);
		}
		
		/**
		 */		
		private var bgSoundCh:SoundChannel;
		
		/**
		 */		
		public function stop():void
		{
			if (bgSoundCh)
			{
				bgSoundCh.stop();
				bgSoundCh = null;
			}
		}
		
		/**
		 * 倒入数据时，重设背景音乐
		 */		
		public function resetSound(preURL:String):void
		{
			var req:URLRequest = new URLRequest("file://" + preURL + name);
			
			bgSound.load(req);
			fileR.load(req);
		}
		
		/**
		 */		
		public function insertSound(url:String, name:String):void
		{
			this.name = name;
			var req:URLRequest = new URLRequest(url);
			
			bgSound.load(req);
			fileR.load(req);
		}
		
		/**
		 * 获取mp3原始文件数据
		 */		
		public function get bytes():ByteArray
		{
			return fileR.data as ByteArray;
		}
		
		/**
		 */		
		public var name:String;
		
		/**
		 */		
		private var fileR:URLLoader = new URLLoader
		
		/**
		 */		
		private var bgSound:Sound = new Sound();
	}
}