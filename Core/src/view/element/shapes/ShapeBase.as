package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	
	import model.vo.ElementVO;
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 图形基类
	 */
	public class ShapeBase extends ElementBase implements IAutoGroupElement
	{
		/**
		 * 
		 */		
		public function ShapeBase(vo:ShapeVO)
		{
			super(vo);
			
			//this.cacheAsBitmap = true;
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			super.exportData();
			
			if (vo.styleType == 'fill')
			{
				vo.xml.@fillAlpha = vo.style.getFill.alpha;
			}
			else if (vo.styleType == 'border' || vo.styleType == 'line')
			{
				vo.xml.@borderAlpha = vo.style.getBorder.alpha;
			}
			else if (vo.styleType == 'shape')
			{
				vo.xml.@borderColor = vo.style.getBorder.color.toString(16);
				vo.xml.@borderAlpha = vo.style.getBorder.alpha;
				vo.xml.@fillAlpha   = vo.style.getFill.alpha;
			}
			else
			{
				
			}
			
			return vo.xml;
		}
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			if (vo.styleType == 'fill')
			{
				toolbar.setCurToolBar(toolbar.fillShape);
			}
			else if (vo.styleType == 'border')
			{
				toolbar.setCurToolBar(toolbar.borderShape);
			}
			else if (vo.styleType == 'shape')
			{
				toolbar.setCurToolBar(toolbar.wholeShape);
			}
			else
			{
				toolbar.setCurToolBar(toolbar.defaultShape);
			}
		}
		
		/**
		 */		
		protected function get shapeVO():ShapeVO
		{
			return vo as ShapeVO;
		}
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			super.showControlPoints(selector);
			
			ViewUtil.show(selector.sizeControl);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			super.hideControlPoints(selector);
			
			ViewUtil.hide(selector.sizeControl)
		}
		
		/**
		 * 
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			super.hideFrameOnMdown(selector);
			
			ViewUtil.hide(selector.sizeControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			super.showSelectorFrame(selector);
			
			ViewUtil.show(selector.sizeControl);
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
		}
		
	}
}