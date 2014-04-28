package
{
	import com.kvs.utils.Base64;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	/**
	 * 
	 * @author wallenMac
	 * 
	 * 不同平台下api封装不同，因为web端与AIR端的数据接口处理方式不一样
	 * 
	 */	
	public class KanvasAPI
	{
		public function KanvasAPI(core:CoreApp)
		{
			this.core = core;
		}
		
		/**
		 */		
		public function setXMLData(data:String):void
		{
			core.importData(XML(data));
		}
		
		/**
		 * 获取字符串格式的数据(XML结构)
		 */		
		public function getXMLData():String
		{
			var str:String = core.exportData().toXMLString();
			
			return str;
		}
		
		/**
		 * 将数据压缩后再进行64编码,XML压缩率可达85%
		 */		
		public function getBase64Data(ifCompress:Boolean = true):String
		{
			var byte:ByteArray = new ByteArray();
			byte.writeUTFBytes(getXMLData());
			
			if (ifCompress)
				byte.compress();
			
			return Base64.encodeByteArray(byte);
		}
		
		/**
		 * 将字符串进行Base64编码
		 */		
		protected function stringToBase64(str:String):String
		{
			var byte:ByteArray = new ByteArray();
			byte.writeUTFBytes(str);
			byte.compress();
			
			return Base64.encodeByteArray(byte);
		}
		
		/**
		 *
		 * 获取多页面的截图
		 *  
		 * @param url
		 * @param pageW
		 * @param pageH
		 * 
		 */		
		public function getPageImgData(url:String, pageW:Number = 960, pageH:Number = 720):void
		{
			var loader:URLLoader = new URLLoader;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			
			
			loader.addEventListener(Event.COMPLETE, uploadPageData);
			loader.addEventListener(IOErrorEvent.IO_ERROR, uploadPageData);
			
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			request.data = core.thumbManager.getPageBytes(pageW, pageH);
			loader.load(request);
		}
		
		private function uploadPageData(e:Event):void
		{
			trace(e.target.data);
			
			e.target.removeEventListener(Event.COMPLETE, uploadPageData);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, uploadPageData);
		}
		
		/**
		 */		
		protected var core:CoreApp;
	}
}