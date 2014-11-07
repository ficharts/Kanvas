package view.element.text
{
	import com.kvs.ui.label.TextDrawer;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PerformaceTest;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.CFFHinting;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import model.vo.ElementVO;
	import model.vo.TextVO;
	
	import modules.pages.PageEvent;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	import view.element.ElementBase;
	import view.element.IEditElement;
	import view.element.IText;
	import view.element.state.IEditShapeState;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	import view.ui.IMainUIMediator;
	import view.ui.canvas.Canvas;
	import view.ui.canvas.ElementLayoutModel;
	
	
	/**
	 * 文本框， 有三种状态， 非选择状态(usualState), 选择状态(selectedState)， 编辑状态(editState)
	 */
	public class TextEditField extends ElementBase implements IEditElement, ITextFlowLabel, IAutoGroupElement, IText
	{
		
		/**
		 */		
		public function TextEditField(vo:ElementVO)
		{
			super(vo);
			
			vo.xml = <text/>;
			textDrawer = new TextDrawer(this);
			textDrawer.ifDrawText = false;
			
			initRenderPoints(4);
		}
		
		
		/**
		 */		
		override public function startDraw(canvas:Canvas):void
		{
			this.visible = false;
		}
		
		/**
		 */		
		override public function drawView(canvas:Canvas):void
		{
			if (canvas.checkVisible(this) == false) return;
			if (this.canvas.alpha < 1) return;
			
			renderPoints[0].x = - vo.width / 2;
			renderPoints[0].y = - vo.height / 2;
			
			renderPoints[1].x =  vo.width / 2;
			renderPoints[1].y = - vo.height / 2;
			
			renderPoints[2].x =  vo.width / 2;
			renderPoints[2].y =  vo.height / 2;
			
			renderPoints[3].x =  - vo.width / 2;
			renderPoints[3].y =  vo.height / 2;
			
			var layout:ElementLayoutModel = canvas.getElementLayout(this);
			canvas.transformRenderPoints(renderPoints, layout);
			
			//checkTextBm();
			//var bmd:BitmapData = textDrawer.textBMD;
			
			var math:Matrix = new Matrix;
			math.rotate(MathUtil.angleToRadian(layout.rotation));
			
			var scale:Number = vo.width * layout.scaleX / bmd.width;
			math.scale(scale, scale);
			
			var p:Point = renderPoints[0];
			
			math.tx = p.x;
			math.ty = p.y;
			
			canvas.graphics.beginBitmapFill(bmd, math, false, false);
			canvas.graphics.moveTo(p.x, p.y);
			
			p = renderPoints[1];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[2];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[3];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[0];
			canvas.graphics.lineTo(p.x, p.y);
			
			canvas.graphics.endFill();
		}
		
		/**
		 */		
		override public function endDraw():void
		{
			super.endDraw();
		}
		
		/**
		 */		
		override public function clickedForPreview(cmt:IMainUIMediator):void
		{
			var t:String = textVO.text;
			
			if (t.indexOf("http://") != - 1 || t.indexOf("https://") != - 1)
				flash.net.navigateToURL(new URLRequest(t), "_blank");
			else
				cmt.zoomElement(vo);
		}
		
		/**
		 */		
		public function useBitmap():void
		{
		}
		
		/**
		 */		
		public function useText():void
		{
		}
		
		/**
		 */		
		override public function toPreview(renderable:Boolean = false):void
		{
			super.toPreview(renderable);
		}
		
		/**
		 */			
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.text);
		}
		
		
		
		
		
		//---------------------------------------------
		//
		//
		// 文字状态切换
		//
		//
		//----------------------------------------------
		
		/**
		 */		
		override public function toSelectedState():void
		{
			currentState.toSelected();
			
			//选择页面时，对应的页面列表中的页面需被选中
			if (this.isPage)
				vo.pageVO.dispatchEvent(new PageEvent(PageEvent.PAGE_SELECTED, vo.pageVO, false));
		}
		
		/**
		 * 进入没选中状态
		 */
		override public function toUnSelectedState():void
		{
			currentState.toUnSelected();
		}
		
		/**
		 * 文字进入编辑模式
		 */
		public function toEditState():void
		{
			IEditShapeState(currentState).toEditState();
		}
		
		/**
		 */		
		override protected function initState():void
		{
			selectedState = new TextSelectState(this);
			unSelectedState = new TextUnselectedState(this);
			editTextState = new TextEditState(this);
			multiSelectedState = new TextMutiSelectedState(this);
			groupState = new TextGroupState(this); 
			prevState = new TextPrevState(this);
			
			currentState = unSelectedState;
		}
		
		
		/**
		 * 编辑状态
		 */
		internal var editTextState:IEditShapeState;
		
		/**
		 */		
		public function clearText():void
		{
			textManager.setText("");
			textManager.updateContainer();
			graphics.clear();
			
			
		}
		
		
		
		
		//---------------------------------------------------------
		//
		//
		//
		//  文字渲染
		// 
		//
		//
		//---------------------------------------------------------
		
		
		public function get template():Boolean
		{
			return textVO.template;
		}
		
		public function set template(value:Boolean):void
		{
			textVO.template = value;
		}
		
		/**
		 */		
		public function get text():String
		{
			return textVO.text;
		}
		
		/**
		 */		
		public function set text(value:String):void
		{
			textVO.text = value;
		}
		
		/**
		 * 渲染文字
		 */
		override public function render():void
		{
			FlowTextManager.renderTextVOLabel(this, textVO);
			renderAfterLabelRender();
			
			bmd = canvas.getElemetBmd(textCanvas);
		}
		
		/**
		 */		
		private var bmd:BitmapData;
		
		/**
		 */		
		override public function renderView():void
		{
			super.renderView();
			
			
		}
		
		/**
		 * 检测截图是否满足要求
		 */		
		public function checkTextBm(force:Boolean = false):void
		{
			textDrawer.checkTextBm(graphics, textCanvas, textVO.scale * canvas.scale, false, force);
		}
		
		/**
		 */		
		public function afterReRender():void
		{
			var bound:Rectangle = textManager.getContentBounds();
			textVO.width  = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			
			renderAfterLabelRender();
		}
		
		/**
		 */
		public function get ifMutiLine():Boolean
		{
			return textVO.ifMutiLine;
		}
		
		/**
		 * @private
		 */
		public function set ifMutiLine(value:Boolean):void
		{
			textVO.ifMutiLine = value;
		}
		
		/**
		 * 
		 */		
		public function get fixWidth():Number
		{
			return vo.width;
		}
		
		/**
		 * @private
		 */
		public function set fixWidth(value:Number):void
		{
			vo.width = value;
		}
		
		/**
		 */		
		private function renderAfterLabelRender():void
		{
			textCanvas.x = - textVO.width  * .5;
			textCanvas.y = - textVO.height * .5;
			
			super.render();
		}
		
		/**
		 * 初始化
		 */		
		override protected function preRender():void
		{
			super.preRender();
			
			_canvas.addChild(graphicShape);
			_canvas.addChild(textCanvas = new Sprite);
			addChild(_canvas);
			
			textManager = new TextContainerManager(textCanvas);
			textManager.editingMode = EditingMode.READ_ONLY;
			
			textLayoutFormat = new TextLayoutFormat;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			textLayoutFormat.textAlign = TextAlign.LEFT;
			textLayoutFormat.breakOpportunity = BreakOpportunity.AUTO;
		}
		
		/**
		 */		
		override public function get flashShape():DisplayObject
		{
			return _canvas;
		}
		
		/**
		 */		
		private var _canvas:Sprite = new Sprite;
		
		/**
		 */		
		private var _textManager:TextContainerManager;

		/**
		 */
		public function get textManager():TextContainerManager
		{
			return _textManager;
		}

		/**
		 * @private
		 */
		public function set textManager(value:TextContainerManager):void
		{
			_textManager = value;
		}

		/**
		 */		
		private var _textLyoutFormat:TextLayoutFormat;

		/**
		 */
		public function get textLayoutFormat():TextLayoutFormat
		{
			return _textLyoutFormat;
		}

		/**
		 * @private
		 */
		public function set textLayoutFormat(value:TextLayoutFormat):void
		{
			_textLyoutFormat = value;
		}
		
		/**
		 */		
		public function get textVO():TextVO
		{
			return vo as TextVO;
		}
		
		/**
		 */		
		private var textCanvas:Sprite = new Sprite;
		
		/**
		 * 负责将文本绘制为位图 
		 */		
		private var textDrawer:TextDrawer;
		
		
		private var minRenderSize:Number = 5;
	}
}