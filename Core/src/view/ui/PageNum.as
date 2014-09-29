package view.ui
{
	import com.kvs.ui.label.LabelUI;
	
	import flash.display.Sprite;
	
	/**
	 * 页面编号
	 */	
	public class PageNum extends Sprite
	{
		public function PageNum()
		{
			super();
			
			addChild(numLabel = new LabelUI);
			numLabel.styleXML = <label radius='0' vPadding='0' hPadding='0'>
									<format color='#FFFFFF' font='Arial' size='12'/>
								</label>;
		}
		
		/**
		 */		
		public function render(index:uint):void
		{
			graphics.clear();
			graphics.lineStyle(0.1, 0, 0.8);
			graphics.beginFill(0x666666, .8);
			
			graphics.drawCircle(radius, radius, radius);
			graphics.endFill();
			
			numLabel.text = (index + 1).toString();
			numLabel.render();
			numLabel.x = radius - numLabel.width  * .5;
			numLabel.y = radius - numLabel.height * .5;
		}
		
		/**
		 * radius
		 */		
		private var radius:uint = 20;
		
		/**
		 */		
		private var numLabel:LabelUI;
	}
}