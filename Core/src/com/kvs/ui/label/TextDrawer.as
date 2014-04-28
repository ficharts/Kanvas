package com.kvs.ui.label
{
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * 将文本转化为bitmap截图
	 */	
	public class TextDrawer
	{
		public function TextDrawer(host:Sprite)
		{
			this.host = host;
		}
		
		/**
		 */		
		private var host:Sprite;
		
		/**
		 * 检测截图是否满足要求
		 */		
		public function checkTextBm(shape:Graphics, textCanvas:Sprite, scale:Number = 1, smooth:Boolean = false, force:Boolean = false):void
		{
			scale = Math.abs(scale);
			checkVisible(shape, textCanvas, scale, smooth, force);
		}
		
		/**
		 * 将textCanvas上的文本转换为bitmapdata并绘制
		 */		
		public function renderTextBMD(shape:Graphics, textCanvas:Sprite, scale:Number = 1, smooth:Boolean = false):void
		{
			shape.clear();
			
			textBMD = BitmapUtil.getBitmapData(textCanvas, smooth, scale);
			
			BitmapUtil.drawBitmapDataToGraphics(textBMD, shape, textCanvas.width, textCanvas.height, 
				- textCanvas.width * .5,  - textCanvas.height * .5, smooth);
		}

		
		/**
		 * 检测字体原始字体是否可见，文字放大时用位图以提升性能；
		 * 
		 * 文字较小时用原始字体，提升可读性；
		 * 
		 * 文字太小时，隐藏文字；
		 */		
		public function checkVisible(shape:Graphics, textCanvas:Sprite, scale:Number = 1, smooth:Boolean = false, force:Boolean = false):void
		{
			if(!textBMD || force)
			{
				renderTextBMD(shape, textCanvas, scale, smooth);
			}
			else
			{
				var r:Number = textBMD.width / (scale * textCanvas.width);
				//截图有最大尺寸限制，最大宽高乘积为 imgMaxSize
				var max:Number = scale * textCanvas.width * scale * textCanvas.height;
				if (host.visible && max < imgMaxSize && (textBMD.width < textCanvas.width * scale * .4 || r > bmMaxScaleMultiple))
					renderTextBMD(shape, textCanvas, scale * .8, smooth);
			}
		}
		
		/**
		 * 截图时不会恰好截取满足要求的尺寸，而是要多放大一些，这样截图计算就会少一点
		 * 
		 * 借以提升性能； 
		 */		
		public var scaleMultiple:Number = 2;
		
		/**
		 * 最大截图宽高乘积 
		 */		
		public var imgMaxSize:uint = 1536 * 1536;
		
		/**
		 * 当截图尺大于实际需要尺寸倍数超过此值，需重新截图，防止显示异常问题 
		 */		
		public var bmMaxScaleMultiple:uint = 30;
		
		/**
		 */		
		public var textBMD:BitmapData;
	}
}