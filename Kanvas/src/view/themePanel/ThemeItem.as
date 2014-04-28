package view.themePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.layout.IBoxItem;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class ThemeItem extends IconBtn implements IBoxItem
	{
		public function ThemeItem()
		{
			super();
		}
		
		override public function render():void
		{
			super.render();
			
			var tx:Number = (currState.width - iconW) / 2;
			var ty:Number = (currState.height - iconH) / 2;
			
			this.graphics.lineStyle(1, 0xEEEEEE);
			this.graphics.drawRect(tx, ty, iconW, iconH);
			this.graphics.endFill();
		}
		
		/**
		 */		
		public var themeID:String = '';
		
		/**
		 */		
		public var icon:String = '';

	}
}