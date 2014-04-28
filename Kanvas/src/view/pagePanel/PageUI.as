package view.pagePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.ui.label.LabelUI;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import modules.pages.PageEvent;
	import modules.pages.PageUtil;
	
	import view.ui.MainUIBase;
	
	/**
	 */	
	public class PageUI extends IconBtn implements IClickMove
	{
		public function PageUI(vo:PageVO, $mainUI:MainUIBase)
		{
			super();
			
			pageVO = vo;
			mainUI = $mainUI;
			
			addChild(con);
			con.addChild(label);
			con.addChild(imgShape);
			
			con.addEventListener(MouseEvent.MOUSE_DOWN, downPage);
			
			deleteBtn = new IconBtn;
			deleteBtn.tips = '删除页面';
			deleteBtn.iconW = deleteBtn.iconH = 16;
			deleteBtn.setIcons('del_up', 'del_over', 'del_down');
			deleteBtn.visible = false;
			addChild(deleteBtn);
			
			deleteBtn.addEventListener(MouseEvent.CLICK, delHander);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			dragMoveControl = new ClickMoveControl(this, con);
			
			pageVO.addEventListener(PageEvent.PAGE_SELECTED, pageSelected);
			pageVO.addEventListener(PageEvent.UPDATE_THUMB, updateThumb);
		}
		
		/**
		 */		
		private var dragMoveControl:ClickMoveControl;
		
		/**
		 * 
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.PAGE_DRAGGING));
		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.PAGE_CLICKED, this));
		}
		
		/**
		 * 鼠标按下，切换页面，但不切换镜头
		 */		
		private function downPage(evt:MouseEvent):void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.PAGE_DOWN, this));
		}
		
		/**
		 */		
		public function startMove():void
		{
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.START_DRAG_PAGE, this));
		}
		
		/**
		 */		
		public function hoverUI():void
		{
			this.mouseChildren = this.mouseEnabled = false;
			
			this.graphics.clear();
			drawPageThumb();
			
			this.label.visible = false;
		}
			
		/**
		 */			
		public function stopMove():void
		{
			label.visible = true;
			this.statesControl.toDown();
			
			this.dispatchEvent(new PagePanelEvent(PagePanelEvent.END_DRAG_PAGE));
			this.mouseEnabled = this.mouseChildren = true;
		}
		
		/**
		 */		
		private function updateThumb(evt:PageEvent = null):void
		{
			pageVO.bitmapData = CoreFacade.coreMediator.pageManager.getThumbByPageVO(pageVO, 480, 360, mainUI, CoreFacade.coreProxy.bgColor, true);
			
			if (bmp && con.contains(bmp)) con.removeChild(bmp);
			
			con.addChild(bmp = new Bitmap(pageVO.bitmapData));
			bmp.x = leftGutter;
			bmp.y = (currState.height - iconH) / 2;
			bmp.width = iconW;
			bmp.height = iconH;
			bmp.smoothing = true;
		}
		
		/**
		 */		
		private function pageSelected(evt:PageEvent):void
		{
			this.dispatchEvent(evt);
		}
		
		/**
		 */		
		private function delHander(evt:MouseEvent):void
		{
			pageVO.dispatchEvent(new PageEvent(PageEvent.DELETE_PAGE_FROM_UI, pageVO));
		}
		
		/**
		 */		
		private function rollOver(et:MouseEvent):void
		{
			deleteBtn.visible = true;
		}
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			deleteBtn.visible = false;
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			drawPageThumb();
			
			if (pageVO.bitmapData)
			{
				if (bmp && con.contains(bmp)) con.removeChild(bmp);
				con.addChild(bmp = new Bitmap(pageVO.bitmapData));
				bmp.x = leftGutter;
				bmp.y = (currState.height - iconH) / 2;
				bmp.width = iconW;
				bmp.height = iconH;
				bmp.smoothing = true;
			}
			else
			{
				if (pageVO.thumbUpdatable)
				{
					updateThumb();
				}
			}
			
			deleteBtn.x = leftGutter + iconW;
			deleteBtn.y = currState.height / 2;
		}
		
		/**
		 * 绘制页面截图
		 */		
		private function drawPageThumb():void
		{
			var off:uint = 0;
			var ty:Number = (currState.height - iconH) / 2 - off;
			
			imgShape.graphics.clear();
			imgShape.graphics.beginFill(0xeeeeee);
			imgShape.graphics.drawRect(leftGutter - off, ty, iconW + off * 2, iconH + off * 2);
			imgShape.graphics.endFill();
		}
		
		/**
		 * 左侧防止文字的间距 
		 */		
		private var leftGutter:uint = 25;
		
		/**
		 */		
		private var label:LabelUI = new LabelUI;
		
		/**
		 * 用于绘制页面缩略图 
		 */		
		private var imgShape:Shape = new Shape;
		
		/**
		 * 更新序号显示
		 */		
		public function updataLabel():void
		{
			label.text = (pageVO.index + 1).toString();
			
			updateLabelWidthStyle();
			
			label.x = (leftGutter - label.width) / 2;
            label.y = (h - label.height) / 2;
		}
		
		/**
		 */		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			this.mouseEnabled = true;
			updateLabelWidthStyle();
		}
		
		/**
		 */		
		private function updateLabelWidthStyle():void
		{
			if(selected)
				label.styleXML = selectedTextStyle;
			else
				label.styleXML = normalTextStyle;
			
			label.render();
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.mouseChildren = true;
			this.buttonMode = false;
		}
		
		/**
		 */		
		private var normalTextStyle:XML = <label radius='0' vPadding='0' hPadding='0'>
											<format color='#555555' font='华文细黑' size='12'/>
										  </label>
			
		/**
		 */		
		private var selectedTextStyle:XML = <label radius='0' vPadding='0' hPadding='0'>
											<format color='#ffffff' font='华文细黑' size='12'/>
										  </label>
		
		/**
		 * 用来响应点击，触发页面选择的容器对象；
		 * 
		 * 这么做的目的是为了防止点击删除按钮也触发clicked方法 
		 */			
		private var con:Sprite = new Sprite;
			
		/**
		 */		
		public var pageVO:PageVO;
		
		/**
		 */		
		private var deleteBtn:IconBtn;
		
		public var mainUI:MainUIBase;
		
		private var bmp:Bitmap;
	}
}