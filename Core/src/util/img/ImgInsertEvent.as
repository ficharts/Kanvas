package util.img
{
	import flash.display.BitmapData;
	import flash.events.Event;

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
		public function ImgInsertEvent(type:String, data:BitmapData = null, imgID:uint = 0, imgURL:String = null)
		{
			super(type);
			
			this.bitmapData = data;
			this.imgID = imgID;
			this.imgURL = imgURL;
		}
		
		/**
		 */		
		public var bitmapData:BitmapData;
		
		/**
		 */		
		public var imgID:uint;
		
		/**
		 */		
		public var imgURL:String;
	}
}