package view.ui.canvas
{
	import flash.display.Sprite;
	
	import flashx.textLayout.elements.BreakElement;
	
	import view.element.ElementBase;
	import view.element.IElement;
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
		 * 绘制时如果有一个元件尺寸超出显示区域，则可见元件统统采用渲染模式；
		 * 
		 * 否则，大家都采用绘制模式；
		 * 
		 */		
		override public function upate():void
		{
			canvas.graphics.clear();
			
			var item:ICanvasLayout;
			
			elementsInView.length = 0;
			for each (item in this.canvas.items)
			{
				item.visible = false;//
				item.ifInViewRect = canvas.checkVisible(item);
				if (item.ifInViewRect)	
					elementsInView.push(item);
			}
			
			for each (item in elementsInView)
			{
				//只要有一个可见元件实体可见，则所有可见元件正式渲染
				if (item.checkTrueRender())
				{
					for each (item in elementsInView)
					{
						item.visible = true;
						item.renderView();
					}
					
					break;
					return;
				}
				
			}
			
			for each (item in elementsInView)
				item.drawView(this.canvas);
			
		}
		
		/**
		 */		
		private var elementsInView:Vector.<ICanvasLayout> = new Vector.<ICanvasLayout>;
	}
}