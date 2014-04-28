package view.pagePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.elements.Img;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.CoreFacade;
	
	/**
	 */	
	public class ShotBtn extends IconBtn implements IClickMove
	{
		public function ShotBtn(pagesPanel:PagePanel)
		{
			super();
			
			this.pagePanel = pagesPanel;
			this.dragMoveControl = new ClickMoveControl(this, this);
		}
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
			pagePanel.addPage();
		}
		
		/**
		 */		
		public function startMove():void
		{
			pagePanel.startCreatePageByDrag();
		}
		
		/**
		 */			
		public function stopMove():void
		{
			pagePanel.endCreatePageByDrag();
		}
		
		/**
		 */		
		private var dragMoveControl:ClickMoveControl;
		
		/**
		 */		
		private var pagePanel:PagePanel;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
		}
		
		/**
		 */		
		override public function render():void
		{
			if (w != 0)
				currState.width = w;
			
			if (h != 0)
				currState.height = h;
			
			var img:Img = currState.getImg;
			img.ready();
			
			if (isNaN(iconW))
				iconW = img.width;
			
			if (isNaN(iconH))
				iconH = img.height;
			
			graphics.clear();
			StyleManager.drawRect(this, this.currState, this);
			
			
			BitmapUtil.drawBitmapDataToSprite(img.data, this, iconW, iconH, (currState.width - iconW) / 2, (currState.height - iconH) / 2, true);
			graphics.endFill();
		}
		
	}
}