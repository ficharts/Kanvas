package view.interact
{
	import commands.Command;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import modules.pages.PageEvent;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;

	/**
	 * 对元素的鼠标交互获取，并将这些交互命令交给对应的交互控制器或者命令去处理；
	 * 
	 * 交互模式也可看作是交互控制器，控制着不同交互状态（非选择，选择，编辑）下的行为；
	 * 
	 * 这里是交互消息分发的主出口
	 */	
	public class ElementsInteractor
	{
		public function ElementsInteractor(mainUI:CoreApp, mainMediator:CoreMediator)
		{
			this.mainUI = mainUI;
			this.mainMediator = mainMediator;
			
			// 鼠标滑入滑出效果控制
			mainUI.addEventListener(ElementEvent.OVER_ELEMENT, overElementHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.OUT_ELEMENT, outElementHandler, false, 0, true);
			
			// 图形点击监听
			mainUI.addEventListener(ElementEvent.FIRST_CLICKED, firstClickedHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.RE_CLICKED, reClickedHandler, false, 0, true);
			
			mainUI.addEventListener(ElementEvent.EDIT_TEXT, editTextHandler, false, 0, true);
			
			mainUI.addEventListener(ElementEvent.FIRST_DOWN, firstDownHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.RE_DOWN, reDownHandler, false, 0, true);
			
			//拖动图形监听
			mainUI.addEventListener(ElementEvent.START_MOVE, startMoveHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.STOP_MOVE, stopMoveHandler, false, 0, true);
			
			// 删除指令监听
			mainUI.addEventListener(ElementEvent.DEL_SHAPE, delShapeHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.DEL_IMG, delIMGHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.DEL_TEXT, delTextHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.DEL_PAGE, delPageHandler, false, 0, true);
			mainUI.addEventListener(ElementEvent.CONVERT_PAGE_2_ELEMENT, convertPageHandler, false, 0, true);
			
			//复制粘贴
			mainUI.addEventListener(ElementEvent.COPY_ELEMENT, copyElement);
			mainUI.addEventListener(ElementEvent.COPY_TEM_GROUP, copyTemGroup);
			mainUI.addEventListener(ElementEvent.COPY_GROUP, copyGroup);
			mainUI.addEventListener(ElementEvent.PAST_ELEMENT, pasteElement);
			mainUI.addEventListener(ElementEvent.PASTE_TEM_GROUP, pasteTemGroup);
			mainUI.addEventListener(ElementEvent.PAST_GROUP, pasteGroup);
			
			mainUI.addEventListener(PageEvent.PAGE_NUM_CLICKED, zoomPage);
			
		}
		
		/**
		 */		
		private function zoomPage(evt:PageEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.zoomMoveControl.zoomElement(evt.pageVO);
			mainMediator.toUnSelectedMode();
		}
		
		/**
		 */		
		private function copyElement(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.COPY_ELEMENT);
		}
		
		/**
		 */		
		private function copyTemGroup(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.COPY_TEM_GROUP);
		}
		
		/**
		 */		
		private function copyGroup(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.COPY_GROUP);
		}
		
		/**
		 */		
		private function pasteElement(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.PASTE_ELEMENT);
		}
		
		/**
		 */		
		private function pasteTemGroup(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.PASTE_TEM_GROUP);
		}
		
		/**
		 */		
		private function pasteGroup(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.PAST_GROUP);
		}
		
		/**
		 */		
		private function delShapeHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.DELETE_ElEMENT, evt.element);
		}
		
		/**
		 */		
		private function delIMGHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.sendNotification(Command.DELETE_IMG, evt.element);
		}
		
		/**
		 */		
		private function delTextHandler(evt:ElementEvent):void
		{
		 	evt.stopPropagation();	
			
			mainMediator.sendNotification(Command.DELETE_TEXT, evt.element);
		}
		
		private function delPageHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();	
			
			mainMediator.sendNotification(Command.DELETE_PAGE, evt.element);
		}
		
		private function convertPageHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();	
			
			mainMediator.sendNotification(Command.CONVERT_PAGE_2_ELEMENT, evt.element);
		}
		
		/**
		 */		
		private function overElementHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainUI.hoverEffect.element = evt.element;
			mainUI.hoverEffect.show();
		}
		
		/**
		 */		
		private function outElementHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainUI.hoverEffect.hide();
		}
		
		/**
		 * 开始拖动原件
		 */		
		private function startMoveHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.multiSelectControl.startMoveElement(evt.element);
		}
		
		/**
		 * 拖动元件结束
		 */		
		private function stopMoveHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
				
			mainMediator.multiSelectControl.stopMoveElement();
		}
		
		
		/**
		 * 编辑文本，主应用进入编辑状态, 此时需要关闭键盘感应，关闭型变框
		 */	
		private function editTextHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.setEditorASText();
			mainMediator.editElement(evt.element);
		}
		
		/**
		 * 非选择元素被按下
		 */		
		private function firstDownHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			mainMediator.multiSelectControl.unSelectElementDown(evt.element);
		}
		
		/**
		 * 选择元素被按下
		 */		
		private function reDownHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			mainMediator.multiSelectControl.selectedElementDown(evt.element);
		}
		
		/**
		 * 点击 “非选择状态” 的元件后触发，此时有两种可能，将目标元素切换到选择状态或者
		 * 
		 * 将其纳入多选范围
		 */		
		private function firstClickedHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.multiSelectControl.unSelectElementClicked(evt.element);
		}
		
		/**
		 * 点击处于选择状态的的元件，接下来将创建一个文本框 
		 */		
		private function reClickedHandler(evt:ElementEvent):void
		{
			evt.stopPropagation();
			
			mainMediator.multiSelectControl.selectedElementClicked(evt.element);
		}
		
		
		/**
		 */		
		private var mainMediator:CoreMediator;
			
		/**
		 */		
		private var mainUI:CoreApp;
	}
}