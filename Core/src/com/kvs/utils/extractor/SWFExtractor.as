package com.kvs.utils.extractor
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 */	
	public class SWFExtractor extends ExtractorBase
	{
		public function SWFExtractor()
		{
			super();
		}
		
		/**
		 */		
		override public function init(bytes:ByteArray,limit:Number = 4194304, quality:Number = 80):void
		{
			_fileBytes = new ByteArray;
			
			_fileBytes.writeBytes(bytes, 0, bytes.bytesAvailable);
			
			var loaderContext:LoaderContext = new LoaderContext(); 
			
			if (CoreApp.isAIR)
			{
				loaderContext.allowLoadBytesCodeExecution = true; 
				loaderContext.allowCodeImport = true;
			}
			
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
			
			move1Loader = new ForcibleLoader(loader);
			move1Loader.loadBytes(bytes, loaderContext);
			
			
		}
		
		/**
		 */		
		private function swfLoaded(evt:Event):void
		{
			_view = loader.content as Sprite;
			
			loader.unload();
			this.dispatchEvent(evt);
		}
		
		/**
		 */		
		private var loader:Loader = new Loader;
		
		/**
		 */		
		private var move1Loader:ForcibleLoader;
		
		/**
		 */		
		override public function get view():Object
		{
			return _view;
		}
		
		/**
		 */		
		private var _view:Sprite;
		
		/**
		 */		
		override public function get fileBytes():ByteArray
		{
			return _fileBytes;
		}
		
		/**
		 */		
		private var _fileBytes:ByteArray;
	}
}