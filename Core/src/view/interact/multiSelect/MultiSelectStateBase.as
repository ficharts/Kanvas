package view.interact.multiSelect
{
	import commands.Command;
	
	import view.element.ElementBase;
	import view.interact.CoreMediator;

	/**
	 * 多选/正常选择模式的基类
	 * 
	 * 多选模式下可以点击选择多个元素，框选元素，并对多选元素进行编辑
	 */	
	public class MultiSelectStateBase
	{
		public function MultiSelectStateBase(ctr:MultiSelectControl)
		{
			this.control = ctr;
		}
		
		
		/**
		 * 开始独立图形的移动
		 */		
		public function startMoveElement(ele:ElementBase):void
		{
			
		}
		
		/**
		 */		
		public function stopMoveElement():void
		{
			
		}
		
		
		
		
		
		//--------------------------------------
		//
		// 框选接口
		//
		//--------------------------------------
		
		/**
		 */		
		public function startDragSelect():void
		{
			
		}
		
		/**
		 */		
		public function stopDragSelect():void
		{
		}
		
		/**
		 */		
		public function dragSelecting():void
		{
			
		}
		
		
		
		
		
		
		//--------------------------------------
		//
		// 子元素的点击与拖动
		//
		//--------------------------------------
		
		public function childStartMove():void
		{
			
		}
		
		/**
		 */		
		public function childStopMove():void
		{
			
		}
		
		/**
		 */		
		public function childDown():void
		{
		}
		
		/**
		 */		
		public function childUp():void
		{
		}
		
		
		
		
		
		
		
		
		
		/**
		 * 单选模式下会用到
		 */		
		public function unSelectElementDown(element:ElementBase):void
		{
		}
		
		/**
		 * 选择元件或者添加元件到临时组合中
		 */		
		public function unSelectElementClicked(element:ElementBase):void
		{
		}
		
		/**
		 * 仅单个元件被按下时才触发，用于单选模式下
		 */		
		public function selectedElementDown(element:ElementBase):void
		{
			
		}
		
		/**
		 * 仅单个元件被点击时才触发，用于单选模式下
		 */		
		public function selectedElementClicked(element:ElementBase):void
		{
			
		}
		
		/**
		 * 临时组合元素被按下，设定智能组合内容，准备拖动
		 */		
		public function temGroupDown():void
		{
		}
		
		/**
		 * 当点击到子元件时，选择当前元件，把当前元件从组合中剔除；
		 * 
		 * 否则什么都不做
		 */		
		public function temGroupChildClicked(element:ElementBase):void
		{
			
		}
		
		/**
		 *  取消选择或者创建文字
		 */	
		public function stageBGClicked():void
		{
			mainMediator.currentMode.stageBGClicked();
		}
		
		/**
		 */		
		protected function get mainMediator():CoreMediator
		{
			return control.coreMdt;
		}
		
		/**
		 */		
		protected var control:MultiSelectControl;
	}
}