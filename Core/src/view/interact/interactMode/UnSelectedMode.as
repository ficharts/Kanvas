package view.interact.interactMode
{
	import com.kvs.ui.toolTips.ToolTipsEvent;
	import com.kvs.ui.toolTips.ToolTipsManager;
	
	import commands.Command;
	
	import flash.ui.Mouse;
	
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	
	/**
	 * 整体处于非选择状态
	 */	
	public class UnSelectedMode extends ModeBase
	{
		public function UnSelectedMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		
		/**
		 */		
		override public function autoZoom():void
		{
			mainMediator.sendNotification(Command.AUTO_ZOOM);
		}
		
		/**
		 */		
		override public function drawShotFrame():void
		{
			mainMediator.drawShotFrame(mainMediator.coreApp.bound);
		}
		
		/**
		 */		
		override public function addPage(index:uint):void
		{
			mainMediator.pageManager.addPageFromUI(index);
		}
		
		/**
		 */		
		override public function undo():void
		{
			mainMediator.sendNotification(Command.UN_DO);
		}
		
		/**
		 */		
		override public function redo():void
		{
			mainMediator.sendNotification(Command.RE_DO);
		}
		
		/**
		 */		
		override public function paste():void
		{
			mainMediator.sendNotification(Command.PASTE_ELEMENT);
		}
		
		/**
		 */		
		override public function toEditMode():void
		{
			mainMediator.disableKeyboardControl();
			mainMediator.currentMode = mainMediator.editMode;
		}
		
		/**
		 */		
		override public function toSelectMode():void
		{
			mainMediator.currentMode = mainMediator.selectedMode;
			mainMediator.currentMode.showSelector();
		}
		
		/**
		 * 
		 */		
		override public function toPageEditMode():void
		{
			mainMediator.disableKeyboardControl();
			mainMediator.currentMode = mainMediator.pageEditMode;
			
			mainMediator.zoomMoveControl.disable();
		}
		
		/**
		 */		
		override public function toPrevMode():void
		{
			//切换之预览模式时需清除镜头框
			mainMediator.cameraShotShape.graphics.clear();
			mainMediator.restoryCanvasState();
			
			mainMediator.currentMode = mainMediator.preMode;
			prevElements();
			
			if (mainMediator.pageManager.length > 0)
				mainMediator.pageManager.indexWithZoom = mainMediator.pageManager.index;//进入多页面播放模式
			else
				mainMediator.zoomMoveControl.zoomAuto();
			
			mainMediator.previewCliker.enable = true;
			mainMediator.mouseController.autoHide = true;
			Mouse.hide();
			
			//防止鼠标位于预览按钮上时，
			this.mainMediator.mainUI.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}
		
		/**
		 * 单选模式时，取消选择当前元件
		 */		
		override public function unSelectElement(element:ElementBase):void
		{
			mainMediator.checkAutoGroup(element);
		}
		
		/**
		 * 多选模式下被调用，选择当前点击元件
		 */		
		override public function multiSelectElement(element:ElementBase):void
		{
			mainMediator.sendNotification(Command.SElECT_ELEMENT, element);
		}
		
		/**
		 * 创建文本
		 */	
	    override public function stageBGClicked():void
		{
			mainMediator.sendNotification(Command.PRE_CREATE_TEXT);
		}
	}
}