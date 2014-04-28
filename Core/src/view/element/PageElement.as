package view.element
{
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Sprite;
	
	import model.vo.PageVO;
	
	import modules.pages.PageEvent;
	
	import view.element.state.ElementPrevState;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	
	/**
	 * 页面
	 */	
	public final class PageElement extends ElementBase implements IAutoGroupElement
	{
		public function PageElement(vo:PageVO)
		{
			super(vo);
			
			xmlData = <page/>;
			_screenshot = false;
			_elementPageConvertable = false;
			
			mouseChildren = true;			
			//vo.addEventListener(PageEvent.DELETE_PAGE_FROM_UI, deletePageHandler);
			//vo.addEventListener(PageEvent.UPDATE_PAGE_INDEX, updatePageIndex);
		}
		
		override public function disable():void
		{
			super.disable();
			
			//使得放大时，页面编号依旧可被点击
			mouseChildren = true;
		}
		
		/**
		 */		
		/*private function updatePageIndex(evt:PageEvent):void
		{
			drawPageNum();
		}*/
		
		/**
		 */		
		override public function exportData():XML
		{
			super.exportData();
			
			xmlData.@index = pageVO.index;
			
			return xmlData;
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
			
			//numShape.visible = false;
		}
		
		/**
		 */		
		override public function returnFromPrevState():void
		{
			super.returnFromPrevState();
			
			//numShape.visible = true;
			this.render();
		}
		
		override public function toSelectedState():void
		{
			super.toSelectedState();
			pageVO.dispatchEvent(new PageEvent(PageEvent.PAGE_SELECTED, pageVO, false));
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
			
			//layoutPageNum();
		}
		
		/**
		 * 页面点击有可能会点击到页面编号
		 */		
		/*override public function clicked():void
		{
			if (clickMoveControl.clickTarget == numShape)
			{
				dispatchEvent(new PageEvent(PageEvent.PAGE_NUM_CLICKED, vo as PageVO, true));
				pageVO.dispatchEvent(new PageEvent(PageEvent.PAGE_SELECTED, pageVO, false));
			}
			else
			{
				currentState.clicked();
			}
		}*/
		
		/**
		 *  保证页面编号控制在和尺寸内
		 * 
		 */		
		/*public function layoutPageNum(s:Number = NaN):void
		{
			var h:Number;
			var s:Number;
			
			//尺寸缩放时需要临时取表象的信息
			
			if (isNaN(s))
				s = vo.scale;
			
			numShape.width = numShape.height = height * .5;
			var temSize:Number = numShape.width * s * parent.scaleX;
			
			if (temSize > maxNumSize)
			{
				var size:Number = maxNumSize / s / parent.scaleX;
				
				numShape.width  = size;
				numShape.height = size;
			}
			
			numShape.x = - width * .5 - numShape.width * .5;
			numShape.y = - numShape.height;
		}*/
		
		/**
		 */		
		/*private function drawPageNum(size:Number = 20):void
		{
			numShape.graphics.clear();
			
			numLabel.text = (pageVO.index + 1).toString();
			numLabel.render();
			numLabel.x = - numLabel.width  * .5;
			numLabel.y = - numLabel.height * .5;
				
			numShape.graphics.lineStyle(1, 0, 0.8);
			numShape.graphics.beginFill(0x555555, .8);
			numShape.graphics.drawCircle(0, 0, size * .5);
			numShape.graphics.endFill();
		}*/
		
		/**
		 */		
		/*private var maxNumSize:uint = 26;
		
		private var numLabel:LabelUI = new LabelUI;*/
		
		/**
		 * 用来绘制页面序号 
		 */		
		//private var numShape:Sprite = new Sprite;
		
		/**
		 */		
		override public function del():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.DEL_PAGE, this));
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var newVO:PageVO = new PageVO;
			newVO.index = pageVO.index + 1;
			newVO.type = pageVO.type;
			
			return new PageElement(cloneVO(newVO) as PageVO);
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