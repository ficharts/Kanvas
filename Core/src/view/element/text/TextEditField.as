package view.element.text
{
	import com.kvs.ui.label.TextDrawer;
	import com.kvs.utils.XMLConfigKit.style.elements.TextFormatStyle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
			
			textDrawer = new TextDrawer(this);
			xmlData = <text/>;
			
			
		}
		
		/**
		 * 负责将文本绘制为位图 
		 */		
		private var textDrawer:TextDrawer;
		
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
		
		private var minRenderSize:Number = 5;
		
		/**
		 */		
		override public function toPreview(renderable:Boolean = false):void
		{
			super.toPreview(renderable);
			
			/*if (renderable)
			{
				if (visible && stageWidth > minRenderSize && stageHeight > minRenderSize)
				{
					checkTextBm();
				}
				
			}*/
		}
		
		/**
		 */			
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.text);
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = <text/>;
			xmlData = super.exportData();
			
			xmlData.@ifMutiLine = textVO.ifMutiLine;
			xmlData.@isCustomColor = textVO.isCustomColor;
			
			//防止文本有特殊字符
			if (textVO.text && textVO.text != "")
				xmlData.appendChild(XML('<text><![CDATA[' + textVO.text + ']]></text>'));
			
			xmlData.@font = (textVO.label.format as TextFormatStyle).font;
			xmlData.@size = textVO.size;
			
			return xmlData;
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var textVO:TextVO = new TextVO;
			
			textVO.text = this.textVO.text;
			textVO.ifMutiLine = this.textVO.ifMutiLine;
			textVO.styleID = this.textVO.styleID;
			textVO.isCustomColor = this.textVO.isCustomColor;
			
			return new TextEditField(cloneVO(textVO) as TextVO);
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
			curTextState.toSelected();
		}
		
		/**
		 * 进入没选中状态
		 */
		override public function toUnSelectedState():void
		{
			curTextState.toUnSelected();
		}
		
		/**
		 * 文字进入编辑模式
		 */
		public function toEditState():void
		{
			curTextState.toEditState();
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
		 */		
		private function get curTextState():IEditShapeState
		{
			return currentState as IEditShapeState
		}
		
		/**
		 * 编辑状态
		 */
		internal var editTextState:IEditShapeState;
		
		
		
		
		
		
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
			textVO.width  = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			
			renderAfterLabelRender();
			checkTextBm();
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
			
			addChild(textCanvas = new Sprite);
			
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
		public function clearText():void
		{
			textManager.setText("");
			textManager.updateContainer();
			graphics.clear();
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
				textCanvas.visible = smooth;
				shape.visible = !smooth;
			}
		}
		
		private var __smooth:Boolean = true;
		
		/**
		 */		
		private var textCanvas:Sprite = new Sprite;
	}
}