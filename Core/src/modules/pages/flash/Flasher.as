package modules.pages.flash
{
	import com.greensock.TweenLite;
	
	import view.element.ElementBase;

	/**
	 *
	 * 动画
	 *  
	 * @author wanglei
	 * 
	 */	
	public class Flasher
	{
		/**
		 * 动画播放的时间 
		 */		
		public static const TIME:Number = 0.5;
		
		/**
		 */		
		public function Flasher()
		{
		}
		
		/**
		 * 在同一个页面中，动画的相对顺序 
		 */		
		public var index:uint = 0;
		
		/**
		 */		
		public function clone():Flasher
		{
			return this;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function expertData():XML
		{
			var result:XML = <flash/>;
			
			
			
			return result;
		}
		
		/**
		 * 动画初始化, 预览时调用
		 */		
		public function start():void
		{
			element.canvas.alpha = 0;
		}
		
		/**
		 * 预览结束时调用
		 */		
		public function end():void
		{
			element.canvas.alpha = 1;
		}
		
		/**
		 * 动画播放
		 */		
		public function next():void
		{
			TweenLite.to(element.canvas, TIME, {alpha: 1});
		}
		
		/**
		 * 动画回退
		 */		
		public function prev():void
		{
			TweenLite.to(element.canvas, TIME, {alpha: 0});
		}
		
		/**
		 * 动画播放的对象 
		 */		
		public var element:ElementBase;
		
		/**
		 */		
		public var elementID:uint;
		
	}
}