package view.editor.text
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import util.textFlow.FlowTextManager;
	
	/**
	 */	
	public class SizeControl implements IClickMove
	{
		public function SizeControl(holder:TextScaleHolder)
		{
			this.holder = holder;
			
			sizeControl = new ClickMoveControl(this, holder.sizePoint);
		}
		
		/**
		 */		
		private var sizeControl:ClickMoveControl;
		
		/**
		 */		
		private var holder:TextScaleHolder;
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			var dis:Number = getDis() - oldDis;
			
			if (Math.cos(rad) > 0)
				dis *= - 1;
			
			var newSize:Number = oldWidth + dis;
			if (newSize < minWidth)
				newSize = minWidth;
				
			holder.editor.fieldWidth = newSize;
			holder.updateFieldToProxy();
			holder.update();
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
			oldDis = getDis();
			oldWidth = holder.editor.fieldWidth;
		}
		
		/**
		 */		
		private var oldDis:Number = 0;
		
		/**
		 */		
		private var oldWidth:Number = 0;
		
		/**
		 */		
		private function getDis():Number
		{
			var dis:Number = 0;
			
			var tan:Number = Math.tan(rad);
			var xDis:Number = holder.stage.mouseX - holder.editor.x;
			var yDis:Number = holder.stage.mouseY - holder.editor.y;
			
			dis = (tan * xDis - yDis) / Math.sqrt(tan * tan + 1);
			
			return dis;
		}
		
		/**
		 */		
		private function get rad():Number
		{
			return holder.rotation * Math.PI / 180 - Math.PI / 2;
		}
		
		/**
		 */		
		private function get minWidth():Number
		{
			return FlowTextManager.txtMinWidth * holder.editor.fieldScale;
		}
		
		/**
		 */		
		public function stopMove():void
		{
			
		}
	}
}