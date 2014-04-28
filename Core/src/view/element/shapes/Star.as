package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import model.vo.ElementVO;
	import model.vo.StarVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.customPoint.CustomPointControl;
	import view.elementSelector.customPoint.ICustomShape;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 星形
	 */	
	public class Star extends ElementBase implements ICustomShape, IAutoGroupElement
	{
		public function Star(vo:StarVO)
		{
			super(vo);
			
			xmlData = <star/>
		}
		
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = super.exportData();
			
			xmlData.@innerRadius = starVO.innerRadius;
			
			return xmlData;
		}
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			if (vo.styleID == 'Fill')
			{
				toolbar.setCurToolBar(toolbar.fillShape);
			}
			else if (vo.styleID == 'Border')
			{
				toolbar.setCurToolBar(toolbar.borderShape);
			}
			else
			{
				toolbar.setCurToolBar(toolbar.defaultShape);
			}
		}
		
		/**
		 */		
		public function customRender(selector:ElementSelector, control:CustomPointControl):void
		{
			var dis:Number = selector.curRDis;
			
			starVO.innerRadius = dis / (vo.width / 2 * selector.layoutInfo.transformer.canvasScale * vo.scale);
			
			if (starVO.innerRadius > 1)
				starVO.innerRadius = 1;
				
			this.render();
			selector.render();
		}
		
		/**
		 */		
		public function get propertyNameArray():Array
		{
			return _propertyNameArray;
		}
		
		private const _propertyNameArray:Array = ["innerRadius"];
		
		/**
		 */		
		public function layoutCustomPoint(selector:ElementSelector, style:Style):void
		{
			var rad:Number = - 0.3 * Math.PI;
			var scale:Number = selector.layoutInfo.transformer.canvasScale * vo.scale;
			selector.customPointControl.x = Math.cos(rad) * style.scale * vo.width  / 2 * starVO.innerRadius;
			selector.customPointControl.y = Math.sin(rad) * style.scale * vo.height / 2 * starVO.innerRadius;
		}
		
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			super.showControlPoints(selector);
			
			ViewUtil.show(selector.customPointControl);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			super.hideControlPoints(selector);
			
			ViewUtil.hide(selector.customPointControl)
		}
		
		/**
		 * 
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			super.hideFrameOnMdown(selector);
			
			ViewUtil.hide(selector.customPointControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			super.showSelectorFrame(selector);
			
			ViewUtil.show(selector.customPointControl);
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
			
			StyleManager.drawStar(this, vo.style, starVO.innerRadius, vo);
		}
		
		/**
		 */		
		private function get starVO():StarVO
		{
			return vo as StarVO;
		}
			
		/**
		 */		
		override public function clone():ElementBase
		{
			var starVO:StarVO = new StarVO;
			starVO.innerRadius = (this.vo as StarVO).innerRadius;
			
			return new Star(cloneVO(starVO) as StarVO);
		}
		
		/**
		 */		
		override protected function cloneVO(newVO:ElementVO):ElementVO
		{
			super.cloneVO(newVO);
			
			newVO.type = vo.type;
			newVO.styleID = vo.styleID;
			
			
			return newVO;
		}
		
	}
}