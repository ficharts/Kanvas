package view.ui
{
	import com.greensock.TweenLite;
	
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * 
	 * 负责背景颜色切换时动画效果的绘制
	 * 
	 */	
	public class BgColorFlasher
	{
		public function BgColorFlasher(core:CoreApp)
		{
			this.core = core;
			
			matr = new Matrix;
		}
		
		/**
		 * 
		 */		
		private var core:CoreApp;
		
		/**
		 */		
		public function render(color:uint):void
		{
			colors[0] = color;
			colors[1] = oldColor;
			
			oldColor = color;
				
			ratio = 0;
			alpha = 0;
			
			TweenLite.killTweensOf(this, false);
			TweenLite.to(this, 0.6, {ratio: 255, alpha: 1, onUpdate: flashBgColor});
		}
		
		/**
		 */		
		private function flashBgColor():void
		{
			ratios[0] = ratio;
			ratios[1] = ratio;
			alphas[0] = alpha;
			
			bgColorCanvas.graphics.clear();
			matr.createGradientBox(core.stage.stageWidth, core.stage.stageHeight, angle, 0, 0);
			bgColorCanvas.graphics.beginGradientFill('linear', colors, alphas, ratios, matr, 
				SpreadMethod.PAD, InterpolationMethod.RGB, 0); 
			
			bgColorCanvas.graphics.drawRect(0, 0, core.stage.stageWidth, core.stage.stageHeight);
			bgColorCanvas.graphics.endFill();
		}
		
		private var colors:Array = [];
		private var alphas:Array = [1, 1];
		private var ratios:Array = [0, 255];
		
		/**
		 */		
		public var ratio:uint = 0;
		
		/**
		 */		
		public var alpha:Number = 0;
		
		/**
		 */		
		private var matr:Matrix;
		
		private var angle:Number = Math.PI / 2;
		
		/**
		 */		
		private function get bgColorCanvas():Sprite
		{
			return core.bgColorCanvas;
		}
		
		public var oldColor:uint = 0xffffff;

	}
}