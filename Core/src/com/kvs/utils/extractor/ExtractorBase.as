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
		
		/**
		 * 资源类型，对应文件的扩展名
		 */		
		public function get type():String
		{
			return null;
		}
	}
}