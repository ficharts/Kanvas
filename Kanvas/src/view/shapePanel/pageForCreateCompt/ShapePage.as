package view.shapePanel.pageForCreateCompt
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.dec.NullPad;
	
	import flash.events.MouseEvent;
	
	import view.ItemSelector;

	/**
	 * 控制创建图形是的交互行为，点击还是拖拽方式创建
	 */	
	public class ShapePage extends ItemSelectorPageBase implements IClickMove
	{
		public function ShapePage()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		}
		
		/**
		 */		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			if (evt.target is ItemSelector)
				curSelectedShape = evt.target as ItemSelector;
			else
				curSelectedShape = null;
		}
		
		/**
		 * 当前被点击的图形
		 */		
		private var curSelectedShape:ItemSelector;
		
		/**
		 */			
		public function moveOff(xOff:Number, yOff:Number):void
		{
			
		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
			if (curSelectedShape)
			{
				var evt:CreateShapeEvent = new CreateShapeEvent(CreateShapeEvent.SHAPE_CLICKED);
				evt.shapeIcon = curSelectedShape;
				
				this.dispatchEvent(evt);
			}
		}
		
		/**
		 */		
		public function startMove():void
		{
			if (curSelectedShape)
			{
				var evt:CreateShapeEvent = new CreateShapeEvent(CreateShapeEvent.SHAPE_START_MOVE);
				evt.shapeIcon = curSelectedShape;
				
				this.dispatchEvent(evt);
			}
		}
			
		/**
		 */			
		public function stopMove():void
		{
			if (curSelectedShape)
			{
				var evt:CreateShapeEvent = new CreateShapeEvent(CreateShapeEvent.SHAPE_STOP_MOVE);
				this.dispatchEvent(evt);
			}
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			clickMoveControl = new ClickMoveControl(this, this);
		}
		
		/**
		 */		
		private var clickMoveControl:ClickMoveControl;
		
	}
}