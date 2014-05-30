package view.templatePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.layout.IBoxItem;
	
	public final class TemplateItem extends IconBtn implements IBoxItem
	{
		public function TemplateItem()
		{
			super();
		}
		
		override protected function init():void
		{
			w = 90;
			h = 70;
			iconW = 80;
			iconH = 60;
			
			styleXML = iconStyleXML;
			
			super.init();
		}
		
		override public function render():void
		{
			super.render();
			
			var tx:Number = (currState.width  - iconW) / 2;
			var ty:Number = (currState.height - iconH) / 2;
			
			graphics.lineStyle(1, 0xEEEEEE);
			graphics.drawRect(tx, ty, iconW, iconH);
			graphics.endFill();
			
			
		}
		
		public var icon:String = "";
		
		public var data:XML;
		
		private var label:LabelUI;
		
		
		private const iconStyleXML:XML = 
			<states>
				<normal>
					<fill color='#FFFFFF' alpha='0'/>
					<img/>
				</normal>
				<hover>
					<fill color='#DDDDDD' alpha='0.8'/>
					<img/>
				</hover>
				<down>
					<fill color='#539fd8, #3c92e0' alpha='0.8, 0.8' angle='90'/>
					<img/>
				</down>
			</states>;
	}
}