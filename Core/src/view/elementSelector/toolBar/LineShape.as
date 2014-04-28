package view.elementSelector.toolBar
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import model.ConfigInitor;

	/**
	 * 线条的工具条
	 */	
	public class LineShape extends BorderShape
	{
		public function LineShape(toolBar:ToolBarController)
		{
			super(toolBar);
		}
		
		/**
		 */		
		override public function render():void
		{
			toolBar.addBtn(toolBar.styleBtn);
			toolBar.addBtn(addBtn);
			toolBar.addBtn(cutBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			toolBar.addBtn(toolBar.delBtn);
			
			resetColorIconStyle();
		}
		
		/**
		 */		
		override public function layout(style:Style):void
		{
			var scale:Number = toolBar.selector.layoutTransformer.canvasScale * toolBar.selector.element.scale;
			var newX:Number = toolBar.selector.element.vo.width / 2 * scale;
			var rad:Number = Math.PI / 2 + selectorRotation * Math.PI / 180;
			
			var px:Number;
			var py:Number;
			
			//手动获取hover高度，防止r与实际不同步
			r = toolBar.selector.coreMdt.coreApp.hoverEffect.getHoverHeight(toolBar.selector.layoutInfo.height, toolBar.selector.element) / 2 * scale + 5;
			
			if (selectorRotation == 0)
			{
				px =  Math.cos(rad) * r;
				py = - Math.sin(rad) * r;
			}
			else if (selectorRotation > 0 && selectorRotation < 180)
			{
				px = - newX + Math.cos(rad) * r;
				py = - Math.sin(rad) * r;
			}
			else
			{
				px = newX + Math.cos(rad) * r;
				py = - Math.sin(rad) * r;
			}
		
			//画布所方时，防止两个动画冲突导致的工具条动画停顿
			if (TweenMax.isTweening(toolBar.selector.coreMdt.coreApp.canvas))
			{
				toolBar.x = px;
				toolBar.y = py;
			}
			else
			{
				TweenLite.killTweensOf(toolBar, false);
				TweenLite.to(toolBar, 0.2, {x: px, y: py, ease: Cubic.easeOut});
			}
			
		}
		
		/**
		 */		
		private var r:uint = 11;
	}
}