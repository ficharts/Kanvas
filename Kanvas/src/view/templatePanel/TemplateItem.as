package view.templatePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.layout.IBoxItem;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	
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
			
			graphics.lineStyle(1, 0xDDDDDD);
			graphics.drawRect(tx, ty, iconW, iconH);
			graphics.endFill();
		}
		
		public function get icon():String
		{
			return __icon;
		}
		
		public function set icon(value:String):void
		{
			if (__icon != value)
			{
				__icon = value;
				if (RexUtil.ifHasText(icon))
				{
					if(!loader) 
					{
						loader = new ImgInsertor;
						loader.addEventListener(ImgInsertEvent.IMG_LOADED, loadImgComplete);
						loader.addEventListener(ImgInsertEvent.IMG_LOADED_ERROR, loadImgError);
					}
					loader.loadImg(icon);
				}
			}
		}
		
		private function loadImgComplete(e:ImgInsertEvent):void
		{
			
		}
		private function loadImgError(e:ImgInsertEvent):void
		{
			
		}
		
		private var __icon:String;
		
		public var id:uint;
		
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
					<fill color='#539fd8' alpha='0.8' angle='90'/>
					<img/>
				</down>
			</states>;
		
		private var loader:ImgInsertor;
	}
}