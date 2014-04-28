package view.elementSelector.toolBar
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import view.element.ElementBase;
	import view.element.PageElement;

	/**
	 */	
	public class ToolBarBase
	{
		/**
		 */		
		public function ToolBarBase(toolBar:ToolBarController)
		{
			this.toolBar = toolBar;
		}
		
		/**
		 */		
		public function init():void
		{
			
		}
		
		/**
		 */		
		public function stylePanelOpen():void
		{
			
		}
		
		/**
		 */		
		public function prevStyle(styleBtn:StyleBtn):void
		{
			
		}
		
		/**
		 */		
		public function reBackStyle():void
		{
			
		}
		
		/**
		 */		
		public function styleSelected(styleBtn:StyleBtn):void
		{
			
		}
		
		/**
		 */		
		public function layout(style:Style):void
		{
			var newX:Number = 0;
			var newY:Number = 0;
			
			if (Math.abs(selectorRotation) <= 10)
			{
				newX = 0;
				newY = style.ty - 8;
			}
			else if (selectorRotation > 10 && selectorRotation < 80)
			{
				newX = style.tx;
				newY = style.ty;
			}
			else if (Math.abs(selectorRotation - 90) <= 10)
			{
				newX = style.tx - 8;
				newY = 0;
			}
			else if (selectorRotation > 100 && selectorRotation < 170)
			{
				newX = style.tx - 8;
				newY = - style.ty + 8;
			}
			else if (selectorRotation >= 170 || selectorRotation <= - 170)
			{
				newX = 0;
				newY = - style.ty + 8;
			}
			else if (selectorRotation > - 170 && selectorRotation < - 100)
			{
				newX = - style.tx + 8;
				newY = - style.ty + 8;
			}
			else if (selectorRotation >= - 100 && selectorRotation <= - 80)
			{
				newX = - style.tx + 8;
				newY = 0;
			}
			else if (selectorRotation > - 80 && selectorRotation < 0)
			{
				newX = - style.tx;
				newY = style.ty;
			}
			else
			{
				
			}
			
			//画布所方时，防止两个动画冲突导致的工具条动画停顿
			if (toolBar.selector.coreMdt.zoomMoveControl.isTweening)
			{
				toolBar.x = Math.ceil(newX);
				toolBar.y = Math.ceil(newY);
			}
			else
			{
				TweenLite.killTweensOf(toolBar, false);
				TweenLite.to(toolBar, 0.2, {x:newX, y: newY, ease: Cubic.easeOut});
			}
		}
		
		/**
		 */		
		protected function get selectorRotation():Number
		{
			return toolBar.selector.rotation;	
		}
		
		protected function initPageElementConvertIcons():void
		{
			if (element.elementPageConvertable)
			{
				toolBar.addBtn((element.isPage) ? toolBar.convertElementBtn : toolBar.convertPageBtn);
			}
		}
		
		/**
		 */		
		public function render():void
		{
		}
		
		/**
		 */		
		protected function get element():ElementBase
		{
			return toolBar.selector.element;
		}
		
		/**
		 */		
		protected var toolBar:ToolBarController
	}
}