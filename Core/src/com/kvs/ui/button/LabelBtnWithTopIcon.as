package com.kvs.ui.button
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.elements.Img;
	import com.kvs.utils.graphic.BitmapUtil;

	/**
	 * 正上方有icon，正下方有文字说明的按钮
	 */	
	public class LabelBtnWithTopIcon extends LabelBtn
	{
		public function LabelBtnWithTopIcon()
		{
			super();
		}
		
		/**
		 */		
		public function setIcon(classPath:String):void
		{
			if (ifReady == false)
			{
				this.ready();
				ifReady = true;
			}
			
			states.getNormal.getImg.classPath = classPath;
			states.getHover.getImg.classPath = classPath;
			states.getDown.getImg.classPath = classPath;
		}
		
		/**
		 */		
		override protected function _render():void
		{
			labelUI.text = text;
			labelUI.render();
			
			checkSize();
			
			this.graphics.clear();
			
			labelUI.y = currState.height - labelUI.height;
			labelUI.x = (currState.width - labelUI.width) / 2;
			
			StyleManager.drawRect(this, currState);
			
			this.graphics.beginFill(0, 0);
			this.graphics.lineStyle(0, 0, 0);
			this.graphics.endFill();
			
			var img:Img = currState.getImg;
			img.ready();
			
			if (isNaN(iconW))
				iconW = img.width;
			if (isNaN(iconH))
				iconH = img.height;
			
			var tx:Number = (currState.width - iconW) / 2;
			var ty:Number = (labelUI.y - iconH) / 2;
			BitmapUtil.drawBitmapDataToSprite(img.data, this, iconW, iconH, tx, ty, true);
			this.graphics.endFill();
			
		}
		
		/**
		 */		
		public var iconW:Number = NaN;
		public var iconH:Number = NaN;
		
	}
}