package view.ui.canvas
{
	import flash.display.Sprite;
	
	import view.ui.ICanvasLayout;

	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public class DrawState extends CanvasStateBase
	{
		public function DrawState(canvas:Canvas)
		{
			super(canvas);
		}
		
		/**
		 */		
		override public function toRenderState():void
		{
			canvas.curRenderState = canvas.renderState;
			
			var item:ICanvasLayout;
			for each (item in this.canvas.items)
				item.endDraw();
			
			canvas.graphics.clear();
		}
		
		/**
		 */		
		override public function upate():void
		{
			var item:ICanvasLayout;
			for each (item in this.canvas.items)
				item.drawView(this.canvas);
			
		}
	}
}