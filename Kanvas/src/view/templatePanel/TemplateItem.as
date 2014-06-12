package view.templatePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.layout.IBoxItem;
	
	
	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public final class TemplateItem extends IconBtn implements IBoxItem
	{
		public function TemplateItem()
		{
			super();
			doubleClickEnabled = true;
		}
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			mouseEnabled = true;
		}
		
		override protected function init():void
		{
			w = 210;
			h = 160;
			
			iconW = 200;
			iconH = 150;
			
			styleXML = iconStyleXML;
			
			super.init();
		}
		
		override public function render():void
		{
			super.render();
			
			var tx:Number = (currState.width  - iconW) / 2;
			var ty:Number = (currState.height - iconH) / 2;
			
			graphics.lineStyle(1, 0xCCCCCC);
			graphics.drawRect(tx, ty, iconW, iconH);
			graphics.endFill();
		}
		
		public var id:uint;
		
		public var data:XML;
		
		private const iconStyleXML:XML = 
			<states>
				<normal>
					<fill color='#FFFFFF' alpha='0'/>
					<img/>
				</normal>
				<hover>
					<fill color='#999999' alpha='0.8'/>
					<img/>
				</hover>
				<down>
					<fill color='#539fd8, #3c92e0' alpha='0.8, 0.8' angle='90'/>
					<img/>
				</down>
			</states>;
	}
}