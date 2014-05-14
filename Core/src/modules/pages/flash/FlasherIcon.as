package modules.pages.flash
{
	import com.kvs.ui.label.LabelUI;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 */	
	public class FlasherIcon extends Sprite
	{
		public function FlasherIcon()
		{
			super();
			
			icon = new Bitmap(new flash_b);
			icon.width = icon.height = 32;
			icon.smoothing = true;
			//addChild(icon);
			
			label.styleXML = <label radius='0' vPadding='5' hPadding='5'>
									<format color='#ffffff' font='微软雅黑' size='10'/>
								  </label>
			addChild(label);
		}
		
		/**
		 */		
		private var icon:Bitmap;
		
		/**
		 */		
		public function render(index:String):void
		{
			label.text = index;
			label.render();
			
			label.x = (20 - label.width) / 2;
			label.y = (20 - label.height) / 2;
			
			this.graphics.clear();
			this.graphics.beginFill(0x1b7ed1);
			this.graphics.drawCircle(10, 10, 10);
			this.graphics.endFill();
		}
		
		/**
		 */		
		private var label:LabelUI = new LabelUI;
	}
}