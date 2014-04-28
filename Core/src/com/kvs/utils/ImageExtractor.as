package com.kvs.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	[Event(name="complete", type="flash.events.Event")]
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	public class ImageExtractor extends EventDispatcher
	{
		/**
		 * 图片优化处理类，传入一个二进制字节流，通过监听事件方式，获取优化后的图片字节流与位图数据。
		 * 
		 * @param $bytes 传入的图片字节流数据。
		 * @param $limit 尺寸限制，值为宽度*高度，超过该尺寸的图片，会被缩小至该尺寸以下。
		 * @param $quality 如果是jpg，该属性为jpg图片质量。
		 */
		public function ImageExtractor($bytes:ByteArray, $limit:Number = 4194304, $quality:Number = 80)
		{
			super();
			if ($bytes)
				initialize($bytes, $limit);
			else
				throw new ArgumentError("参数$bytes不能为空。", 2007);
		}
		
		private function initialize($bytes:ByteArray, $limit:Number = 4194304, $quality:Number = 80):void
		{
			limit   = $limit;
			quality = $quality;
			tempo   = new ByteArray;
			$bytes.readBytes(tempo);
			if (tempo.length > 2)
				analyse();
			else
				throw new Error("不支持的文件类型，只支持jpg，png");
		}
		
		private function analyse():void
		{
			analizeType();
			
			if (type == "png")
				analizePNG();
			else if (type == "jpg")
				analizeJPG();
			else
				throw new Error("不支持的文件类型，只支持jpg，png");
			
			process();
		}
		
		private function analizeType():void 
		{
			var b0:int = tempo.readUnsignedByte();
			var b1:int = tempo.readUnsignedByte();
			if (b0 == 66 && b1 == 77) 
				__type = "bmp";
			else if (b0 == 255 && b1 == 216) 
				__type = "jpg";
			else if (b0 == 137 && b1 == 80) 
				__type = "png";
			else if (b0 == 71 && b1 == 73) 
				__type = "gif";
			tempo.position = 0;
		}
		
		private function analizePNG():void
		{
			for (var i:uint = 0; i<PNG_SIG.length; i++) 
			{
				if (tempo.readUnsignedByte() != PNG_SIG[i]) 
					throw new Error("PNG图片文件错误.");
			}
			tempo.readUnsignedInt();
			tempo.readUTFBytes(4);
			__originalWidth  = tempo.readUnsignedInt();
			__originalHeight = tempo.readUnsignedInt();
		}
		
		private function analizeJPG():void
		{
			var index:uint = 0;
			var byte:int = 0;
			var jump:int = 0;
			var fl:int = JPG_SOF.length - 1;
			var bl:int = tempo.bytesAvailable;
			while (true)
			{
				var match:Boolean = false;
				// Only look for new APP table if no jump is in queue
				if (jump == 0) 
				{
					byte = tempo.readUnsignedByte();
					// Check for APP table
					for each (var soi:Array in JPG_SOI) 
					{
						if (byte == soi[index]) 
						{
							match = true;
							if (index  >= 1) 
							{
								// APP table found, skip it as it may contain thumbnails in JPG (we don't want their SOF's)
								// -2 for the short we just read
								jump = tempo.readUnsignedShort() - 2;
								break;
							}
						}
					}
				}
				// Jump here, so that data has always loaded
				if (jump > 0) 
				{
					if (bl >= jump)
					{
						tempo.position += jump;
						match = false;
						jump = 0;
						index = 0;
					}
					else 
					{
						break;
					}
				} 
				else 
				{
					// Check for SOF
					if (byte == JPG_SOF[index]) 
					{
						match = true;
						if (index >= fl) 
						{
							// Matched SOF0
							__originalHeight = tempo.readUnsignedShort();
							__originalWidth  = tempo.readUnsignedShort();
							break;
						}
					}
					index = (match) ? index + 1 : 0;
				}
			}//end of while
		}
		
		private function process():void
		{
			var size:Number = originalWidth * originalHeight;
			if (size > MAX_SUPPORTED_SIZE || originalWidth > MAX_SUPPORTED_WIDTH || originalHeight > MAX_SUPPORTED_WIDTH)
			{
				throw new Error("图片像素尺寸 " + originalWidth + " * " + originalHeight + " 超过了支持的最大尺寸，支持的尺寸宽*高在16777216以下，且宽度和高度高度都必须在8000以下！");;
			}
			else
			{
				var scale:Number = (size > limit) ? Math.pow((limit * limit) / (size * size), .5) : 1;
				__width  = scale * originalWidth;
				__height = scale * originalHeight;
				
				if (scale == 1)
				{
					__bytes = tempo;
					__bytes.position = 0;
				}
				
				transform();
			}
		}
		
		private function transform():void
		{
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, defaultHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, defaultHandler);
			loader.loadBytes(tempo);
		}
		
		private function defaultHandler(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, defaultHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, defaultHandler);
			if (e.type == Event.COMPLETE)
			{
				var bmd:BitmapData = Bitmap(loader.content).bitmapData;
				if (width == originalWidth && height == originalHeight)
				{
					__bitmapData = bmd;
				}
				else
				{
					__bitmapData = new BitmapData(width, height, true, 0);
					var matrix:Matrix = new Matrix;
					matrix.scale(width / originalWidth, height / originalHeight);
					__bitmapData.draw(bmd, matrix, null, null, null, true);
					encodeBmd();
				}
				bytes.position = 0;
			}
			
			dispatchEvent(e);
		}
		
		private function encodeBmd():void
		{
			if (type == "jpg")
				__bytes = bitmapData.encode(bitmapData.rect, new JPEGEncoderOptions(quality));
			else if (type == "png")
				__bytes = bitmapData.encode(bitmapData.rect, new PNGEncoderOptions);
		}
		
		
		/**
		 * 图片原始宽度
		 */
		public function get originalWidth():Number
		{
			return  __originalWidth;
		}
		private var __originalWidth:Number;
		
		/**
		 * 图片原始高度
		 */
		public function get originalHeight():Number
		{
			return  __originalHeight;
		}
		private var __originalHeight:Number;
		
		/**
		 * 图片宽度
		 */
		public function get width():Number
		{
			return  __width;
		}
		private var __width:Number;
		
		/**
		 * 图片高度
		 */
		public function get height():Number
		{
			return  __height;
		}
		private var __height:Number;
		
		/**
		 * 文件类型，jpg、png。
		 */
		public function get type():String
		{
			return  __type;
		}
		private var __type:String;
		
		/**
		 * 位图数据
		 */
		public function get bitmapData():BitmapData
		{
			return  __bitmapData;
		}
		private var __bitmapData:BitmapData;
		
		/**
		 * 字节流数据
		 */
		public function get bytes():ByteArray
		{
			return  __bytes;
		}
		private var __bytes:ByteArray;
		
		private var limit:Number;
		
		private var quality:Number;
		
		private var loader:Loader;
		
		private var tempo:ByteArray;
		
		/**
		 * 支持的最大图片尺寸，宽与高的乘积，目前最大支持4096*4096 。
		 */
		public  static const MAX_SUPPORTED_SIZE  :Number = 16777216;
		
		public  static const MAX_SUPPORTED_WIDTH :Number = 8000;
		
		public  static const MAX_SUPPORTED_HEIGHT:Number = 8000;
		
		private static const PNG_SIG:Array = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
		
		private static const JPG_SOI:Array = [
			[0xFF, 0xE0], [0xFF, 0xE1], [0xFF, 0xE2], [0xFF, 0xE3], 
			[0xFF, 0xE4], [0xFF, 0xE5], [0xFF, 0xE6], [0xFF, 0xE7], 
			[0xFF, 0xE8], [0xFF, 0xE9], [0xFF, 0xEA], [0xFF, 0xEB], 
			[0xFF, 0xEC], [0xFF, 0xED], [0xFF, 0xEE], [0xFF, 0xEF]
		];
		private static const JPG_SOF:Array = [0xFF, 0xC0 , 0x00 , 0x11 , 0x08];
	}
}