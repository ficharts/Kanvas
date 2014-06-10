package landray.kp.maps.main.elements
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import model.vo.ElementVO;
	
	/**
	 * 
	 */	
	public final class Image extends ImageBase
	{
		public function Image($vo:ElementVO)
		{
			super($vo);
			
			_canvas.addChild(shape);
			addChild(_canvas);
		}
		
		/**
		 */		
		override public function get canvas():DisplayObject
		{
			return _canvas;
		}
		
		/**
		 */		
		private var _canvas:Sprite = new Sprite;
		
		/**
		 */		
		override public function showIMG():void
		{
			if (bmpLarge && bmpSmall)
			{
				var tmpDispl:Bitmap = (stageWidth <= minSize || stageHeight <= minSize) ? bmpSmall : bmpLarge;
				if (tmpDispl != bmpDispl)
				{
					if (bmpDispl) bmpDispl.visible = false;
					bmpDispl = tmpDispl;
					bmpDispl.visible = true;
				}
				
				if (bmpDispl.smoothing!= smooth)
					bmpDispl.smoothing = smooth;
			}
		}
		
		/**
		 */		
		override protected function initIMG(data:Object):void
		{
			if (data)
			{
				bmdLarge = data as BitmapData;
				bmpLarge = new Bitmap(bmdLarge);
				bmpLarge.visible = false;
				bmpLarge.width  =  vo.width;
				bmpLarge.height =  vo.height;
				bmpLarge.x = -.5 * vo.width;
				bmpLarge.y = -.5 * vo.height;
				bmpLarge.smoothing = true;
				_canvas.addChild(bmpLarge);
				if(!bmdSmall)
				{
					var ow:Number = bmdLarge.width;
					var oh:Number = bmdLarge.height;
					if (ow > minSize && oh > minSize)
					{
						var ss:Number = (ow > oh) ? minSize / oh : minSize / ow;
						bmdSmall = new BitmapData(ow * ss, oh * ss, true, 0);
						var matrix:Matrix = new Matrix;
						matrix.scale(ss, ss);
						bmdSmall.draw(bmdLarge, matrix, null, null, null, true);
					}
					else
					{
						bmdSmall = bmdLarge;
					}
					
					bmpSmall = new Bitmap(bmdSmall);
					bmpSmall.visible = false;
					bmpSmall.width  =  vo.width;
					bmpSmall.height =  vo.height;
					bmpSmall.x = -.5 * vo.width;
					bmpSmall.y = -.5 * vo.height;
					bmpSmall.smoothing = true;
					_canvas.addChild(bmpSmall);
				}
			}
		}
		
		
		/**
		 * 
		 */		
		public function get smooth():Boolean
		{
			return __smooth;
		}
		
		public function set smooth(value:Boolean):void
		{
			if (__smooth!= value)
			{
				__smooth = value;
				if (bmpSmall && bmpLarge)
				{
					if (smooth)
					{
						bmpSmall.visible = (stageWidth < minSize || stageHeight < minSize);
						bmpLarge.visible = !bmpSmall.visible;
					}
					else
					{
						bmpLarge.visible = false;
						bmpSmall.visible = true;
					}
				}
			}
		}
		
		/**
		 */		
		private var __smooth:Boolean = true;
		
		/**
		 * 
		 */		
		private var lastWidth :Number;
		private var lastHeight:Number;
		private var minSize   :Number = 400;
		
		private var bmdLarge:BitmapData;
		private var bmdSmall:BitmapData;
		private var bmpLarge:Bitmap;
		private var bmpSmall:Bitmap;
		private var bmpDispl:Bitmap;
		
	}
}