package view.interact.multiSelect
{
	import commands.Command;
	
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	
	/**
	 * 单选模式
	 */	
	public class NormaSelectState extends MultiSelectStateBase
	{
		public function NormaSelectState(mdt:MultiSelectControl)
		{
			super(mdt);
		}
		
		/**
		 * 开始独立图形的移动
		 */		
		override public function startMoveElement(ele:ElementBase):void
		{
			control.coreMdt.elementMoveController.startMove(ele);
		}
		
		/**
		 */		
		override public function stopMoveElement():void
		{
			control.coreMdt.elementMoveController.stopMove();
		}
		
		
		
		/**
		 */		
		override public function childStartMove():void
		{
			mainMediator.elementMoveController.startMove(control.temGroupElement);
		}
		
		/**
		 */		
		override public function childStopMove():void
		{
			mainMediator.elementMoveController.stopMove();
		}
		
		/**
		 */		
		override public function childDown():void
		{
			checkGroup();
		}
		
		/**
		 */		
		override public function childUp():void
		{
			mainMediator.selector.showFrameOnMup();
		}
		
		/**
		 */		
		override public function temGroupDown():void
		{
			checkGroup();
		}
		
		/**
		 */		
		private function checkGroup():void
		{
			mainMediator.selector.hideFrameOnMdown();
			
			//对临时组合的智能组合
			control.autoTemGroup();
		}
		
		
		/**
		 */		
		override public function stopDragSelect():void
		{
			control.dragSlectUI.graphics.clear();
		}
		
		
		
		
		
		
		
		/**
		 * 单选模式时，取消选择当前元件
		 */		
		override public function unSelectElementDown(element:ElementBase):void
		{
			control.coreMdt.currentMode.unSelectElementDown(element);
		}
		
		/**
		 * 选择当前点击的元件
		 */		
		override public function unSelectElementClicked(element:ElementBase):void
		{
			control.coreMdt.sendNotification(Command.SElECT_ELEMENT, element);
		}
		
		/**
		 */		
		override public function selectedElementDown(element:ElementBase):void
		{
			mainMediator.selector.hideFrameOnMdown();
			mainMediator.checkAutoGroup(element);
		}
		
		/**
		 * 仅单个元件被点击时才触发，用于单选模式下或多选但只有一个元件被选择
		 */		
		override public function selectedElementClicked(element:ElementBase):void
		{
			mainMediator.sendNotification(Command.PRE_CREATE_TEXT);
		}
		
		/**
		 * 点击到子元素时，不做任何操作
		 */		
		override public function temGroupChildClicked(element:ElementBase):void
		{
			
		}
		
	}
}