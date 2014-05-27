package 
{
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
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
			
			//有色的logo
			var lo:BitmapData = new logo;
			var x:Number = (stage.stageWidth - lo.width / 3) / 2;
			var y:Number = (stage.stageHeight - lo.height / 2) / 2;
			BitmapUtil.drawBitmapDataToShape(lo, logoShape, lo.width / 3, lo.height / 3, x, y, true);
			
			//灰色logo
			lo = new logo_gray;
			BitmapUtil.drawBitmapDataToShape(lo, grayLogo, lo.width / 3, lo.height / 3, x, y, true);
			
			
			//遮罩
			logoMask.x = x;
			logoMask.y = y;
			
			logoMask.graphics.clear();
			logoMask.graphics.beginFill(0, 0);
			logoMask.graphics.drawRect(0, 0, logoShape.width, logoShape.height);
			logoMask.graphics.endFill();
			
			logoShape.mask = logoMask;
			
			this.addChild(grayLogo);
			this.addChild(logoShape);
			this.addChild(logoMask);
			
			
			//加载核心程序
			laoder = new Loader();
			laoder.contentLoaderInfo.addEventListener(Event.COMPLETE, kanvasLoaded);
			laoder.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loading);
			laoder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErroHander);
			
			var context:LoaderContext = new LoaderContext();
			laoder.load(new URLRequest('KanvasWeb.swf'));
			
			 label =new TextField
			 label.text = "";
			//addChild(label);
		}
		
		/**
		 */		
		private var label:TextField
		
		/**
		 */		
		private function loading(evt:ProgressEvent):void
		{
			var perc:Number = evt.bytesLoaded /this.stage.loaderInfo.bytesTotal;
			logoMask.scaleX = perc;
			
			label.text = label.text +  evt.bytesLoaded + ',' + evt.bytesTotal + "," + perc.toString() + "\n";
		}
		
		/**
		 */		
		private var logoShape:Shape = new Shape;
		
		/**
		 */		
		private var grayLogo:Shape = new Shape;
		
		/**
		 */		
		private var logoMask:Shape = new Shape;
		
		/**
		 */		
		private function kanvasLoaded(evt:Event):void
		{
			this.removeChild(grayLogo);
			logoShape.mask = null;
			
			this.removeChild(logoMask);
			this.removeChild(logoShape);
			
			kanvas = laoder.content as Sprite;
			laoder.contentLoaderInfo.removeEventListener(Event.COMPLETE, kanvasLoaded);
			laoder.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loading);
			laoder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErroHander);
			laoder.unload();
			laoder = null;
			
			addChild(kanvas);
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