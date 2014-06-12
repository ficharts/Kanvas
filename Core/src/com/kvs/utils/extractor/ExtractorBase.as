package com.kvs.utils.extractor
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class ExtractorBase extends EventDispatcher
	{
		public function ExtractorBase()
		{
			super();
		}
		
		/**
		 */		
		public function init(bytes:ByteArray, limit:Number = 4194304, quality:Number = 80):void
		{
			
		}
		
		/**
		 * 图片内容， bitmapdata 或者 sprite 对象
		 */		
		public function get view():Object
		{
			return null;
		}
		
		/**
		 * 图片文件的数据， jpg，png，或者swf文件
		 */		
		public function get fileBytes():ByteArray
		{
			return null;
		}
	}
}