package control
{
	import com.greensock.TweenLite;
	import com.kvs.ui.Panel;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import model.CoreFacade;
	
	import util.undoRedo.UndoRedoEvent;
	
	import view.element.text.TextEditField;

	/**
	 * 主程序交互控制器, 
	 * 
	 * 控制图形面板，样式面板，自定义属性面板等的交互动作
	 */	
	public class NavControl
	{
		public function NavControl(main:Kanvas)
		{
			this.app = main;
			
			app.addEventListener(InteractEvent.INSERT_IMAGE, insertImageHandler, false, 0, true);
			app.addEventListener(InteractEvent.OPEN_SHAPE_PANEL, openShapePanelHandler, false, 0, true);
			app.addEventListener(InteractEvent.CLOSE_SHAPE_PANE, closeShapePanelHandler, false, 0, true);
			
			app.addEventListener(InteractEvent.OPEN_THEME_PANEL, openThemePanelHandler, false, 0, true);
			app.addEventListener(InteractEvent.CLOSE_THEME_PANEL, closeThemePanelHandler, false, 0, true);
			
			app.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
			app.addEventListener(InteractEvent.PREVIEW, previewPanelHandler, false, 0, true);
		}
		
		/**
		 */		
		public function toPageEditMode():void
		{
			closePanels();
			app.toolBar.toPageEditMode();
			
			app.zoomToolBar.visible = false;
		}
		
		/**
		 */		
		public function cancelPageEdit():void
		{
			app.kvsCore.cancelPageEdit();
			toNormal();
		}
		
		/**
		 */		
		public function confirmPageEdit():void
		{
			toNormal();
		}
		
		/**
		 * 整体应用进入到正常模式下
		 */		
		public function toNormal():void
		{
			openPanels();
			
			app.kvsCore.toUnselect();
			app.toolBar.toNormalMode();
			
			app.zoomToolBar.visible = true;
			
		}
		
		/**
		 */		
		private function toChartEdit(evt:KVSEvent):void
		{
			closePanels();
			app.toolBar.toChartEditMode();
			
			app.zoomToolBar.visible = false;
		}
		
		/**
		 */		
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			//全屏预览模式, 从F1 ～  F9 任意键按下触发全屏
			if (evt.keyCode >= 112 && evt.keyCode <= 120)
			{
				toPreview();
			}
		}
		
		/**
		 */		
		private function previewPanelHandler(evt:InteractEvent):void
		{
			toPreview();
		}
		
		/**
		 * 进入预览模式
		 */		
		public function toPreview():void
		{
			app.stage.displayState = (CoreApp.isAIR) ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.FULL_SCREEN;
			app.updateKvsContenBound();
			app.kvsCore.toPreview();
			
			app.stage.addEventListener(FullScreenEvent.FULL_SCREEN, closeFullScreenHandler);
			
			app.zoomToolBar.y = 10000;
			
			closePanels();
			TweenLite.to(app.toolBar, 0.5, {y: - app.toolBar.h});
		}
		
		
		/**
		 */		
		private var isThemPanelOpen:Boolean = false;
		
		/**
		 */		
		private var isShapePanelOpen:Boolean = false;
		
		/**
		 */		
		private function closeFullScreenHandler(evt:FullScreenEvent):void
		{
			app.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, closeFullScreenHandler);
			
			openPanels();
			TweenLite.to(app.toolBar, 0.5, {y: 0});
			
			app.zoomToolBar.y = (app.stage.stageHeight - app.zoomToolBar.height) * .5;
			
			app.updateKvsContenBound();
			app.kvsCore.returnFromPrev();
		}
		
		/**
		 */		
		private function openThemePanelHandler(evt:InteractEvent):void
		{
			if (app.shapePanel.isOpen)
				_closeShapePanel();
			
			_openThemePanel();
			
			this.app.updateKvsContenBound();
			
			autofit(1, 0);
		}
		
		/**
		 * 关闭除工具条以外的面板 
		 * 
		 */		
		private function closePanels():void
		{
			if (app.themePanel.isOpen)
			{
				isThemPanelOpen = true;
				_closeThemPanel();
			}
			else
			{
				isThemPanelOpen = false;
			}
			
			if (app.shapePanel.isOpen)
			{
				isShapePanelOpen = true;	
				_closeShapePanel();
			}
			else
			{
				isShapePanelOpen = false;
			}
			
			TweenLite.to(app.pagePanel, 0.5, {x: - app.pagePanel.w - 50/*防止滚动条可见，给的值稍大*/});
		}
		
		/**
		 */		
		private function openPanels():void
		{
			if (isThemPanelOpen)
			{
				_openThemePanel();
			}
			else if (isShapePanelOpen)
			{
				_openShapePanel();
			}
			
			TweenLite.to(app.pagePanel, 0.5, {x: 0});
		}
		
		/**
		 */		
		private function autofit(xDir:int = 0, yDir:int = 0):void
		{
			if (CoreFacade.coreMediator.currentElement)
			{
				if (CoreFacade.coreMediator.currentElement is TextEditField && CoreFacade.coreMediator.coreApp.textEditor.visible)
					CoreFacade.coreMediator.autofitController.autofitEditorModifyText(CoreFacade.coreMediator.currentElement, xDir, yDir);
				else
					CoreFacade.coreMediator.autofitController.autofitElementPosition(CoreFacade.coreMediator.currentElement, xDir, yDir);
			}
			else if (CoreFacade.coreMediator.coreApp.textEditor.visible)
			{
				CoreFacade.coreMediator.autofitController.autofitEditorInputText(xDir, yDir);
			}
		}
		
		/**
		 */		
		private function _openThemePanel():void
		{
			app.toolBar.themeBtn.selected = true;
			app.themePanel.open(app.stage.stageWidth - app.themePanel.w, app.toolBar.h);
			
			moveZBLeft(app.themePanel);
		}
		
		/**
		 */		
		private function closeThemePanelHandler(evt:InteractEvent):void
		{
			_closeThemPanel();
			
			this.app.updateKvsContenBound();
		}
		
		/**
		 */		
		private function _closeThemPanel():void
		{
			app.toolBar.themeBtn.selected = false;
			app.themePanel.close(app.stage.stageWidth, app.toolBar.h);
			
			moveZBRight();
		}
		
		/**
		 */		
		private function moveZBRight():void
		{
			TweenLite.killTweensOf(app.zoomToolBar, false);
			TweenLite.to(app.zoomToolBar, .5, {x:app.stage.stageWidth - app.zoomToolBar.width - 20});
		}
		
		/**
		 */		
		private function moveZBLeft(panel:Panel):void
		{
			TweenLite.killTweensOf(app.zoomToolBar, false);
			TweenLite.to(app.zoomToolBar, .5, {x:app.stage.stageWidth - panel.w - app.zoomToolBar.width - 20});
		}
			
		
		/**
		 */		
		private function openShapePanelHandler(evt:InteractEvent):void
		{
			if (app.themePanel.isOpen)
				_closeThemPanel();
			
			_openShapePanel();
			
			this.app.updateKvsContenBound();
			
			
			autofit(1, 0);
		}
		
		/**
		 */		
		private function insertImageHandler(evt:InteractEvent):void
		{
			app.kvsCore.insertIMG();
		}
		
		/**
		 */		
		private function _openShapePanel():void
		{
			app.toolBar.addBtn.selected = true;
			app.shapePanel.open(app.stage.stageWidth - app.shapePanel.w, app.toolBar.h);
			
			moveZBLeft(app.shapePanel);
			
			
		}

		/**
		 */		
		private function closeShapePanelHandler(evt:InteractEvent):void
		{
			_closeShapePanel();
			
			this.app.updateKvsContenBound();
		}
		
		
		/**
		 */		
		private function _closeShapePanel():void
		{
			app.toolBar.addBtn.selected = false;
			app.shapePanel.close(app.stage.stageWidth, app.toolBar.h);
			
			moveZBRight();
		}
		
		
		
		
		/**
		 */		
		private var app:Kanvas;
	}
}