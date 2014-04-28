package landray.kp.model
{
	import cn.vision.utils.LogUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public final class Model1Maps extends _InternalModel
	{
		public function Model1Maps(url:String)
		{
			super();
			initialize(url);
		}
		private function initialize(url:String=null):void
		{
			loader = new URLLoader;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			request = new URLRequest(url);
			request.method = URLRequestMethod.GET;
		}
		
		override public function execute():void
		{
			executeStart();
			if (request.url) 
			{
				loader.load(request);
			} 
			else 
			{
				LogUtil.log(className+"execute():param url is null!");
				executeEnd();
			}
		}
		
		private function complete(e:Event):void
		{
			/*var newByte:ByteArray = Base64.decode(loader.data.toString());
			//trace(newByte.toString());
			newByte.uncompress();*/
			var xml:XML = XML(String(loader.data.toString()));
			
			data = provider.dataXML = xml;
			
			executeEnd();
		}
		private function ioError(e:Event):void
		{
			LogUtil.logFunction(className, "ioError");
			executeEnd();
		}
		
		private var path   :String;
		private var loader :URLLoader;
		private var request:URLRequest;
	}
}