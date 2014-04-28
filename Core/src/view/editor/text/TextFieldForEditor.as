package view.editor.text
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	
	import flash.display.Sprite;
	import flash.system.IME;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.FontLookup;
	
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.events.UpdateCompleteEvent;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import model.vo.TextVO;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	/**
	 * 文本编辑器中的文本输入框
	 */	
	public class TextFieldForEditor extends Sprite implements ITextFlowLabel
	{
		public function TextFieldForEditor(editor:TextEditor)
		{
		   this.editor = editor;
		   
			IME.enabled = true;
			//IME.conversionMode = IMEConversionMode.CHINESE;
			
			super();
			init();
		}
		
		/**
		 */		
		private var editor:TextEditor;
		
		/**
		 */		
		public function get textWidth():Number
		{
			return textManager.compositionWidth;
		}
		
		/**
		 */		
		public function get textHeight():Number
		{
			return textManager.compositionHeight;
		}
		
		/**
		 */		
		public function set textWidth(value:Number):void
		{
			ifMutiLine = true;
			fixWidth = value;
			
			_text = textManager.getText();
			FlowTextManager.updateTexLayout(text, textManager, fixWidth);
		}
		
		/**
		 */		
		private var _fixWidth:Number = 0;

		/**
		 */
		public function get fixWidth():Number
		{
			return _fixWidth;
		}

		/**
		 * @private
		 */
		public function set fixWidth(value:Number):void
		{
			_fixWidth = value;
		}

		/**
		 */		
		private var _ifMutiLine:Boolean = false;

		/**
		 */
		public function get ifMutiLine():Boolean
		{
			return _ifMutiLine;
		}

		/**
		 * @private
		 */
		public function set ifMutiLine(value:Boolean):void
		{
			_ifMutiLine = value;
		}
		
		
		
		
		//--------------------------------------------------
		//
		//
		// 
		//  文本编辑
		//
		//
		//--------------------------------------------------
		
		/**
		 */		
		public function afterReRender():void
		{
		}		
		/**
		 */		
		public function setFocusForCreate():void
		{
			selectText(0, 0);
		}
		
		/**
		 */		
		public function setFocusForEdit():void
		{
			var index:int = textManager.getTextFlow().textLength;
			selectText(index, index);
		}
		
		/**
		 * 清空文本内容
		 */		
		public function reset():void
		{
			scaleX = scaleY = 1;
			rotation = 0;
			ifMutiLine = false;
			
			this.text = '';
			textManager.setText(text);
			FlowTextManager.initTextSize(textManager);
		}
		
		/**
		 * 文本输入过程中动态更新文本框尺寸
		 */		
		private function update(evt:UpdateCompleteEvent):void
		{
			_text = textManager.getText();
			
			if (ifMutiLine)
				FlowTextManager.updateTexLayout(text, textManager, fixWidth);
			else
				FlowTextManager.updateTexLayout(text, textManager);
			
			editor.textScale.update();
			editor.updateAfterInput();
		}
		
		/**
		 * 以新的文本模型应用, 比例为文本编辑器中文本框的比例
		 */		
		public function applyTextVO(textVO:TextVO):void
		{
			_text = textVO.text;
			
			FlowTextManager.applyTextVOToTextField(this, textVO);
		}
		
		/**
		 * 应用新样式, 样式来自与样式模板，所以要附加上
		 * 
		 * 文本的内容，宽高等信息
		 */		
		public function applyStyle(textVO:TextVO):void
		{
			textVO.text = _text;
			textVO.ifMutiLine = this.ifMutiLine;
			textVO.width = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			
			FlowTextManager.applyTextVOToTextField(this, textVO);
		}
		
		/**
		 * 设置文本的颜色
		 */		
		public function updateColor(color:Object):void
		{
			textLayoutFormat.color = color;
			
			textManager.hostFormat = textLayoutFormat;
			textManager.updateContainer();
		}
			
		/**
		 * 将编辑文本的样式，宽高，文本内容等信息同步至文本VO
		 */		
		public function getTextVO(vo:TextVO):void
		{
			vo.text = this.text;
			vo.ifMutiLine = this.ifMutiLine;
			
			vo.width = textManager.compositionWidth;
			vo.height = textManager.compositionHeight;
			vo.label = new LabelStyle;
			
			vo.color = textLayoutFormat.color;
			vo.size = textLayoutFormat.fontSize;
			
			XMLVOMapper.fuck(<format font={textLayoutFormat.fontFamily} color='${color}' size='${size}'/>, vo.label.format);
		}
		
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		//
		// 初始化
		//
		//
		//----------------------------------------------
		
		/**
		 */		
		private function init():void
		{
			textLayoutFormat.fontLookup = FontLookup.DEVICE;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			textLayoutFormat.textAlign = TextAlign.LEFT;
			
			textManager = new TextContainerManager(this);
			textManager.editingMode = EditingMode.READ_WRITE;
			textManager.hostFormat = textLayoutFormat;
			
			textManager.horizontalScrollPolicy = ScrollPolicy.OFF;
			textManager.verticalScrollPolicy = ScrollPolicy.OFF;
			
			FlowTextManager.initTextSize(textManager);
			
			// 注册嵌入字体文本重绘
			FlowTextManager.register(this);
		}
		
		/**
		 */		
		public function activit():void
		{
			textManager.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, update);
		}
		
		/**
		 */		
		public function deactivit():void
		{
			textManager.removeEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, update);
		}

		/**
		 */		
		private var _txtManager:TextContainerManager;

		/**
		 */
		public function get textManager():TextContainerManager
		{
			return _txtManager;
		}

		/**
		 * @private
		 */
		public function set textManager(value:TextContainerManager):void
		{
			_txtManager = value;
		}

		/**
		 */		
		private var _layoutTextFormat:TextLayoutFormat = new TextLayoutFormat;

		/**
		 */
		public function get textLayoutFormat():TextLayoutFormat
		{
			return _layoutTextFormat;
		}

		/**
		 * @private
		 */
		public function set textLayoutFormat(value:TextLayoutFormat):void
		{
			_layoutTextFormat = value;
		}

		/**
		 */		
		private function selectText(startPos:int, endPos:int):void
		{
			var editM:ISelectionManager = textManager.beginInteraction();
			editM.selectRange(startPos, startPos);
			editM.setFocus();
			
			this.activit();
		}
		
		/**
		 */		
		public function setFocus():void
		{
			var editM:ISelectionManager = textManager.beginInteraction();
			editM.setFocus();
		}
		
		/**
		 */		
		public function get text():String
		{
			return _text;
		}
		
		/**
		 */		
		public function set text(value:String):void
		{
			_text = value;
		}
		
		/**
		 */		
		private var _text:String;
		
		/**
		 */		
		public function get enableIME():Boolean
		{
			return true;
		}
		
		/**
		 */		
		public function get imeMode():String
		{
			return _imeMode
		}
		
		private var _imeMode:String;
		
		/**
		 *  @private
		 */
		public function set imeMode(value:String):void
		{
			_imeMode = value;
		}
		
	}
}