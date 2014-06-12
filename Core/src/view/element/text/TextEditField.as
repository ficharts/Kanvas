package view.element.text
{
	import com.kvs.ui.label.TextDrawer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.CFFHinting;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import model.vo.ElementVO;
	import model.vo.TextVO;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	import view.element.ElementBase;
	import view.element.IEditElement;
	import view.element.state.IEditShapeState;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	
	/**
	 * 文本框， 有三种状态， 非选择状态(usualState), 选择状态(selectedState)， 编辑状态(editState)
	 */
	public class TextEditField extends ElementBase implements IEditElement, ITextFlowLabel, IAutoGroupElement
	{
		
		/**
		 */		
		public function TextEditField(vo:ElementVO)
		{
			super(vo);
			
			vo.xml = <text/>;
			textDrawer = new TextDrawer(this);
			shape.visible = false;
			
		}
		
		/**
		 */		
		override public function toShotcut(renderable:Boolean = false):void
		{
			super.toShotcut(renderable);
			if (renderable)
			{
				if (visible && stageWidth > minRenderSize && stageHeight > minRenderSize)
				{
					shape.visible = false;
					textCanvas.visible = true;
				}
			}
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
			
			FlowTextManager.updateTexLayout(text, textManager, fixWidth);
			var bound:Rectangle = textManager.getContentBounds();
			textVO.width  = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			renderAfterLabelRender();
			checkTextBm(true);// 文本渲染时要强制重新截图
		}
		
		/**
		 * 检测截图是否满足要求
		 */		
		public function checkTextBm(force:Boolean = false):void
		{
			if (visible || force)
			{
				textDrawer.checkTextBm(graphics, textCanvas, textVO.scale * parent.scaleX, false, force);
			}
		}
		
		
		/**
		 */		
		public function afterReRender():void
		{
			var bound:Rectangle = textManager.getContentBounds();
			textVO.width  = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			renderAfterLabelRender();
			checkTextBm(true);
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
			
			_canvas.addChild(shape);
			_canvas.addChild(textCanvas = new Sprite);
			addChild(_canvas);
			
			textManager = new TextContainerManager(textCanvas);
			textManager.editingMode = EditingMode.READ_ONLY;
			
			textLayoutFormat = new TextLayoutFormat;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			textLayoutFormat.textAlign = TextAlign.LEFT;
			textLayoutFormat.breakOpportunity = BreakOpportunity.AUTO;
			
			textManager.hostFormat = textLayoutFormat;
		}
		
		/**
		 */		
		override public function get canvas():DisplayObject
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
		
		
		
		public function get smooth():Boolean
		{
			return __smooth;
		}
		
		public function set smooth(value:Boolean):void
		{
			if (__smooth!= value)
			{
				__smooth = value;
				if (stageWidth > stage.stageWidth || stageHeight > stage.stageHeight)
				{
					textCanvas.visible = smooth;
					shape.visible = !smooth;
				}
				else
				{
					textCanvas.visible = true;
					shape.visible = false;
				}
			}
		}
		private var __smooth:Boolean = true;
		
		
		
		
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