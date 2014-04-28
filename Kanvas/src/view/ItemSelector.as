package view
{
	import com.kvs.ui.IconShape;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.ElementProxy;
	
	/**
	 * 图形创建面板，样式面板，快捷工具条中都需要频繁用到选择单元;
	 * 
	 * 可为选择单元绑定交互行为和指令，点击/拖动时触发指令;
	 * 
	 * 选择单元上还具有元数据，可用于指令参数或其他扩展用途
	 */	
	public class ItemSelector extends IconShape
	{
		public function ItemSelector()
		{
			super();
			
			ifSmoothImg = true;
		}
		
		/**
		 */		
		private var _type:String;

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		/**
		 */		
		private var _shape:ElementProxy;

		/**
		 */
		public function get shape():ElementProxy
		{
			return _shape;
		}

		/**
		 * @private
		 */
		public function set shape(value:ElementProxy):void
		{
			_shape = value;
		}
		
		/**
		 */		
		override protected function renderBG():void
		{
			canvas.graphics.clear();
			currState.width = this.w;
			currState.height = this.h;
			currState.tx = 0;
			currState.ty = 0;
			StyleManager.setFillStyle(canvas.graphics, currState);
			canvas.graphics.drawEllipse(currState.tx, currState.ty, this.w, this.h);
			canvas.graphics.endFill();
			
			frameCanvas.graphics.clear();
			StyleManager.setLineStyle(frameCanvas.graphics, currState.getBorder, currState);
			canvas.graphics.drawEllipse(currState.tx, currState.ty, this.w, this.h);
			frameCanvas.graphics.endFill();
		}

	}
}