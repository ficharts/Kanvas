package view.interact.multiSelect
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import commands.Command;
	
	import view.element.ElementBase;
	
	/**
	 * 多选模式
	 */	
	public class MultiSelectState extends MultiSelectStateBase
	{
		public function MultiSelectState(mdt:MultiSelectControl)
		{
			super(mdt);
			
			XMLVOMapper.fuck(styleXML, style);
		}
		
		/**
		 */		
		override public function startDragSelect():void
		{
			startX = mainMediator.coreApp.mouseX;
			startY = mainMediator.coreApp.mouseY;
		}
		
		/**
		 */		
		override public function stopDragSelect():void
		{
			control.checkGroupAfterDragSelect();
			
			//先检测碰撞，再清空图形
			control.dragSlectUI.graphics.clear();
		}
		
		/**
		 */		
		override public function dragSelecting():void
		{
			control.dragSlectUI.graphics.clear();
			StyleManager.setLineStyle(control.dragSlectUI.graphics, style.getBorder, style);
			control.dragSlectUI.graphics.beginFill(uint(style.getFill.color), Number(style.getFill.alpha));
			control.dragSlectUI.graphics.drawRect(startX, startY, 
				 mainMediator.coreApp.mouseX - startX, mainMediator.coreApp.mouseY - startY);
			control.dragSlectUI.graphics.endFill();
		}
		
		/**
		 */		
		private var style:Style = new Style;
		
		/**
		 */		
		private var styleXML:XML = <style>
										<border color='#DDDDDD'/>
										<fill color='#DDDDDD' alpha='0.3'/>
									</style>
		
		/**
		 */		
		private var startX:Number = 0;
		private var startY:Number = 0;
		
		
		/**
		 * 非选状态时选择当前点击元件，选择模式下创建临时组合或者添加元件到临时组合
		 */		
		override public function unSelectElementClicked(element:ElementBase):void
		{
			mainMediator.currentMode.unSelectElementClicked(element);
		}
		
		/**
		 * 点击到子元素时，从临时组合中提出子元素；
		 */		
		override public function temGroupChildClicked(element:ElementBase):void
		{
			var index:uint = control.childElements.indexOf(element)
			control.childElements.splice(index, 1);
			element.toUnSelectedState();
			
			//仅剩一个时，取消临时组合
			if (control.childElements.length == 1)
			{
				var el:ElementBase = control.childElements[0];
				control.clear();
				control.coreMdt.sendNotification(Command.UN_SELECT_ELEMENT);
				control.coreMdt.sendNotification(Command.SElECT_ELEMENT, el);
			}
			else
			{
				control.updateSelecterLayout();
			}
		}
		
		/**
		 */		
		override public function selectedElementDown(element:ElementBase):void
		{
		}
		
		/**
		 */		
		override public function selectedElementClicked(element:ElementBase):void
		{
		}
	}
}