package control.panelState
{
	import com.greensock.TweenLite;
	import com.kvs.ui.Panel;
	import com.kvs.ui.button.IconBtn;
	
	import control.NavControl;
	
	import model.CoreFacade;
	
	import view.element.text.TextEditField;

	/**
	 */	
	public class PanelState
	{
		public function PanelState(nav:NavControl)
		{
			this.nav = nav;
		}
		
		/**
		 */		
		public function get rightPanelWidth():Number
		{
			return 0;
		}
		
		/**
		 */		
		public function alginToRight():void
		{
			
		}
		
		/**
		 */		
		public function open():void
		{
			
		}
		
		/**
		 */		
		public function close():void
		{
			
		}
		
		/**
		 */		
		public function toChartPanel():void
		{
			
		}
		
		public function toThemePanel():void
		{
			
		}
		
		/**
		 */		
		public function toShapePanel():void
		{
			
		}
		
		/**
		 */		
		public function toClose():void
		{
			
		}
		
		/**
		 */		
		protected function openTargetPanel(btn:IconBtn, panel:Panel):void
		{
			btn.selected = true;
			panel.open(app.stage.stageWidth - panel.w, app.toolBar.h);
			
			this.app.updateKvsContenBound();
			moveZBLeft(panel);
			
			autofit(1, 0);
		}
		
		/**
		 */		
		protected function moveZBRight():void
		{
			TweenLite.killTweensOf(app.zoomToolBar, false);
			TweenLite.to(app.zoomToolBar, .5, {x:app.stage.stageWidth - app.zoomToolBar.width - 20});
		}
		
		/**
		 */		
		protected function moveZBLeft(panel:Panel):void
		{
			TweenLite.killTweensOf(app.zoomToolBar, false);
			TweenLite.to(app.zoomToolBar, .5, {x:app.stage.stageWidth - panel.w - app.zoomToolBar.width - 20});
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
		protected function get app():Kanvas
		{
			return nav.app;
		}
		
		/**
		 */		
		protected var nav:NavControl;
	}
}