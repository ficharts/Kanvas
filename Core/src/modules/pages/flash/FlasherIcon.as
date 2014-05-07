package modules.pages.flash
{
	import com.kvs.ui.label.LabelUI;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class FlasherIcon extends Sprite
	{
		public function FlasherIcon()
		{
			super();
			
			addChild(label);
		}
		
		/**
		 */		
		public function render(index:String):void
		{
			label.text = index;
			label.render();
			
			label.x = - label.width / 2;
			label.y = - label.height / 2;
		}
		
		/**
		 */		
		private var label:LabelUI = new LabelUI;
	}
}