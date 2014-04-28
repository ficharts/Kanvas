package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ElementVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 热点图
	 */	
	public class HotspotElement extends ElementBase implements IAutoGroupElement
	{
		public function HotspotElement(vo:ElementVO)
		{
			super(vo);
			_screenshot = false;
			xmlData = <hotspot/>;
		}
		
		/**
		 * 热点在预览状态时不显示
		 */		
		override public function toPrevState():void
		{
			super.toPrevState();
			
			this.graphics.clear();
		}
		
		/**
		 */		
		override public function returnFromPrevState():void
		{
			super.returnFromPrevState();
			
			this.render();
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			graphics.clear();
			
			// 中心点为注册点
			vo.style.tx = - vo.width / 2;
			vo.style.ty = - vo.height / 2;
			
			vo.style.width = vo.width;
			vo.style.height = vo.height;
			
			StyleManager.drawRect(this, vo.style, vo);
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var hotVO:ElementVO = new ElementVO;
			
			return new HotspotElement(cloneVO(hotVO));
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
	}
}