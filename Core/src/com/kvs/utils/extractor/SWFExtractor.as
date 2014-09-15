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
		override public function get type():String
		{
			return "swf";
		}
		
		/**
		 */		
		override public function init(bytes:ByteArray,limit:Number = 4194304, quality:Number = 80):void
		{
			_fileBytes = bytes;
			
			var loaderContext:LoaderContext = new LoaderContext(); 
			
			if (CoreApp.isAIR)
			{
				loaderContext.allowLoadBytesCodeExecution = true; 
				loaderContext.allowCodeImport = true;
			}
			
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
			loader.loadBytes(_fileBytes, loaderContext);
		}
		
		/**
		 */		
		private function swfLoaded(evt:Event):void
		{
			_view = loader.content;
			
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
		private var _view:Object;
		
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