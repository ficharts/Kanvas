package view.elementSelector.customPoint
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import commands.Command;
	
	import flash.display.Sprite;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.IPointControl;

	/**
	 * 特殊图形会有自定义控制点，例如五角星的内半径控制；
	 * 
	 * 具体的控制算法和布局算法由图形自己控制
	 */	
	public class CustomPointControl extends Sprite implements IClickMove, IPointControl
	{
		public function CustomPointControl(selector:ElementSelector)
		{
			this.selector = selector;
			
			pointUI.styleConfig = pointStyle;
			addChild(pointUI);
				
			clickMoveControl = new ClickMoveControl(this, pointUI);
		}
		
		/**
		 */		
		public function layout(style:Style):void
		{
			if (this.visible)
			{
				customShape.layoutCustomPoint(selector, style);
			}
		}
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			customShape.customRender(selector, this);
		}
		
		/**
		 */		
		public function clicked():void
		{
			
		}
		
		/**
		 */		
		public function startMove():void
		{
			oldPropertyObj = {};
			oldPropertyObj.x = selector.element.vo.x;
			oldPropertyObj.y = selector.element.vo.y;
			
			for each (var propertyName:String in customShape.propertyNameArray)
				oldPropertyObj[propertyName] = selector.element.vo[propertyName];
			
		}
		
		/**
		 */			
		public function stopMove():void
		{
			var index:Vector.<int> = selector.coreMdt.autoLayerController.autoLayer(selector.element);
			if (index)
			{
				oldPropertyObj.indexChangeElement = selector.coreMdt.autoLayerController.indexChangeElement;
				oldPropertyObj.index = index;
			}
			
			selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
		}
		
		/**
		 */		
		private function get customShape():ICustomShape
		{
			return selector.element as ICustomShape;
		}
		
		private var oldPropertyObj:Object;
		
		/**
		 */		
		private var clickMoveControl:ClickMoveControl;
		
		/**
		 */		
		private var selector:ElementSelector;
		
		/**
		 */		
		private var pointUI:ControlPointBase = new ControlPointBase;
		
		/**
		 */		
		private var pointStyle:XML = <states>
											<normal tx='-5' ty='-5' width='10' height='10' radius='5'>
												<border thickness='1' alpha='1' color='#373737'/>
												<fill color='#6a6a6a, #585858' alpha='0.7, 0.7' angle='90'/>
											</normal>
											<hover tx='-6' ty='-6' width='12' height='12' radius='6'>
												<border thickness='1' alpha='1' color='#373737'/>
												<fill color='#6a6a6a, #585858' alpha='1, 1' angle='90'/>
											</hover>
											<down tx='-6' ty='-6' width='12' height='12' radius='6'>
												<border color='#6a6a6a' thickness='1'/>
												<fill color='#6a6a6a' alpha='0.7'/>
											</down>
										</states>
		
	}
}