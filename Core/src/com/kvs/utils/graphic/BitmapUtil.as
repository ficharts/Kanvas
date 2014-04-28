package com.kvs.utils.graphic
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 截取显示对象
	 */	
	public class BitmapUtil
	{
		public function BitmapUtil()
		{
			
		}
		
		/**
		 * 将bytes转换为bmd
		 */		
		public static function decodeByteArray(bytes:ByteArray):BitmapData
		{  
			
			bytes.uncompress();  
			
			bytes.position = bytes.length - 1;  
			var transparent:Boolean = bytes.readBoolean();  
			
			bytes.position = bytes.length - 3;  
			var height:int = bytes.readShort();  
			
			bytes.position = bytes.length - 5;  
			var width:int = bytes.readShort();  
			
			bytes.position = 0;  
			var datas:ByteArray = new ByteArray();            
			bytes.readBytes(datas,0,bytes.length - 5);  
			var bmp:BitmapData = new BitmapData(width, height, transparent, 0);  
			bmp.setPixels(new Rectangle(0, 0, width, height), datas);  
			
			return bmp;  
		}  
		
		/**
		 * 将bmd转换为bytes
		 */		
		public static function encodeByteArray(bmd:BitmapData):ByteArray
		{
			var bytes:ByteArray = bmd.getPixels(bmd.rect);  
			
			bytes.writeShort(bmd.width);  
			bytes.writeShort(bmd.height);  
			bytes.writeBoolean(bmd.transparent);  
			bytes.compress();  
			
			return bytes;  
		}
		
		/**
		 * 将位图绘制到显示对象的指定区域内, 拟定宽高和位置
		 */		
		public static function drawBitmapDataToSprite(bmd:BitmapData, ui:Sprite, w:Number, h:Number, tx:Number = 0, ty:Number = 0, smooth:Boolean = false, radius:uint = 0):void
		{
			drawBitmapDataToGraphics(bmd, ui.graphics, w, h, tx, ty, smooth, radius);
		}
		
		/**
		 * 将位图绘制到显示对象的指定区域内, 拟定宽高和位置
		 * 
		 * smooth 为 true 时很消耗性能
		 */		
		public static function drawBitmapDataToShape(bmd:BitmapData, ui:Shape, w:Number, h:Number, tx:Number = 0, ty:Number = 0, smooth:Boolean = false, radius:uint = 0):void
		{
			drawBitmapDataToGraphics(bmd, ui.graphics, w, h, tx, ty, smooth, radius);
		}
		
		/**
		 */		
		public static function drawBitmapDataToGraphics(bmd:BitmapData, ui:Graphics, w:Number, h:Number, tx:Number = 0, ty:Number = 0, smooth:Boolean = false, radius:uint = 0):void
		{
			if (bmd)
			{
				var mat:Matrix = new Matrix;
				mat.createBox(w / bmd.width, h / bmd.height, 0, tx, ty);
				ui.beginBitmapFill(bmd, mat, false, smooth);
				ui.drawRoundRect(tx, ty, w, h, radius, radius);
			}
		}
		
		/**
		 * 获取显示对象的截图，并转换为位图
		 */		
		public static function getBitmap(target:DisplayObject, ifSmooth:Boolean = false, scale:Number = 1):Bitmap
		{
			var bmp:Bitmap = new Bitmap(getBitmapData(target, ifSmooth, scale), PixelSnapping.NEVER, false);
			
			return bmp;
		}
		
		/**
		 * 抓取显示对象的位图数据；
		 */		
		public static function getBitmapData(target:DisplayObject, ifSmooth:Boolean = false, scale:Number = 1):BitmapData
		{
			var rect:Rectangle = target.getBounds(target);
			var ow:Number = Math.max(1, target.width  * scale);
			var oh:Number = Math.max(1, target.height * scale);
			var nw:Number = ow;
			var nh:Number = oh;
			var p:Number = ow * oh;
			var s:Number = 1;
			if (p > maxBitmapSize)
			{
				s = maxBitmapSize / p;
				ow *= s;
				oh *= s;
				scale *= s;
			}
			
			var myBitmapData:BitmapData = new BitmapData(ow, oh, true, 0xFFFFFF);
			var mat:Matrix = new Matrix;
			mat.createBox(scale, scale, 0, - rect.left, - rect.top);
			myBitmapData.draw(target, mat, null, null, null, ifSmooth);
			
			
			
			return myBitmapData;
		}
		
		/**
		 * 抓取显示对象上的指定范围内位图数据,
		 */		
		public static function drawWithSize(target:DisplayObject, width:Number, height:Number, transparent:Boolean = true, color:uint = 0xFFFFFF, mar:Matrix = null, smooth:Boolean = false):BitmapData
		{
			var myBitmapData:BitmapData = new BitmapData(width, height, transparent, color);
			myBitmapData.draw(target, mar, null, null, null, smooth);
			return myBitmapData;
		}
		
		public static function get maxBitmapSize():int
		{
			/*if (_maxBitmapSize == 0)
			{
				var f:int = 1;
				try
				{
					while (true)
					{
						
						var bmd:BitmapData = new BitmapData(f, f, true, 0xFFFFFF);
					}
				}
				catch (e:Error)
				{
					f /= 4;
					_maxBitmapSize = f * f;
				}
			}*/
			return _maxBitmapSize;
		}
		private static var _maxBitmapSize:int = 16777216;
		
		private static const maxSizePow:uint = 281474976710656;
	}
}