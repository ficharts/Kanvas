package
{
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * 负责加载主程序
	 */	
	public class KanvasLoader extends Sprite
	{
		public function KanvasLoader()
		{
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		private function init():void
		{
			this.addChild(logoShape);
			
			var lo:BitmapData = new logo;
			var x:Number = (stage.stageWidth - lo.width / 3) / 2;
			var y:Number = (stage.stageHeight - lo.height / 2) / 2;
		
			BitmapUtil.drawBitmapDataToShape(lo, logoShape, lo.width / 3, lo.height / 3, x, y, true);
			
			laoder = new Loader();
			laoder.contentLoaderInfo.addEventListener(Event.COMPLETE, kanvasLoaded);
			laoder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErroHander);
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			laoder.load(new URLRequest('./kanvas_kplayer/Kanvas.swf'), context);
		}
		
		/**
		 */		
		private var logoShape:Shape = new Shape;
		
		/**
		 */		
		private function kanvasLoaded(evt:Event):void
		{
			kanvas = laoder.content as Sprite;
			laoder.contentLoaderInfo.removeEventListener(Event.COMPLETE, kanvasLoaded);
			laoder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErroHander);
			laoder.unload();
			laoder = null;
			
			stage.addEventListener(Event.ENTER_FRAME, hideLogoHandler);
		}
		
		/**
		 */		
		private function hideLogoHandler(evt:Event):void
		{
			if (logoShape)
			{
				logoShape.alpha -= 0.2;
				
				if (logoShape.alpha <= 0)
				{
					logoShape.alpha = 0;
					
					this.removeChild(logoShape);
					logoShape = null;
					
					kanvas.y = - 50;
					addChild(kanvas);
				}
			}
			else
			{
				this.kanvas.y += 6;
				
				if (kanvas.y >= 0)
				{
					stage.removeEventListener(Event.ENTER_FRAME, hideLogoHandler);
					kanvas.y = 0;
				}
			}
		}
		
		/**
		 */		
		private function ioErroHander(e:IOErrorEvent):void
		{
			
		}
		
		/**
		 */		
		private var laoder:Loader;
		
		/**
		 */		
		private var kanvas:Sprite;
		
	}
}