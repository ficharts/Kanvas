package util.img
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import view.element.imgElement.ImgElement;
	import view.element.imgElement.ImgElementBase;

	/**
	 * 用于延迟渲染图片元素，同时渲染大量图片会造成客户端卡顿
	 */	
	public class ImageManager
	{
		public function ImageManager()
		{
		}
		
		/**
		 */		
		private static var timer:Timer = new Timer(50);
		
		/**
		 */		
		public static function pushForRender(img:ImgElementBase):void
		{
			if (CoreApp.isAIR)
			{
				images.push(img);
				
				if (timer.running == false)
				{
					timer.addEventListener(TimerEvent.TIMER, timmerHandler);
					timer.start();
				}
			}
			else
			{
				img.removeLoading();
				img.toNomalState();
			}
		}
		
		/**
		 */		
		private static function timmerHandler(evt:Event):void
		{
			if (images.length)
			{
				var image:ImgElementBase = images.shift();
				image.removeLoading();
				image.toNomalState();
			}
			else
			{
				timer.stop();
			}
		}
		
		/**
		 */		
		private static var images:Vector.<ImgElementBase> = new Vector.<ImgElementBase>;
	}
}