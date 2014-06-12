package util.img
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 */	
	public class ImgInsertEvent extends Event
	{
		/**
		 * 图片被加载到了内存中
		 */		
		public static const IMG_LOADED_TO_LOCAL:String = 'imgLoadedToLocal';
		
		/**
		 * 图片从服务器／内存中加载成功
		 */		
		public static const IMG_LOADED:String = 'imgLoaded';
		
		/**
		 * 图片已上传至服务器
		 */		
		public static const IMG_UPLOADED_TO_SERVER:String = 'imgUploadedToServer';
		
		/**
		 * 图片从服务器加载失败, 地址错误或服务器链接失败 
		 */		
		public static const IMG_LOADED_ERROR:String = 'imgLoadError';
		
		/**
		 */		
		public function ImgInsertEvent(type:String, data:Object = null, imgID:uint = 0, imgURL:String = null, fileBytes:ByteArray = null)
		{
			super(type);
			
			this.viewData = data;
			this.fileBytes = fileBytes;
			
			this.imgID = imgID;
			this.imgURL = imgURL;
			
		}
		
		/**
		 * 显示对象，sprite 或者 bitmapdata
		 */		
		public var viewData:Object;
		
		/**
		 */		
		public var fileBytes:ByteArray;
		
		/**
		 */		
		public var imgID:uint;
		
		/**
		 */		
		public var imgURL:String;
	}
}