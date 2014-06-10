package util.img
{
	import com.kvs.utils.extractor.ExtractorBase;
	import com.kvs.utils.extractor.ImageExtractor;
	import com.kvs.utils.extractor.SWFExtractor;
	import com.kvs.utils.system.OS;
	
	import flash.display.AVM1Movie;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import view.ui.Bubble;

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
				var loaderContext:LoaderContext = new LoaderContext(); 
				
				if (CoreApp.isAIR)
				{
					loaderContext.allowLoadBytesCodeExecution = true; 
					loaderContext.allowCodeImport = true;
				}
				
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				imgLoader.loadBytes(bytes, loaderContext);
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
			imgLoaded();
			
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaedFromLocal);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadErrorFromLocal);
		}
		
		/**
		 * 从服务器根据url地址加载到图片
		 */		
		private function imgloadedFromServer(evt:Event):void
		{
			imgLoaded();
			
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgloadedFromServer);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadImgErrorFormServer);
		}
		
		/**
		 */		
		private function imgLoaded():void
		{
			var data:Object;
			if (imgLoader.content is Bitmap)
				data = (imgLoader.content as Bitmap).bitmapData;
			else
				data = imgLoader.content;
			
			_fileBytes = imgLoader.contentLoaderInfo.bytes;
			imgLoader.unload();
			isLoading = false;
			
			//将加载的旧版本的swf转换为最新版本的
			if (data is AVM1Movie)
			{
				var swfExtractor:SWFExtractor = new SWFExtractor();
				swfExtractor.addEventListener(Event.COMPLETE, function(evt:Event):void {
				
					data = swfExtractor.view;
					dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED, data));
				});
				
				swfExtractor.init(_fileBytes);
			}
			else
			{
				this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED, data));
			}
			
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
			
			try
			{
				fileReference.browse([new FileFilter("Images", "*.jpg;*.png;*.swf")]);
			} 
			catch(e:Error) 
			{
				//同时只能进行一个窗口选择
			}
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
			
			try
			{
				var type:String = fileReference.name.split('.')[1].toString();
				if (type == "swf")
					imageExtractor = new SWFExtractor();
				else
					imageExtractor = new ImageExtractor();
				
				imageExtractor.addEventListener(Event.COMPLETE, bmdLoadedFromLocalHandler);
				imageExtractor.init(fileReference.data);
			}
			catch (o:Error)
			{
				Bubble.show(o.message);
			}
			
		}
		
		/**
		 */		
		private function bmdLoadedFromLocalHandler(evt:Event):void
		{
			_fileBytes = imageExtractor.fileBytes;
			
			imageExtractor.removeEventListener(Event.COMPLETE, bmdLoadedFromLocalHandler);
			
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imageExtractor.view, imgID, null, _fileBytes));
			sendImgDataToServer();
		}
		
		/**
		 * 图片文件原始数据
		 */		
		public function get fileBytes():ByteArray
		{
			return _fileBytes;
		}
		
		/**
		 */		
		private var _fileBytes:ByteArray;
		
			
		
		
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
				imgOK(imageExtractor.view);
			}
			else
			{
				var req:URLRequest = new URLRequest(IMG_UPLOAD_URL);
				req.method = URLRequestMethod.POST;
				req.contentType = "application/octet-stream";  
				req.data = imageExtractor.fileBytes;
				
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
			imgOK(imageExtractor.view);
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
		private function imgOK(bmd:Object = null):void
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
		private var imageExtractor:ExtractorBase;
		
		/**
		 */		
		private var fileReference:FileReference = new FileReference();
		
		private var lastSelectedImageURL:String;
		
		
	}
}