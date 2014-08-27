package view.toolBar
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import control.InteractEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import util.undoRedo.UndoRedoEvent;

	/**
	 *
	 * 工具条的默认状态
	 *  
	 * @author wanglei
	 * 
	 */	
	public class NormalState extends ToolBarStateBS
	{
		public function NormalState(toolbar:ToolBar)
		{
			super(toolbar);
		}
		
		/**
		 */		
		override public function toPageEdit():void
		{
			tb.currentState.ctner.visible = false;
			
			tb.currentState = tb.pageEditState;
			tb.currentState.ctner.visible = true;
		}
		
		/**
		 */		
		override public function toChartEdit():void
		{
			tb.currentState.ctner.visible = false;
			
			tb.currentState = tb.chartEditState;
			tb.currentState.ctner.visible = true;
			
			tb.main.pagePanel.visible = false;
		}
		
		/**
		 */		
		private function prevHandler(evt:MouseEvent):void
		{
			tb.dispatchEvent(new InteractEvent(InteractEvent.PREVIEW));
		}
		
		/**
		 */		
		private function addChartHander(evt:MouseEvent):void
		{
			tb.dispatchEvent(new InteractEvent(InteractEvent.OPEN_CHART_PANEL));
		}
		
		/**
		 */		
		private function addHandler(evt:MouseEvent):void
		{
			tb.dispatchEvent(new InteractEvent(InteractEvent.OPEN_SHAPE_PANEL));
		}
		
		/**
		 */		
		private function addImgHandler(evt:MouseEvent):void
		{
			tb.dispatchEvent(new InteractEvent(InteractEvent.INSERT_IMAGE));
		}
		
		/**
		 */		
		private function openThemeHandler(evt:MouseEvent):void
		{
			tb.dispatchEvent(new InteractEvent(InteractEvent.OPEN_THEME_PANEL));
		}
		
		/**
		 */		
		override public function addCustomButtons(btns:Vector.<IconBtn>):void
		{
			while (customButtonContainer.numChildren)
				customButtonContainer.removeChildAt(0);
			
			for (var i:int = 0;i < btns.length; i ++)
			{
				var btn:IconBtn = btns[i];	
				if (i == 0)
					btn.x = 0;
				else
					btn.x = customButtonContainer.width + customBtnGap;
				
				customButtonContainer.addChild(btn);
			}
			
			layoutCustomBtnC();
		}
		
		/**
		 */		
		internal function layoutCustomBtnC():void
		{
			customButtonContainer.x = tb.w - customButtonContainer.width - 10;
			customButtonContainer.y = (tb.h - customButtonContainer.height) / 2;
		}
		
		/**
		 */		
		override public function init():void
		{
			ctner.addChild(centerBtnsC);
			
			play_up;
			play_over;
			play_down;
			previewBtn.iconW = previewBtn.iconH = ToolBar.BTN_SIZE;
			previewBtn.w = previewBtn.h = ToolBar.BTN_SIZE;
			previewBtn.setIcons("play_up", "play_over", "play_down");
			previewBtn.tips = '预览';
			ctner.addChild(previewBtn);
			previewBtn.addEventListener(MouseEvent.CLICK, prevHandler, false, 0, true);
			
			undo_up;
			undo_over;
			undo_down;
			undoBtn.iconW = undoBtn.iconH = ToolBar.BTN_SIZE;
			undoBtn.w = undoBtn.h = ToolBar.BTN_SIZE;
			undoBtn.setIcons("undo_up", "undo_over", "undo_down");
			undoBtn.selected = true;
			undoBtn.tips = '撤销';
			ctner.addChild(undoBtn);
			
			
			redo_up;
			redo_over;
			redo_down;
			redoBtn.iconW = redoBtn.iconH = ToolBar.BTN_SIZE;
			redoBtn.w = redoBtn.h = ToolBar.BTN_SIZE;
			redoBtn.setIcons("redo_up", "redo_over", "redo_down");
			redoBtn.selected = true;
			redoBtn.tips = '重做';
			ctner.addChild(redoBtn);
			
			
			
			
			//--------------------------------------------------------------------------------------------
			
			var gap:uint = 12;
			
			chart_up;
			chart_over;
			chart_down;
			chartBtn.iconW = chartBtn.iconH = ToolBar.BTN_SIZE;
			chartBtn.w = chartBtn.h = ToolBar.BTN_SIZE;
			chartBtn.setIcons("chart_up", "chart_over", "chart_down");
			chartBtn.tips = '图表';
			centerBtnsC.addChild(chartBtn);
			chartBtn.addEventListener(MouseEvent.CLICK, addChartHander, false, 0, true);
			
			
			//图片插入面板
			img_up;
			img_over;
			img_down;
			imgBtn.iconW = imgBtn.iconH = ToolBar.BTN_SIZE;
			imgBtn.w = imgBtn.h = ToolBar.BTN_SIZE;
			imgBtn.x = chartBtn.width + gap;
			imgBtn.setIcons("img_up", "img_over", "img_down");
			imgBtn.tips = '图片';
			centerBtnsC.addChild(imgBtn);
			imgBtn.addEventListener(MouseEvent.CLICK, addImgHandler, false, 0, true);
			
			//图形创建面板
			shape_up;
			shape_over;
			shape_down;
			
			addBtn.iconW = addBtn.iconH = ToolBar.BTN_SIZE;
			addBtn.w = addBtn.h = ToolBar.BTN_SIZE;
			addBtn.setIcons("shape_up", "shape_over", "shape_down");
			addBtn.tips = '图形';
			addBtn.x = imgBtn.x + imgBtn.width + gap;
			centerBtnsC.addChild(addBtn);
			addBtn.addEventListener(MouseEvent.CLICK, addHandler, false, 0, true);
			
			style_up;
			style_over;
			style_down;
			themeBtn.iconW = themeBtn.iconH = ToolBar.BTN_SIZE;
			themeBtn.w = themeBtn.h = ToolBar.BTN_SIZE;
			themeBtn.setIcons("style_up", "style_over", "style_down");
			themeBtn.tips = '主题';
			centerBtnsC.addChild(themeBtn);
			themeBtn.x = addBtn.x + addBtn.width + gap;
			themeBtn.addEventListener(MouseEvent.CLICK, openThemeHandler, false, 0, true);
			
			
			
			//---------------------------------------------------------------------------------------------
			
			
			
			ctner.addChild(customButtonContainer);
			
			tb.main.kvsCore.addEventListener(UndoRedoEvent.ENABLE, enableHandler, false, 0, true);
			tb.main.kvsCore.addEventListener(UndoRedoEvent.DISABLE, disableHandler, false, 0, true);
			
			this.redoBtn.addEventListener(MouseEvent.CLICK, redoHandler);
			this.undoBtn.addEventListener(MouseEvent.CLICK, undoHandler);
		}
		
		
		//---------------------------------------------------
		//
		//
		// 撤销控制
		//
		//
		//----------------------------------------------------
		
		/**
		 */		
		private function enableHandler(evt:UndoRedoEvent):void
		{
			if (evt.operation == "undo")
				this.undoBtn.selected = false;
			else if (evt.operation == "redo")
				this.redoBtn.selected = false;
		}
		
		/**
		 */		
		private function disableHandler(evt:UndoRedoEvent):void
		{
			if (evt.operation == "undo")
				this.undoBtn.selected = true;
			else if (evt.operation == "redo")
				this.redoBtn.selected = true;
		}
		
		
		
		/**
		 */		
		private function undoHandler(evt:MouseEvent):void
		{
			tb.main.kvsCore.undo();
		}
		
		private function redoHandler(evt:MouseEvent):void
		{
			tb.main.kvsCore.redo();
		}
		
			
		/**
		 */		
		override public function updateLayout():void
		{
			tb.renderBG();
			
			previewBtn.x = 20;
			previewBtn.y = (tb.h - previewBtn.height) / 2;
			
			undoBtn.x = previewBtn.width + previewBtn.x + 50;
			undoBtn.y = (tb.h - undoBtn.height) / 2;
			
			redoBtn.x = undoBtn.x + undoBtn.width + 10;
			redoBtn.y = (tb.h - redoBtn.height) / 2;
			
			centerBtnsC.x = (tb.w - centerBtnsC.width) / 2;
			centerBtnsC.y = (tb.h - centerBtnsC.height) / 2;
			
			layoutCustomBtnC();
		}
		
		/**
		 * 中间按钮区域容器 
		 */		
		public var centerBtnsC:Sprite = new Sprite;
		
		/**
		 * 自定义按钮之间的间距
		 */		
		internal var customBtnGap:uint = 8;
		
		/**
		 */		
		internal var previewBtn:IconBtn = new IconBtn;
		
		/**
		 * 撤销按钮
		 */		
		public var undoBtn:IconBtn = new IconBtn();
		
		/**
		 * 反撤销按钮
		 */	
		public var redoBtn:IconBtn = new IconBtn;
		
		
		/**
		 * 元素创建按钮，点击后会弹出元素创建面板 
		 */		
		public var addBtn:IconBtn = new IconBtn;
		
		/**
		 * 图片插入按钮 
		 */		
		public var imgBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		public var chartBtn:IconBtn = new IconBtn;
		
		/**
		 * 风格设置按钮，点击后会弹出风格设置面板，用于设置风格和背景； 
		 */		
		public var themeBtn:IconBtn = new IconBtn;
		
		/**
		 * 自定义按钮的容器，自定义按钮由外部定义，位于工具条的右侧 
		 */		
		public var customButtonContainer:Sprite = new Sprite;
		
	}
}