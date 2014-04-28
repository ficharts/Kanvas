package util.img
{
	import com.adobe.images.PNGEncoder;
	import com.greensock.loading.ImageLoader;
	import com.kvs.utils.ImageExtractor;
	import com.kvs.utils.system.OS;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	/**
	 * 图片插入器, 负责从客户端选取图片，并上传至指定服务器
	 * 
	 * 上传成功后，返回图片URL和图片的bitmapdata数据
	 * 
	 */	
	public class ImgInsertor extends EventDispatcher
	{
		/**
		 */		
		public function ImgInsertor()
		{
			imgUpLoader = new URLLoader();
			imgUpLoader.dataFormat = URLLoaderDataFormat.BINARY;
			imgUpLoader.addEventListener(IOErrorEvent.IO_ERROR, imgUploadError);
			imgUpLoader.addEventListener(Event.COMPLETE, imgUploadHandler);
			imgUpLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, imgUploadSecurityError);
		}
		
		/**
		 * 从服务端加载图片数据流错误
		 */		
		private function imgByteLoadError(e:IOErrorEvent):void
		{
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_ERROR));
		}
		
		/**
		 */		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace('ImgInsertor.ioErrorHandler()');
		}
		
		/**
		 * 图片上传过程中，删除图片等于取消上传
		 */		
		public function deleteIMG(imgID:uint):void
		{
			imgUpLoader.close();
		}
		
		/**
		 * 图片的原始数据 
		 */		
		public var bitmapBytes:ByteArray;
		
		/**
		 * 图片ID， 每个图片都会含有一个图片ID， 服务端也会根据此ID记录
		 * 
		 * 图片，由于将来删除图片时作为标识
		 */		
		private var imgID:uint;
		
		
		
		
		//-------------------------------------------------
		//
		//
		// 从服务器加载图片
		//
		//
		//-------------------------------------------------
		
		/**
		 */		
		public function loadImg(url:String):void
		{
			if (isLoading == false)
			{
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgloadedFromServer);
				imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadImgErrorFormServer);
				
				if (url.indexOf("http") != 0)
					url = IMG_DOMAIN_URL + url;
				
				imgLoader.load(new URLRequest(url));
				isLoading = true;
			}
		}
		
		/**
		 * 加载图片的二进制数据，此方法用于客户端中，打开文件时，图片原始数据存在于IMGLib中的情况
		 */		
		public function loadImgBytes(bytes:ByteArray):void
		{
			isLoading = true;
			
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaedFromLocal);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadErrorFromLocal);
			
			try
			{
				imgLoader.loadBytes(bytes);
			} 
			catch(error:Error) 
			{
				trace("图片格式错误");
			}
		}
		
		/**
		 */		
		private function imageLoadErrorFromLocal(e:IOErrorEvent):void
		{
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_ERROR));
			
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaedFromLocal);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadErrorFromLocal);
		}
		
		/**
		 * 从本地加载图片
		 */		
		private function imageLoaedFromLocal(evt:Event):void
		{
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED, (imgLoader.content as Bitmap).bitmapData));
			
			imgLoader.unload();
			isLoading = false;
			
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaedFromLocal);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadErrorFromLocal);
		}
		
		/**
		 * 从服务器根据url地址加载到图片
		 */		
		private function imgloadedFromServer(evt:Event):void
		{
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED, (imgLoader.content as Bitmap).bitmapData));
			
			imgLoader.unload();
			isLoading = false;
			
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgloadedFromServer);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadImgErrorFormServer);
		}
		
		/**
		 * 从服务器加载图片失败
		 */		
		private function loadImgErrorFormServer(io:IOErrorEvent):void
		{
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_ERROR));
			
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgloadedFromServer);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadImgErrorFormServer);
		}
		
		/**
		 */		
		public var isLoading:Boolean = false;
		
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		//
		// 
		// 选择并上传图片至服务器
		//
		//
		//
		//----------------------------------------------
		
		/**
		 * 从客户端选择，加载图片, 给图片分配ID
		 */		
		public function insert(imgID:uint):void
		{
			this.imgID = imgID;
			
			fileReference.addEventListener(Event.SELECT, onFileSelected);
			fileReference.browse([new FileFilter("Images", "*.jpg;*.png")]);
		}
		
		/**
		 */		
		private function onFileSelected(e:Event):void 
		{
			_chooseSameImage = (lastSelectedImageURL == fileReference.name);
			lastSelectedImageURL = fileReference.name;
			
			fileReference.removeEventListener(Event.SELECT, onFileSelected);
			fileReference.addEventListener(Event.COMPLETE, onFileLoaded);
			
			try
			{
				//载入图片前，先扩充内存，防止图片过大导致的fp崩溃
				OS.enlargeMemory();
				fileReference.load();
			} 
			catch(error:Error) 
			{
				trace('加载图片失败');
			}
		}
		
		/**
		 */		
		private function onFileLoaded(e:Event):void 
		{
			//OS.memoryGc();
			fileReference.removeEventListener(Event.COMPLETE, onFileLoaded);
			
			
			imageExtractor = new ImageExtractor(fileReference.data);
			imageExtractor.addEventListener(Event.COMPLETE, bmdLoadedFromLocalHandler);
		}
		
		/**
		 */		
		private function bmdLoadedFromLocalHandler(evt:Event):void
		{
			imageExtractor.removeEventListener(Event.COMPLETE, bmdLoadedFromLocalHandler);
			
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imageExtractor.bitmapData, imgID));
			sendImgDataToServer();
		}
		
		/**
		 * 将图片的字节数据发送至服务器, 成功后注册图片到图片库中
		 * 
		 * 服务端返回图片的URL
		 */		
		private function sendImgDataToServer():void
		{
			//服务地址没有配置时，直接显示图片
			if (IMG_UPLOAD_URL == null)
			{
				imgOK(imageExtractor.bitmapData);
			}
			else
			{
				var req:URLRequest = new URLRequest(IMG_UPLOAD_URL);
				req.method = URLRequestMethod.POST;
				req.contentType = "application/octet-stream";  
				req.data = imageExtractor.bytes;
				
				//发送图片数据流质服务器
				imgUpLoader.load(req);
			}
			
		}
		
		/**
		 */		
		public function close():void
		{
			lastSelectedImageURL = null;
			
			try 
			{
				imgUpLoader.close();
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 图片上传成功
		 */		
		private function imgUploadHandler(evt:Event):void
		{
			imgOK(imageExtractor.bitmapData);
		}
		
		/**
		 * 
		 */		
		private function imgUploadError(e:IOErrorEvent):void
		{
			imgOK();
		}
		
		private function imgUploadSecurityError(e:SecurityErrorEvent):void
		{
			imgOK();
		}
		
		/**
		 */		
		private function imgOK(bmd:BitmapData = null):void
		{
			imgUpLoader.removeEventListener(IOErrorEvent.IO_ERROR, imgUploadError);
			imgUpLoader.removeEventListener(Event.COMPLETE, imgUploadHandler);
			imgUpLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, imgUploadSecurityError);
			
			var imgURL:String;
			if (imgUpLoader.data)
				imgURL = imgUpLoader.data.toString();
				
			dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, bmd, imgID, imgURL));
			
			imgLoader.unload();
			fileReference.data.clear();
		}
			
		/**
		 */		
		public function get chooseSameImage():Boolean
		{
			return _chooseSameImage;
		}
		
		/**
		 */		
		private var _chooseSameImage:Boolean;
		
		/**
		 * 图片上传服务
		 */		
		public static var IMG_UPLOAD_URL:String = null;
		
		public static var IMG_DOMAIN_URL:String = "";
		
		/**
		 */		
		private var imgUpLoader:URLLoader = new URLLoader;
		
		/**
		 */		
		private var imgLoader:Loader = new Loader;
		
		/**
		 * 负责图片压缩优化 
		 */		
		private var imageExtractor:ImageExtractor;
		
		/**
		 */		
		private var fileReference:FileReference = new FileReference();
		
		private var lastSelectedImageURL:String;
		
		
	}
}