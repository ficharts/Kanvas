package view.element
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.PageVO;
	
	import view.element.state.ElementPrevState;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	
	/**
	 * 页面, 虚框
	 */	
	public final class PageElement extends ElementBase implements IAutoGroupElement
	{
		public function PageElement(vo:PageVO)
		{
			super(vo);
			
			vo.xml = <page/>;
			_screenshot = false;
			_elementPageConvertable = false;
			mouseChildren = true;
		}
		
		/**
		 * 非选择状态下的页面，从左侧页面列表也可以删除
		 */		
		override public function del():void
		{
			this.dispatchEvent(new ElementEvent(ElementEvent.DEL_SHAPE, this));
		}
		
		/**
		 */		
		override public function disable():void
		{
			super.disable();
			//使得放大时，页面编号依旧可被点击
			mouseChildren = true;
		}
		
		override protected function init():void
		{
			super.init();
		}
		
		
		/**
		 */		
		override protected function preRender():void
		{
			super.preRender();
			setPage(pageVO);
		}
		
		/**
		 * 热点在预览状态时不显示
		 */		
		override public function toPrevState():void
		{
			super.toPrevState();
			
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(- width * .5, - height * .5, width, height);
			graphics.endFill();
		}
		
		/**
		 */		
		override public function returnFromPrevState():void
		{
			super.returnFromPrevState();
			
			render();
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			//页面在预览模式时，不显示页面边框
			if (currentState is ElementPrevState)
				return;
			
			// 中心点为注册点
			if (vo.style)
			{
				graphics.clear();
				
				vo.style.tx = - width  * .5;
				vo.style.ty = - height * .5;
				
				vo.style.width  = width;
				vo.style.height = height;
				
				var left  :Number = vo.style.tx;
				var top   :Number = vo.style.ty;
				var right :Number = vo.style.tx + vo.style.width;
				var bottom:Number = vo.style.ty + vo.style.height;
				
				var frameSize:Number = height / 16;
				
				//防止边框画布缩放后看着太细
				//if (frameSize * vo.scale * parent.scaleX < 2)
					//frameSize = 2 / vo.scale / parent.scaleX;
				
				//从左上角开始绘制
				StyleManager.setShapeStyle(vo.style, graphics, vo);
				graphics.moveTo(left, top);
				graphics.lineTo(left, bottom);
				graphics.lineTo(left + frameSize * 2, bottom);
				graphics.lineTo(left + frameSize * 2, bottom - frameSize);
				graphics.lineTo(left + frameSize, bottom - frameSize);
				graphics.lineTo(left + frameSize, top + frameSize);
				graphics.lineTo(left + frameSize * 2, top + frameSize);
				graphics.lineTo(left + frameSize * 2, top);
				graphics.lineTo(left, top);
				graphics.endFill();
				
				//从右上角开始绘制
				StyleManager.setFillStyle(graphics, vo.style, vo);
				graphics.moveTo(right, top);
				graphics.lineTo(right, bottom);
				graphics.lineTo(right - frameSize * 2, bottom);
				graphics.lineTo(right - frameSize * 2, bottom - frameSize);
				graphics.lineTo(right - frameSize, bottom - frameSize);
				graphics.lineTo(right - frameSize, top + frameSize);
				graphics.lineTo(right - frameSize * 2, top + frameSize);
				graphics.lineTo(right - frameSize * 2, top);
				graphics.lineTo(right, top);
				graphics.endFill();
			}
		}
		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.cameraShape);
		}
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = true;
			ViewUtil.show(selector.sizeControl);
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 隐藏型变控制点， 图形被取消选择后会调用此方法
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = false;
			ViewUtil.hide(selector.sizeControl);
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			selector.frame.alpha = 0.5;
			ViewUtil.hide(selector.sizeControl);
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			selector.frame.alpha = 1;
			ViewUtil.show(selector.sizeControl);
			ViewUtil.show(selector.scaleRollControl);
		}
		
		
		override public function get isPage():Boolean
		{
			return true;
		}
		
		private function get pageVO():PageVO
		{
			return vo as PageVO;
		}
		
	}
}