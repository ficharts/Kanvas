package view.editor.text
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import flash.display.Stage;
	
	/**
	 */	
	public class ScalPointControl implements IClickMove
	{
		/**
		 */		
		public function ScalPointControl(holder:TextScaleHolder)
		{
			this.scaleHolder = holder;
			
			clickMoveControl = new ClickMoveControl(this, scaleHolder.scalePoint);
		}
		
		/**
		 */		
		private var clickMoveControl:ClickMoveControl;
		
		/**
		 */		
		private var scaleHolder:TextScaleHolder;
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			// 比例的增量
			var scaleDis:Number = dis / curDis;
			var field:TextFieldForEditor = scaleHolder.editor.textField;
			field.scaleX = field.scaleY = curScale * Math.abs(scaleDis);
			
			scaleHolder.updateFieldToProxy();
			scaleHolder.update();
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
			curScale = scaleHolder.editor.textField.scaleX;
			curDis = dis;
		}
		
		/**
		 */		
		private function get dis():Number
		{
			var xDis:Number = scaleHolder.stage.mouseX - scaleHolder.editor.x;
			var yDis:Number = scaleHolder.stage.mouseY - scaleHolder.editor.y;
			
			return Math.sqrt(xDis * xDis + yDis * yDis);
		}
		
		/**
		 */		
		private var curDis:Number = 0;
		
		/**
		 */		
		private var curScale:Number = 1;
		
		/**
		 */		
		public function stopMove():void
		{
		}
	}
}