package view.ui.canvas
{
	import flash.display.Sprite;
	
	import view.element.IElement;
	import view.ui.ICanvasLayout;

	/**
	 */	
	public class RenderState extends CanvasStateBase
	{
		public function RenderState(canvas:Canvas)
		{
			super(canvas);
		}
		
		/**
		 */		
		override public function toDrawState():void
		{
			canvas.curRenderState = canvas.drawState;
			
			var item:ICanvasLayout;
			for each (item in this.canvas.items)
				item.startDraw(canvas);
				
			canvas.graphics.clear();
		}
		
		/**
		 */		
		override public function upate():void
		{
			var item:ICanvasLayout;
			for each (item in this.canvas.items)
				item.renderView();
		}
	}
}