package view.templatePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	import com.kvs.utils.layout.IBoxItem;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	
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
			
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.drawRect(tx, ty, iconW, iconH);
			graphics.endFill();
			
			this.filters = [new GlowFilter(0x000000, .1, 8, 8, 2, 3)];	
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
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED, loadImgComplete);
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, loadImgError);
			var bmd:BitmapData = BitmapData(e.viewData);
			if (bmd)
			{
				if(!shape)
				{
					addChild(shape = new Shape);
					shape.x = shape.y = 5;
				}
				BitmapUtil.drawBitmapDataToShape(bmd, shape, iconW, iconH, 0, 0, true);
			}
		}
		
		private function loadImgError(e:ImgInsertEvent):void
		{
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED, loadImgComplete);
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, loadImgError);
			if (shape)
				shape.graphics.clear();
		}
		
		private var __icon:String;
		
		public var id:uint;
		
		public var path:String;
		
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
		
		private var shape:Shape;
	}
}